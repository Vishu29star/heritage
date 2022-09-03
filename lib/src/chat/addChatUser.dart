import 'package:Heritage/src/chat/chatVM.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/FormWidgetTextField.dart';
import '../../constants/HeritageCircularProgressBar.dart';
import '../../constants/HeritageErrorWidget(.dart';
import '../../data/firestore_constants.dart';
import '../../models/user_model.dart';

class AddChatUser extends StatefulWidget {
  final ChatVM chatVM;
  List<int> selectedListIndex = [];
  AddChatUser(this.chatVM,{Key? key}) : super(key: key);

  @override
  State<AddChatUser> createState() => _AddChatUserState();
}

class _AddChatUserState extends State<AddChatUser> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(future:widget.chatVM.chatService!.userdoc.where(FirestoreConstants.uid,isNotEqualTo: widget.chatVM.currentUserId).get(),
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
              UserModel userModel = UserModel.fromJson(data);
              listData.add(userModel);
            });
            return listData.length>0?
            Column(children: [
              Expanded(child: ListView.builder(
                  itemCount:listData.length,itemBuilder: (context,index){
                return ListTile(
                  selected: widget.selectedListIndex.contains(index),
                  onTap: () {
                    if(widget.selectedListIndex.contains(index)){
                      widget.selectedListIndex.removeWhere((element) => element == index);
                    }else{
                      widget.selectedListIndex.add(index);
                    }
                    setState(() {
                    });
                  },
                  title: Text(listData[index].name??"name"),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(listData[index].email??"email"),
                    ],
                  ),
                );
              })),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Button(
                      isEnabled: widget.selectedListIndex.length>0 ? true : false,
                      onPressed: () async {
                        List<String> userIds = [];
                        List<String> userEmail = [];
                        userIds.add(widget.chatVM.currentUserId);
                        for(int i = 0;i<widget.selectedListIndex.length;i++){
                          userIds.add(listData[i].uid!);
                        }
                        Map<String,dynamic> lastUpdateMessage = {
                          FirestoreConstants.groupChatlastMessage:"",
                          FirestoreConstants.groupChatlastMessageUpdateTime:FieldValue.serverTimestamp(),
                          FirestoreConstants.groupChatlastMessageUserId:widget.chatVM.currentUserId,
                        };
                        Map<String,dynamic> data = {
                          FirestoreConstants.groupChatUserIds:userIds,
                          FirestoreConstants.groupChatName:widget.chatVM.currentUserId,
                          FirestoreConstants.groupChatCreatorId:widget.chatVM.currentUserId,
                          FirestoreConstants.groupChatlastMessageObject:lastUpdateMessage,
                        };

                        widget.chatVM.chatService!.createChatGroup(data);
                        Navigator.pop(context);
                      },
                      labelText:context.resources.strings.add,
                    )),
              ),
            ],)
                :Center(child: Text("No User Data"),);
          }),
    );
  }
}
