import 'package:Heritage/data/remote/mainService.dart';
import 'package:Heritage/models/user_model.dart';
import 'package:Heritage/src/mainViewModel.dart';
import 'package:Heritage/src/notifications/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificatonsVM extends ChangeNotifier {
  final NotificationsService notificationsService;
  final MainViewMoel mainViewMoel;
  final UserModel userModel;
  final BuildContext context;
  late Stream<QuerySnapshot> notificationStream ;
  NotificatonsVM(this.notificationsService, this.mainViewMoel,this.userModel,this.context): super() {
    print("userModel.uid");
    print(userModel.uid);
    notificationStream = notificationsService.userRefrence.doc(userModel.uid).collection(notificationsCollection).snapshots();
  }
}