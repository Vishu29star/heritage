import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:Heritage/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../firestore_constants.dart';

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
String userCollection = appServerType.name + FirestoreConstants.users;
String studentFormCollection = appServerType.name + FirestoreConstants.studentForms;
String immigrationFormCollection = appServerType.name + FirestoreConstants.immigrationForms;
String groupChatChannel =
    appServerType.name + FirestoreConstants.groupChatChannel;
String messages = appServerType.name + FirestoreConstants.messages;
String notificationsCollection =
    appServerType.name + FirestoreConstants.notifications;

final String firebase_message_server_key =
    "AAAAJXOJzWs:APA91bGWR34oWC3eoHhi04gFw41Xr_6Jo6ztQYAEA73JTATaFs3zycYImuQChm71kBcvfJlWRGZX_kuABlF1ZjYBvn3gqU1rCpgELXK3GnV6nRMXunf06Dw9o1X45Dt1cZmswhx0ITc0";
final String web_vapid_key =
    "BBIMiM6qxQPsLVjMHIj79ncIyTOFlOQu8L-HXL7n2HYumPFGpsH2Plt-qg5-HWnXjOoOTdZcxyoLdcyVNURyQaU";
final String notifcation_url = "https://fcm.googleapis.com/fcm/send";

class MainService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final FirebaseStorage storageReference = FirebaseStorage.instance;

  //interNetConnectivity
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  CollectionReference userRefrence =
      firebaseFirestoreInstance.collection(userCollection);
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
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void dispose() {
    connectivitySubscription.cancel();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
  }

  Future<bool> checkIsUserPresentOrNotMain(
      String collectioName, String text) async {
    print("emailController.text");
    print(text);
    var querySnapshot = await userRefrence
        .where(FirestoreConstants.email, isEqualTo: text)
        .get();
    print("querySnapshot.size");
    print(querySnapshot.size);
    if (querySnapshot.size > 0) {
      /* querySnapshot.docs[0][FirestoreConstnats.email]*/
      return true;
    } else {
      return false;
    }
  }



  Future<void> updateUserDataMain(Map<String, dynamic> data) async {
    data.addAll({FirestoreConstants.updatedAt: FieldValue.serverTimestamp()});
    print(data[FirestoreConstants.uid]);
    userRefrence.doc(data[FirestoreConstants.uid]).update(data);
  }

  Future<void> setUserDataMain(
      String collectioName, Map<String, dynamic> data) async {
    data.addAll({FirestoreConstants.updatedAt: FieldValue.serverTimestamp()});
    print(data[FirestoreConstants.uid]);
    userRefrence.doc(data[FirestoreConstants.uid]).set(data);
  }

  Future<UserCredential> registerUserWithPasswordMain(
      String email, String password) async {
    UserCredential credential = await MainService.auth
        .createUserWithEmailAndPassword(email: email, password: password);
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
  Future<void> sendNotification(
    List<String> tokenList,
    Map<String, dynamic> notificationObject,
    Map<String, dynamic> dataObject,
  ) async {
    var url = Uri.parse(notifcation_url);

    var response = await http.post(url,
        body: json.encode({
          'registration_ids': tokenList,
          'notification': notificationObject,
          "data": dataObject
        }),
        headers: {
          "Authorization": "key=" + firebase_message_server_key,
          "Content-Type": "application/json"
        });
    print("noti response");
    print(response);
    print(response.body);
  }

  Future<void> createNotification(
    List<String> finance_uids,
    Map<String, dynamic> notificationObject,
    Map<String, dynamic> dataObject,
  ) async {
    Map<String, dynamic> noti_data = {
      FirestoreConstants.notification_data_object: dataObject,
      FirestoreConstants.notification_object: notificationObject,
    };
    Map<String, dynamic> data = {};
    data.addAll({FirestoreConstants.notification_data: noti_data});
    data.addAll({FirestoreConstants.updatedAt: FieldValue.serverTimestamp()});
    data.addAll({FirestoreConstants.createdAt: FieldValue.serverTimestamp()});
    data.addAll({FirestoreConstants.is_read: false});
    //final batch = firebaseFirestoreInstance.batch();
    finance_uids.forEach((element) async {
      /*var coll = await userRefrence.doc(element).collection(notificationsCollection);
      var doc_id = coll.id;*/
      userRefrence.doc(element).collection(notificationsCollection).add(data);
      //batch.set(coll, data);
    });
  }

  Future<List<UserModel>?> getFilteruser(
      {String filterName = "customer"}) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(userCollection);
    List<UserModel> listData = [];
    try {
      var querySnapShot = await users
          .where(FirestoreConstants.user_type, isEqualTo: filterName)
          .get();
      querySnapShot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        UserModel userModel = UserModel.fromJson(data);
        listData.add(userModel);
      });
      return listData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void deleteChat(String user_id,String chatDeletTime) async {
    final instance = FirebaseFirestore.instance;
    final CollectionReference groupChatCollection =
        instance.collection(groupChatChannel);
    var groupssnap = await groupChatCollection.where(
        FirestoreConstants.groupChatUserIds,
        arrayContainsAny: [user_id]).get();
    DateTime currentDate = DateTime.now().subtract(Duration(days: int.parse(chatDeletTime)));
    final Timestamp now = Timestamp.fromDate(currentDate);
    List<String> fileUrls = [];
    List<String> fileTypeUrls = [];
    List<Map<String, dynamic>> groupList = [];
    for (int i = 0; i < groupssnap.docs.length; i++) {
      final batch = instance.batch();
      var data = groupssnap.docs[i].data() as Map<String, dynamic>;
      groupList.add(data);
      print('group chat id ${data[FirestoreConstants.groupChatId]}');
      final CollectionReference chatref = groupChatCollection.doc(data[FirestoreConstants.groupChatId]).collection(messages);
      print("now");
      print(now);
      var chatData = await chatref.where("time", isLessThanOrEqualTo: currentDate).get();
      print("chat doc length ${chatData.docs.length}");
      chatData.docs.forEach((element) {
        print('message id ${element.id}');
        if (element["type"] != "TEXT") {
          if(element["content"].contains("https://")){
            fileTypeUrls.add(element["type"]);
            fileUrls.add(element["content"]);
          }
        }
        batch.delete(chatref.doc(element.id));
      });
      batch.commit();
    }

    for (int i = 0; i < fileUrls.length; i++) {
      print('file url ${fileUrls[i]}');
      print('file type ${fileTypeUrls[i]}');
      await FirebaseStorage.instance.refFromURL(fileUrls[i]).delete();
    }
  }

  Future<String> getChatDeleteTimeCount(String feildName) async {
    CollectionReference constantCollection = FirebaseFirestore.instance
        .collection(FirestoreConstants.firestoreConstants);
    try {
      var documentsnapshot = await constantCollection.get();
      Map<String, dynamic> data = documentsnapshot.docs.first.data()! as Map<String, dynamic>;
      return data[feildName];
    } catch (e) {
      return "";
    }
  }

  Future<Map<String,dynamic>> getMediaUrlFromByte(FilePickerResult result) async {
    Uint8List file = result.files.first.bytes!;
    String name = result.files.first.name;
    var snapshot = await docuMentStorageRefrrence.child("document/$name").putData(file);
    String one = await snapshot.ref.getDownloadURL();
    return {"type":"DOCUMENT","data":one};
  }

  Future<Map<String,dynamic>> getSingleMediaUrl(XFile file) async {

    String fileName = DateTime.now().toIso8601String();
    Uint8List data = await file.readAsBytes();
    var snapshot = await imageStorageRefrrence.child("image/$fileName").putData(data);

    String one = await snapshot.ref.getDownloadURL();
    return {"type":"IMAGE","data":one};
  }
  Future<Uint8List> getByteData(String url) async {
    http.Response response = await http.get(
      Uri.parse(url),
    );
    return response.bodyBytes;
  }
}
