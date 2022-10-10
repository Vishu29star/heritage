import 'package:Heritage/data/remote/mainService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/firestore_constants.dart';
import '../../data/remote/apiModels/apiResponse.dart';

class PersonService extends MainService{
  final CollectionReference studentFormDoc = FirebaseFirestore.instance.collection(immigrationFormCollection);

  Future<ApiResponse> checkForImmigrationForm(String uid) async {
    CollectionReference users= FirebaseFirestore.instance.collection(userCollection);
    try{
      var documentsnapshot = await users.doc(uid).get();
      Map<String,dynamic> data = documentsnapshot.data()! as Map<String, dynamic>;
      if(data.containsKey(FirestoreConstants.immigrationFormCaseID))
      {
        return ApiResponse(status: "success",data:data);
      }else{
        return ApiResponse(status: "fail",data: data);
      }
    }catch(e){
      print(e);
      return ApiResponse(status: "error",erroMessage: e.toString());
    }
  }

  Future<ApiResponse> getUserStudentForm(String case_id) async {
    CollectionReference formCollection= FirebaseFirestore.instance.collection(immigrationFormCollection);
    try{
      var documentsnapshot = await formCollection.doc(case_id).get();
      Map<String,dynamic> data = documentsnapshot.data()! as Map<String,dynamic>;
      return ApiResponse(status: "success",data:data);
    }catch(e){
      return ApiResponse(status: "fail",erroMessage: e.toString());
    }

  }

  Future<void> updateStudentForm(Map<String, dynamic> postData,String id) async {
    CollectionReference formCollection = FirebaseFirestore.instance.collection(immigrationFormCollection);
    try{
      postData.addAll({FirestoreConstants.updatedAt:FieldValue.serverTimestamp()});
      await formCollection.doc(id).update(postData);
    }catch(e){
      print(e);
    }
  }

  Future<int> getFormCount(String feildName) async {
    CollectionReference constantCollection = FirebaseFirestore.instance
        .collection(FirestoreConstants.firestoreConstants);
    try {
      var documentsnapshot = await constantCollection.get();

      Map<String, dynamic> data = documentsnapshot.docs.first.data()! as Map<
          String,
          dynamic>;
      int studentformcount = data[feildName] + 1;
      updateFormCount(
          studentformcount, feildName, documentsnapshot.docs.first.id);
      return studentformcount;
    } catch (e) {
      return -1;
    }
  }

  Future<void> updateFormCount(int count, String feildName, String id) async {
    CollectionReference constantCollection= FirebaseFirestore.instance.collection(FirestoreConstants.firestoreConstants);
    try{
      var documentsnapshot = await constantCollection.doc(id).update({feildName:count});
    }catch(e){
      print(e);
    }

  }

  Future<void> createUserStudentForm(Map<String, dynamic> postData) async {
    CollectionReference formCollection= FirebaseFirestore.instance.collection(immigrationFormCollection);
    try{
      await formCollection.doc(postData[FirestoreConstants.case_id]).set(postData);
    }catch(e){
      print(e);
    }
  }

  Future<void> updateUserWithStudentFormId(String case_id,String user_id) async {
    CollectionReference userCollection1= FirebaseFirestore.instance.collection(userCollection);
    try{
      userCollection1.doc(user_id).update({FirestoreConstants.immigrationFormCaseID:case_id});
    }catch(e){
      print(e);
    }
  }

  Future<void> updateUserPercentStudentFormId(String user_id, Map<String ,dynamic> data) async {
    CollectionReference userCollection1= FirebaseFirestore.instance.collection(userCollection);
    try{
      userCollection1.doc(user_id).update(data);
    }catch(e){
      print(e);
    }
  }
}