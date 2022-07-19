import 'package:Heritage/data/firestore_constants.dart';
import 'package:Heritage/utils/encryptry.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants/HeritageCircularProgressBar.dart';
import '../../../constants/HeritageErrorWidget(.dart';
import '../homeVM.dart';

class UserDetail extends StatelessWidget {
  final HomeVM model;
  const UserDetail(this.model ,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(model.selectedUserId == ""){
      return HeritageProgressBar();
    }
    final Stream<DocumentSnapshot> userStream  =  model.homeService!.userdoc.doc(model.selectedUserId).snapshots();
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
          stream: userStream,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return HeritageErrorWidget();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return HeritageProgressBar();
            }

            List<Widget> children = [];
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            children.add(headingWithValue(context.resources.strings.email,data[FirestoreConstnats.email]));

            return ListView(
              padding: EdgeInsets.all(16),
              children: children,
            );
          },
        ),
      ),
    );

  }
  Widget headingWithValue(String head, String value){

    return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex:3,child: Text(head)),
            Expanded(flex:7,child: Text(encrydecry().decryptMsg(value))),
          ],
        )
    );
  }
}
