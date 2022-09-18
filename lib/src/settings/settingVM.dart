import 'package:Heritage/models/user_model.dart';
import 'package:Heritage/src/mainViewModel.dart';
import 'package:Heritage/src/settings/settingService.dart';
import 'package:flutter/material.dart';

import '../../data/firestore_constants.dart';

class SettingVM extends ChangeNotifier {
  final SettingService settingService;
  final MainViewMoel mainViewMoel;
  final UserModel userModel;
  final BuildContext context;
  bool isDataLoaded = false;
  String chatDeleteTime = "";
  String passportNotificicationTime = "";
  String error = "";
  Map<String, dynamic>? superAdminConstantData = {};

  SettingVM(this.settingService, this.mainViewMoel,this.userModel,this.context): super() {
    getAllData();
  }

  Future<void> getAllData() async {
    superAdminConstantData = await settingService.getSuperAdminConstantData();
    if(superAdminConstantData != null){
      chatDeleteTime = superAdminConstantData![FirestoreConstants.chatDeleteTimeInDays];
      passportNotificicationTime = superAdminConstantData![FirestoreConstants.passportNotificicationTime];
    }else{
      error = "Something went wrong";
    }
    isDataLoaded = true;
    notifyListeners();
  }

  Future<void> updateChatDeleteTime(Map<String,dynamic> updateData) async {
    await settingService.UpdateChatDeleteTime(updateData);
    notifyListeners();
  }

}