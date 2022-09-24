import 'package:Heritage/src/chat/chatVM.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/FormWidgetTextField.dart';
import '../../constants/app_popUps.dart';
import '../../constants/HeritageCircularProgressBar.dart';
import '../../constants/HeritageErrorWidget(.dart';
import '../../data/firestore_constants.dart';
import '../../models/user_model.dart';

class AddChatUser extends StatelessWidget {
  final ChatVM chatVM;
  final bool createGroup;
  AddChatUser(this.chatVM,{this.createGroup = true,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          context.resources.strings.addUser,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Theme.of(context).primaryColor),
        ),
      ),
      body: FutureBuilder(future:chatVM.chatService!.userdoc.where(FirestoreConstants.uid,isNotEqualTo: chatVM.currentUserId).get(),
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
            return AddUserBody(listData, chatVM,createGroup);
          }),
    );
  }
}

class AddUserBody extends StatefulWidget {
  List<UserModel> listData;
  final ChatVM chatVM;
  final bool createGroup;
  List<int> selectedListIndex = [];
  AddUserBody(this.listData,this.chatVM,this.createGroup, {Key? key}) : super(key: key);

  @override
  State<AddUserBody> createState() => _AddUserBodyState();
}

class _AddUserBodyState extends State<AddUserBody> {
  @override
  Widget build(BuildContext context) {
    return widget.listData.length>0?
    Column(children: [
      Expanded(child: ListView.builder(
          itemCount:widget.listData.length,itemBuilder: (context,index){
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
          title: Text(widget.listData[index].name??"name"),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.listData[index].email??"email"),
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
                for(int i = 0;i<widget.selectedListIndex.length;i++){

                  userIds.add(widget.listData[widget.selectedListIndex[i]].uid!);
                }
                if(!widget.createGroup){
                  widget.chatVM.chatService!.addUserToChatGroup(widget.chatVM.selectedgroupChatId,userIds);
                }else{
                  var resultLabel = await showTextInputDialog(context,);
                  if(resultLabel!=null){
                    List<String> userIds = [];
                    List<String> userEmail = [];
                    userIds.add(widget.chatVM.currentUserId);
                    for(int i = 0;i<widget.selectedListIndex.length;i++){

                      userIds.add(widget.listData[widget.selectedListIndex[i]].uid!);
                    }
                    Map<String,dynamic> lastUpdateMessage = {
                      FirestoreConstants.groupChatlastMessage:"",
                      FirestoreConstants.groupChatlastMessageUpdateTime:FieldValue.serverTimestamp(),
                      FirestoreConstants.groupChatlastMessageUserId:widget.chatVM.currentUserId,
                    };
                    Map<String,dynamic> data = {
                      FirestoreConstants.groupChatUserIds:userIds,
                      FirestoreConstants.groupChatName:resultLabel,
                      FirestoreConstants.groupChatCreatorId:widget.chatVM.currentUserId,
                      FirestoreConstants.groupChatlastMessageObject:lastUpdateMessage,
                    };

                    widget.chatVM.chatService!.createChatGroup(data);
                    Navigator.pop(context);
                  }
                }

              },
              labelText:context.resources.strings.add,
            )),
      ),
    ],) :Center(child: Text("No User Data"),);
  }
}

class AddGroupName extends StatefulWidget {
  const AddGroupName({Key? key}) : super(key: key);

  @override
  State<AddGroupName> createState() => _AddGroupNameState();
}

class _AddGroupNameState extends State<AddGroupName> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


