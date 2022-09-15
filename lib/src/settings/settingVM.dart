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

  SettingVM(this.settingService, this.mainViewMoel,this.userModel,this.context): super() {
    print("userModel.uid");
    print(userModel.uid);
    getChatDeleteTimeCount();
  }

  Future<void> getChatDeleteTimeCount() async {
    chatDeleteTime = await settingService.getChatDeleteTimeCount(FirestoreConstants.chatDeleteTimeInDays);
    isDataLoaded = true;
    notifyListeners();
  }

  Future<void> updateChatDeleteTime(String chatDeletetime) async {
    await settingService.UpdateChatDeleteTime(FirestoreConstants.chatDeleteTimeInDays,chatDeletetime);
    this.chatDeleteTime = chatDeletetime;
    notifyListeners();
  }

}