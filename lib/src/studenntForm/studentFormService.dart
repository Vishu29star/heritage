import 'package:Heritage/data/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/remote/apiModels/apiResponse.dart';
import '../../data/remote/mainService.dart';

class StudentFormService extends MainService{
  final CollectionReference studentFormDoc = FirebaseFirestore.instance.collection(studentFormCollection);

  Future<ApiResponse> checkForStudentForm(String uid) async {
    CollectionReference users= FirebaseFirestore.instance.collection(userCollection);
    try{
      var documentsnapshot = await users.doc(uid).get();
      Map<String,dynamic> data = documentsnapshot.data()! as Map<String, dynamic>;
      if(data.containsKey(FirestoreConstants.studentFormCaseID))
      {
        return ApiResponse(status: "success",data:data[FirestoreConstants.studentFormCaseID]);
      }else{
        return ApiResponse(status: "fail",erroMessage: "No student form");
      }
    }catch(e){
      print(e);
      return ApiResponse(status: "fail",erroMessage: e.toString());
    }
  }

  Future<ApiResponse> getUserStudentForm(String case_id) async {
    CollectionReference formCollection= FirebaseFirestore.instance.collection(studentFormCollection);
    try{
      var documentsnapshot = await formCollection.doc(case_id).get();
      Map<String,dynamic> data = documentsnapshot.data()! as Map<String,dynamic>;
      return ApiResponse(status: "success",data:data);
    }catch(e){
      return ApiResponse(status: "fail",erroMessage: e.toString());
    }

  }

  Future<void> createUserStudentForm(Map<String, dynamic> postData) async {
    CollectionReference formCollection= FirebaseFirestore.instance.collection(studentFormCollection);
    try{
     await formCollection.doc(postData[FirestoreConstants.case_id]).set(postData);
    }catch(e){
     print(e);
    }
  }

  Future<void> updateStudentForm(Map<String, dynamic> postData,String id) async {
    CollectionReference formCollection= FirebaseFirestore.instance.collection(studentFormCollection);
    try{
      await formCollection.doc(id).update(postData);
    }catch(e){
      print(e);
    }
  }
  Future<void> updateUserWithStudentFormId(String case_id,String user_id) async {
    CollectionReference userCollection1= FirebaseFirestore.instance.collection(userCollection);
    try{
      userCollection1.doc(user_id).update({FirestoreConstants.studentFormCaseID:case_id});
    }catch(e){
      print(e);
    }
  }

}