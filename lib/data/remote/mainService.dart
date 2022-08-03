import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

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
String userCollection = appServerType.name+ FirestoreConstants.users;
String studentFormCollection = appServerType.name + FirestoreConstants.studentForms;

class MainService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final FirebaseStorage storageReference = FirebaseStorage.instance;

  //interNetConnectivity
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  CollectionReference userRefrence  = firebaseFirestoreInstance.collection(userCollection);

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

  Future<void> updateUserDataMain(String collectioName ,Map<String, dynamic> data) async {
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
}
