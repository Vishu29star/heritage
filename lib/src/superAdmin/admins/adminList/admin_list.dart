import 'package:Heritage/data/firestore_constants.dart';
import 'package:Heritage/src/superAdmin/admins/add_admin/add_admin.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../constants/HeritageCircularProgressBar.dart';
import '../../../../constants/HeritageErrorWidget(.dart';
import '../../../../models/user_model.dart';
import '../../../home/homeVM.dart';

class AdminList extends StatefulWidget {
  final HomeVM homeModel;

  const AdminList({Key? key, required this.homeModel}) : super(key: key);

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> adminStream = widget
        .homeModel.homeService!.userdoc
        .where(FirestoreConstants.user_type, whereIn: ["admin","1","2","3","4","5"])
        .snapshots();
    return Container(
        child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 300, maxWidth: 450),
                child: Scaffold(
                  /*appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                    title:  Text(
                      context.resources.strings.admins,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: context.resources.color.colorPrimary),
                    ),
                  ),*/
                  floatingActionButton: FloatingActionButton.extended(
                    label: Text(
                      'Add Admin',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Container(
                                    constraints: BoxConstraints(
                                        minWidth: 300, maxWidth: 450),
                                    child: AddAdmin(
                                      homeModel: widget.homeModel,
                                    )));
                          });
                    },
                  ),
                  body: StreamBuilder<QuerySnapshot>(
                    stream: adminStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return HeritageErrorWidget();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return HeritageProgressBar();
                      }
                      List<UserModel> listData = [];
                      snapshot.data!.docs.forEach((doc) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        UserModel model = UserModel.fromJson(data);
                        listData.add(model);
                      });
                      return listData.length > 0
                          ? ListView.builder(
                              itemCount: listData.length,
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
                                      Text(listData[index].name ?? "name"),
                                      Text(getAdminName(listData[index].user_type!)),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(listData[index].email ?? "email"),
                                      IconButton(
                                          onPressed: () {
                                            widget.homeModel.homeService!
                                                .updateUserDataMain(
                                                {
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
                                          )),
                                    ],
                                  ),
                                );
                              })
                          : Center(
                              child: Text("No Admin Data"),
                            );
                    },
                  ),
                ))));
  }

 String getAdminName(String user_type){
    switch(user_type){
      case "admin":
        return "Admin";
      case "1":
        return "Front Desk";
      case "2":
        return "Financial Adviser";
      case "3":
        return "Legal";
      case "4":
        return "Admin 1";
      case "5":
        return "Admin 2" ;
      default :
        return "Admin";
    }
  }
}
