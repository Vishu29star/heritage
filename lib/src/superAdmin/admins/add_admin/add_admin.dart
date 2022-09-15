import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants/FormWidgetTextField.dart';
import '../../../../constants/HeritageCircularProgressBar.dart';
import '../../../../constants/HeritageErrorWidget(.dart';
import '../../../../constants/selectAdminType.dart';
import '../../../../data/firestore_constants.dart';
import '../../../../models/user_model.dart';
import '../../../home/homeVM.dart';

class AddAdmin extends StatefulWidget {
  final HomeVM homeModel;
  const AddAdmin({Key? key, required this.homeModel}) : super(key: key);


  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> adminStream  =  widget.homeModel.homeService!.userdoc.where(FirestoreConstants.user_type,isEqualTo: "customer").snapshots();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
        title:  Text(
          context.resources.strings.addAdmins,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: context.resources.color.colorPrimary),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: adminStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return listData.length > 0?
          ListView.builder(
              itemCount:listData.length,itemBuilder: (context,index){
            return ListTile(
              //selected: widget.model.selectedUserId == data[FirestoreConstants.uid],
              onTap: () {

              },
              title: Text(listData[index].name??"name"),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(listData[index].email??"email"),
                  SizedBox(
                      height: 40,
                      width: 120,
                      child: Button(
                        isEnabled: true,
                        onPressed: () async {
                          var resultLabel = await showAdminTypeSelectionDialog(context);
                          widget.homeModel.homeService!.updateUserDataMain( {FirestoreConstants.uid:listData[index].uid,FirestoreConstants.user_type:resultLabel});
                        },
                        labelText:context.resources.strings.add,
                      )),
                ],
              ),
            );
          })
              :Center(child: Text("No User Data"),);
        },
      ),
    );
  }
}
