
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/firestore_constants.dart';
import '../../data/remote/mainService.dart';

class LoginSignUpService extends MainService{

  Future<bool> checkIsUserPresentOrNot(String text) async {

    print("emailController.text");
    print(text);
    var querySnapshot = await userRefrence.where(FirestoreConstants.email,isEqualTo: text).get();
    print("querySnapshot.size");
    print(querySnapshot.size);
    if(querySnapshot.size>0){
      return true;
    }else{
      return false;
    }
  }
  
 Future<void> updateUserData(Map<String, dynamic> data) async {
   data.addAll({FirestoreConstants.updatedAt:FieldValue.serverTimestamp()});
   print(data[FirestoreConstants.uid]);
   userRefrence.doc(data[FirestoreConstants.uid]).update(data);
 }


 Future<void> setUserData(Map<String, dynamic> data) async {
   data.addAll({FirestoreConstants.updatedAt:FieldValue.serverTimestamp()});
   print(data[FirestoreConstants.uid]);
   userRefrence.doc(data[FirestoreConstants.uid]).set(data);
 }
 Future<UserCredential> registerUserWithPassword (String email, String password) async  {
   UserCredential credential = await MainService.auth.createUserWithEmailAndPassword(email: email, password: password);
   return credential;
 }

 Future<UserCredential> UpdatePassword (String email, String password) async  {
   UserCredential credential = await MainService.auth.createUserWithEmailAndPassword(email: email, password: password);
   return credential;
 }
}

