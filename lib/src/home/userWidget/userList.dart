import 'package:Heritage/route/myNavigator.dart';
import 'package:Heritage/route/routes.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../data/firestore_constants.dart';
import '../../../utils/encryptry.dart';
import '../../../utils/responsive/responsive.dart';
import '../homeVM.dart';
class UserList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final HomeVM model;
  const UserList( this.snapshot,this.model ,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(color: Colors.black),
    itemCount: snapshot.data!.docs.length,
    itemBuilder: (BuildContext ctx, int index) {

    Map<String, dynamic> data = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
    if(model.selectedUserId == ""){
    model.selectuser(snapshot.data!.docs.first.id,isFirst:true);
    }
    String name ="";
    if(data.containsKey(FirestoreConstnats.first_name)){
    name = encrydecry().decryptMsg(data[FirestoreConstnats.first_name]).toString().capitalize() +" "+encrydecry().decryptMsg(data[FirestoreConstnats.last_name]).toString().capitalize();
    }
    String email = encrydecry().decryptMsg(data[FirestoreConstnats.email]);
    return ListTile(
    selected: model.selectedUserId == data[FirestoreConstnats.uid],
    onTap:(){
      model.selectuser(data[FirestoreConstnats.uid]);
      if( Responsive.isMobile(context)){
        var passValue = {"model":model};
        myNavigator.pushNamed(context, Routes.userDetail,arguments: passValue);
      }},
    title: Text(name),
    subtitle: Text(email),
    ) ;
  }
    );
}
}