import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:Heritage/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import '../firestore_constants.dart';
import 'package:http/http.dart' as http;

enum ServerType {
  live, //one8 live server
  dev, //one8 development server
  local, //loacl is kinda of using the app with no server but with dummy data
}
Map<ServerType, String> on8Srvers = {
  ServerType.live: "live",
  ServerType.dev: "dev", //"http://3.125.157.246",
  ServerType.local: ""
};


//App server .. to change server only chage type
//Note: after changing server you have to change Firebase
//configration too for ios and android
ServerType appServerType = ServerType.dev;
String userCollection = appServerType.name+ FirestoreConstants.users;
String studentFormCollection = appServerType.name + FirestoreConstants.studentForms;
String groupChatChannel = appServerType.name + FirestoreConstants.groupChatChannel;
String messages = appServerType.name + FirestoreConstants.messages;
String notificationsCollection = appServerType.name + FirestoreConstants.notifications;

final String firebase_message_server_key = "AAAAJXOJzWs:APA91bGWR34oWC3eoHhi04gFw41Xr_6Jo6ztQYAEA73JTATaFs3zycYImuQChm71kBcvfJlWRGZX_kuABlF1ZjYBvn3gqU1rCpgELXK3GnV6nRMXunf06Dw9o1X45Dt1cZmswhx0ITc0";
final String web_vapid_key = "BBIMiM6qxQPsLVjMHIj79ncIyTOFlOQu8L-HXL7n2HYumPFGpsH2Plt-qg5-HWnXjOoOTdZcxyoLdcyVNURyQaU";
final String notifcation_url = "https://fcm.googleapis.com/fcm/send";


class MainService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final FirebaseStorage storageReference = FirebaseStorage.instance;

  //interNetConnectivity
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  CollectionReference userRefrence  = firebaseFirestoreInstance.collection(userCollection);
  var imageStorageRefrrence = storageReference.ref();
  var docuMentStorageRefrrence = storageReference.ref();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status' + e.message.toString());
      return;
    }

    return _updateConnectionStatus(result);
  }
  void initState() {
    initConnectivity();
    connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void dispose() {
    connectivitySubscription.cancel();

  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {

      _connectionStatus = result;
  }

  Future<bool> checkIsUserPresentOrNotMain(String collectioName , String text) async {

    print("emailController.text");
    print(text);
    var querySnapshot = await userRefrence.where(FirestoreConstants.email,isEqualTo: text).get();
    print("querySnapshot.size");
    print(querySnapshot.size);
    if(querySnapshot.size>0){
      /* querySnapshot.docs[0][FirestoreConstnats.email]*/
      return true;
    }else{
      return false;
    }

  }

  Future<void> updateUserDataMain(Map<String, dynamic> data) async {
    data.addAll({FirestoreConstants.updatedAt:FieldValue.serverTimestamp()});
    print(data[FirestoreConstants.uid]);
    userRefrence.doc(data[FirestoreConstants.uid]).update(data);
  }


  Future<void> setUserDataMain(String collectioName ,Map<String, dynamic> data) async {
    data.addAll({FirestoreConstants.updatedAt:FieldValue.serverTimestamp()});
    print(data[FirestoreConstants.uid]);
    userRefrence.doc(data[FirestoreConstants.uid]).set(data);
  }
  Future<UserCredential> registerUserWithPasswordMain (String email, String password) async  {
    UserCredential credential = await MainService.auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential;
  }

  /*{
    "to": "<Device FCM token>",
    "notification": {
      "title": "Check this Mobile (title)",
      "body": "Rich Notification testing (body)",
      "mutable_content": true,
      "sound": "Tri-tone"
      },

   "data": {
    "url": "<url of media image>",
    "dl": "<deeplink action on tap of notification>"
      }
}
*/
  Future<void> sendNotification(List<String> tokenList,Map<String,dynamic> notificationObject , Map<String,dynamic> dataObject,) async {
    var url = Uri.parse(notifcation_url);

    var response = await http.post(url, body: json.encode({'registration_ids': tokenList, 'notification': notificationObject,"data":dataObject}),headers: {"Authorization":"key=" + firebase_message_server_key,"Content-Type":"application/json"});
    print("noti response");
    print(response);
    print(response.body);
  }
  Future<void> createNotification(List<String> finance_uids, Map<String,dynamic> notificationObject , Map<String,dynamic> dataObject,) async {
    Map<String,dynamic> noti_data = {
      FirestoreConstants.notification_data_object:dataObject,
      FirestoreConstants.notification_object:notificationObject,
    };
    Map<String,dynamic> data = {};
    data.addAll({FirestoreConstants.notification_data:noti_data});
    data.addAll({FirestoreConstants.updatedAt:FieldValue.serverTimestamp()});
    data.addAll({FirestoreConstants.createdAt:FieldValue.serverTimestamp()});
    data.addAll({FirestoreConstants.is_read:false});
    //final batch = firebaseFirestoreInstance.batch();
    finance_uids.forEach((element) async {
      /*var coll = await userRefrence.doc(element).collection(notificationsCollection);
      var doc_id = coll.id;*/
      userRefrence.doc(element).collection(notificationsCollection).add(data);
      //batch.set(coll, data);
    });

  }
  Future<List<UserModel>?> getFilteruser({String filterName = "customer"}) async {
    CollectionReference users= FirebaseFirestore.instance.collection(userCollection);
    List<UserModel> listData = [];
    try{
      var querySnapShot = await users.where(FirestoreConstants.user_type,isEqualTo: filterName).get();
      querySnapShot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        UserModel userModel = UserModel.fromJson(data);
        listData.add(userModel);
      });
     return listData;
    }catch(e){
      print(e);
      return null;
    }
  }


  Future<Uint8List> getByteData(String url) async {
    http.Response response = await http.get(
      Uri.parse(url),
    );
    return response.bodyBytes;
  }
}
