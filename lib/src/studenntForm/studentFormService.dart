import 'package:Heritage/data/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../data/remote/apiModels/apiResponse.dart';
import '../../data/remote/mainService.dart';

class StudentFormService extends MainService{

  Future<ApiResponse> checkForStudentForm(String uid) async {
    CollectionReference users= FirebaseFirestore.instance.collection(userCollection);
    try{
      var documentsnapshot = await users.doc(uid).get();
      Map<String,dynamic> data = documentsnapshot.data as Map<String,dynamic>;
      if(data.containsKey(FirestoreConstnats.studentFormIdCaseID))
      {
        return ApiResponse(status: "success",data:data[FirestoreConstnats.studentFormIdCaseID]);
      }else{
        return ApiResponse(status: "fail",erroMessage: "No student form");
      }
    }catch(e){
      return ApiResponse(status: "fail",erroMessage: e.toString());
    }
  }

  Future<ApiResponse> getUserStudentForm(String case_id) async {
    CollectionReference formCollection= FirebaseFirestore.instance.collection(studentFormCollection);
    try{
      var documentsnapshot = await formCollection.doc(case_id).get();
      Map<String,dynamic> data = documentsnapshot.data as Map<String,dynamic>;
      if(data.containsKey(FirestoreConstnats.studentFormIdCaseID))
      {
        return ApiResponse(status: "success",data:data[FirestoreConstnats.studentFormIdCaseID]);
      }else{
        return ApiResponse(status: "fail",erroMessage: "No student form");
      }
    }catch(e){
      return ApiResponse(status: "fail",erroMessage: e.toString());
    }

  }

  Future<void> createUserStudentForm(Map<String, dynamic> postData) async {
    CollectionReference formCollection= FirebaseFirestore.instance.collection(studentFormCollection);
    try{
     await formCollection.doc(postData[FirestoreConstnats.uid]).set(postData);
    }catch(e){
     print(e);
    }

  }

}