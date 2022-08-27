import 'package:Heritage/src/mainViewModel.dart';
import 'package:Heritage/src/superAdmin/superAdminReport/super-admin_report_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/firestore_constants.dart';
import '../../../models/user_model.dart';
import '../../home/homeVM.dart';

class SuperAdminReportVM extends ChangeNotifier{
  SuperAdminReportServices services;
  MainViewMoel mainViewMoel;
  HomeVM homeVm;
  BuildContext context;
  late String currentUserid;
  bool isLoading = false;
  List<UserModel> lessThan25 = [];
  List<UserModel> lessThan50 = [];
  List<UserModel> lessThan75 = [];
  List<UserModel> moreThan75 = [];


  SuperAdminReportVM(this.services,this.mainViewMoel,this.context,this.homeVm):super() {
    isLoading = true;
    getAllForms();
  }

  void getAllForms () async {
    try{
      QuerySnapshot snapshot = await services.userCollectInstance.get();
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        UserModel model = UserModel.fromJson(data);
        if(data.containsKey(FirestoreConstants.studentFormCaseID)){
          num studentPercent = 0;
          if(data.containsKey(FirestoreConstants.studentFormPercent)){
            studentPercent = data[FirestoreConstants.studentFormPercent];
            if(studentPercent<25){
              lessThan25.add(model);
              //studentPercentColor  = Colors.redAccent;
            }else if(studentPercent<50){
              lessThan50.add(model);
              //studentPercentColor  = Colors.orangeAccent;
            }
            else if(studentPercent<75){
              lessThan75.add(model);
              //studentPercentColor  = Colors.blueAccent;
            }else{
              moreThan75.add(model);
              //studentPercentColor = Colors.redAccent;
            }
          }else{
            lessThan25.add(model);
          }
        }
      });
      isLoading = false;
    }catch(e){
      mainViewMoel.showTopErrorMessage(context, e.toString());
      isLoading = false;
    }
    notifyListeners();
  }


}