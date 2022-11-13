import 'package:Heritage/models/user_model.dart';
import 'package:Heritage/src/notifications/notificationsVM.dart';
import 'package:Heritage/utils/dateUtilsFormat.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants/HeritageCircularProgressBar.dart';
import '../../constants/HeritageErrorWidget(.dart';
import '../../data/firestore_constants.dart';
import '../mainViewModel.dart';
import 'notification_service.dart';

class NotiFicationScreen extends StatefulWidget {
  final UserModel userModel;
  const NotiFicationScreen(this.userModel,{Key? key}) : super(key: key);

  @override
  State<NotiFicationScreen> createState() => _NotiFicationScreenState();
}

class _NotiFicationScreenState extends State<NotiFicationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<NotificatonsVM>(
          create: (_) => NotificatonsVM(NotificationsService(), MainViewMoel(),widget.userModel,context),
          child: Consumer<NotificatonsVM>(builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                iconTheme: IconThemeData(color: Colors.white),
                /*
                backgroundColor: Colors.white,*/
                title:  Text(
                  context.resources.strings.notificatons,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: model.notificationStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return HeritageErrorWidget();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return HeritageProgressBar();
                  }
                  List<Map<String, dynamic>> listData = [];
                  snapshot.data!.docs.forEach((doc) {

                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    print("data");
                    print(data);
                    listData.add(data);
                  });
                  return listData.length > 0
                      ? ListView.separated(
                      itemCount: listData.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (context, index) {
                        return ListTile(
                          //selected: widget.model.selectedUserId == data[FirestoreConstants.uid],
                          onTap: () {},
                          title: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Text(listData[index][FirestoreConstants.notification_data][FirestoreConstants.notification_object]["title"] ),
                              Text(DateTimeUtils.formatDisplayDate(DateTime.parse(listData[index][FirestoreConstants.createdAt].toDate().toString()))),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Text(listData[index][FirestoreConstants.notification_data][FirestoreConstants.notification_object]["body"]),
                              /*IconButton(
                                  onPressed: () {
                                    widget.homeModel.homeService!
                                        .updateUserDataMain(
                                        FirestoreConstants.users, {
                                      FirestoreConstants.uid:
                                      listData[index].uid,
                                      FirestoreConstants.user_type:
                                      "customer"
                                    });
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: context
                                        .resources.color.colorPrimary,
                                  )),*/
                            ],
                          ),
                        );
                      })
                      : Center(
                    child: Text("No Notifications"),
                  );
                },
              ),
            );
          }),
      )
    );
  }
}
