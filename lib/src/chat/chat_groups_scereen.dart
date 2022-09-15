import 'package:Heritage/data/firestore_constants.dart';
import 'package:Heritage/route/myNavigator.dart';
import 'package:Heritage/src/chat/chatVM.dart';
import 'package:Heritage/src/chat/singleGroupItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../route/routes.dart';
import '../../utils/responsive/responsive.dart';
import 'addChatUser.dart';

class ChatGroupsScreen extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final ChatVM  model;
  const ChatGroupsScreen( this.snapshot, this.model, {Key? key}) : super(key: key);

  @override
  State<ChatGroupsScreen> createState() => _ChatGroupsScreenState();
}

class _ChatGroupsScreenState extends State<ChatGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> groupList = [];
    for(int i = 0;i <widget.snapshot.data!.docs.length;i++){
      var data = widget.snapshot.data!.docs[i].data()! as Map<String, dynamic>;
      groupList.add(data);
    }
    groupList.sort((a,b)=>a[FirestoreConstants.updatedAt].compareTo(b[FirestoreConstants.updatedAt]));

    if (widget.model.selectedgroupChatId == "") {
      widget.model.selectGroupChatId(groupList[0], isFirst: true);
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                            constraints: BoxConstraints(
                                minWidth: 300, maxWidth: 450),
                            child: AddChatUser(widget.model,)));
                  });
            }, child: Text("New Chat",style: TextStyle(color: Colors.white),))
        ],

      ),
      body: ListView.separated(itemBuilder:  (BuildContext ctx, int index) =>SingleItemGroupWidget(group: groupList[index],
        onTap: () {
        widget.model.selectGroupChatId(groupList[index]);
        if (Responsive.isMobile(context)) {
          var passValue = {"model": widget.model};
          myNavigator.pushNamed(context, Routes.messageScreen,
              arguments: passValue);
        }
      },), separatorBuilder:  (context, index) => Divider(color: Colors.black), itemCount: groupList.length),
    );
  }
}
