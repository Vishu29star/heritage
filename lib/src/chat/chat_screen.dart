import 'package:Heritage/constants/FormWidgetTextField.dart';
import 'package:Heritage/src/chat/chatService.dart';
import 'package:Heritage/src/chat/chat_groups_scereen.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../constants/HeritageCircularProgressBar.dart';
import '../../constants/HeritageErrorWidget(.dart';
import '../../data/firestore_constants.dart';
import '../../utils/responsive/responsive.dart';
import '../mainViewModel.dart';
import 'addChatUser.dart';
import 'chatVM.dart';
import 'messageScreen.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> mapData;
  const ChatScreen(this.mapData, {Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? currentUserId;
  String? userType;
  @override
  Widget build(BuildContext context) {
    currentUserId = widget.mapData["currentUserId"];
    userType = widget.mapData["userType"];
    return Scaffold(
        body: ChangeNotifierProvider<ChatVM>(
            create: (_) => ChatVM(ChatService(), MainViewMoel(),currentUserId!,userType!),
            child: Consumer<ChatVM>(builder: (context, model, child) {
              return LoaderOverlay(
                useDefaultLoading: false,
                overlayWidget: Center(
                  child: SpinKitCubeGrid(
                    color: context.resources.color.colorPrimary,
                    size: 50.0,
                  ),
                ),
                overlayColor: Colors.black,
                overlayOpacity: 0.8,
                child: Scaffold(
                  body: StreamBuilder<QuerySnapshot>(
                    stream: model.groupStream,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return HeritageErrorWidget();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return HeritageProgressBar();
                      }

                      if(snapshot.hasData && snapshot.data!.docs.isEmpty){
                        if(userType=="customer"){
                          model.createGroup();
                          return HeritageProgressBar();
                        }
                        return noDataBody(model);
                      }

                      if(userType == "customer"){
                        List<Map<String, dynamic>> groupList = [];
                        for(int i = 0;i <snapshot.data!.docs.length;i++){
                          var data = snapshot.data!.docs[i].data()! as Map<String, dynamic>;
                          groupList.add(data);
                        }
                        groupList.sort((a,b)=>a[FirestoreConstants.updatedAt].compareTo(b[FirestoreConstants.updatedAt]));

                        if (model.selectedgroupChatId == "") {
                          model.selectGroupChatId(groupList[0], isFirst: true);
                        }
                        return SingleChatPage(model: model,);
                      }else {
                        return AdminBody(snapshot,model);
                      }
                    },
                  ),
                ),
              );
            }))

    );

  }

  Widget noDataBody(ChatVM model){

    return Container(
      child: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.dataset_linked,color: Colors.red,),
          SizedBox(height: 20,),
          Text('No Chat Data'),

          SizedBox(height: 20,),
          SizedBox(
            width: 150,
            height: 40,
            child: Button(labelText: "New Chat", onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                            constraints: BoxConstraints(
                                minWidth: 300, maxWidth: 450),
                            child: AddChatUser(model,)));
                  });
            },),
          )
        ],
      ),),
    );;
  }

  Widget AdminBody(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, ChatVM model){
    return body(snapshot,model);
  }
  Widget body(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, ChatVM model){
    return  Responsive.isMobile(context) ? ChatGroupsScreen(snapshot,model):Row(
      children: [
        Expanded(flex:3,child: ChatGroupsScreen(snapshot,model)),
        Divider(height: double.infinity,thickness: 2),
        Expanded(flex:7,child: SingleChatPage(model: model,)),
      ],
    );
  }
}

/*
import 'package:Heritage/constants/FormWidgetTextField.dart';
import 'package:Heritage/src/chat/chatService.dart';
import 'package:Heritage/src/chat/chat_groups_scereen.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../constants/HeritageCircularProgressBar.dart';
import '../../constants/HeritageErrorWidget(.dart';
import '../../utils/responsive/responsive.dart';
import '../mainViewModel.dart';
import 'addChatUser.dart';
import 'chatVM.dart';
import 'messageScreen.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> mapData;
  const ChatScreen(this.mapData, {Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  String? currentUserId;
  String? userType;
  @override
  Widget build(BuildContext context) {
    currentUserId = widget.mapData["currentUserId"];
    userType = widget.mapData["userType"];
    return Scaffold(
        body: ChangeNotifierProvider<ChatVM>(
            create: (_) => ChatVM(ChatService(), MainViewMoel(),currentUserId!,userType!),
            child: Consumer<ChatVM>(builder: (context, model, child) {
              return LoaderOverlay(
                useDefaultLoading: false,
                overlayWidget: Center(
                  child: SpinKitCubeGrid(
                    color: context.resources.color.colorPrimary,
                    size: 50.0,
                  ),
                ),
                overlayColor: Colors.black,
                overlayOpacity: 0.8,
                child: ChatStart(model)
              );
            }))

        );

  }


}


class ChatStart extends StatefulWidget {
  const ChatStart({Key? key}) : super(key: key);

  @override
  State<ChatStart> createState() => _ChatStartState();
}

class _ChatStartState extends State<ChatStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: model.groupStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return HeritageErrorWidget();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return HeritageProgressBar();
          }

          if(snapshot.hasData && snapshot.data!.docs.isEmpty){
            if(userType=="customer"){
              model.createGroup();
              return HeritageProgressBar();
            }
            return noDataBody(model);
          }
          if(userType == "customer"){
            var data = snapshot.data!.docs.first.data()! as Map<String, dynamic>;
            if (model.selectedgroupChatId == "") {
              model.selectGroupChatId(data, isFirst: true);
            }
            return SingleChatPage(model: model,);
          }else {
            return AdminBody(snapshot,model);
          }
        },
      ),
    );
  }
  Widget noDataBody(ChatVM model){

    return Container(
      child: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.dataset_linked,color: Colors.red,),
          SizedBox(height: 20,),
          Text('No Chat Data'),

          SizedBox(height: 20,),
          SizedBox(
            width: 150,
            height: 40,
            child: Button(labelText: "New Chat", onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                            constraints: BoxConstraints(
                                minWidth: 300, maxWidth: 450),
                            child: AddChatUser(model,)));
                  });
            },),
          )
        ],
      ),),
    );;
  }

  Widget AdminBody(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, ChatVM model){
    return  Responsive.isMobile(context) ? ChatGroupsScreen(snapshot,model):Row(
      children: [
        Expanded(flex:3,child: ChatGroupsScreen(snapshot,model)),
        Divider(height: double.infinity,thickness: 2),
        Expanded(flex:7,child: SingleChatPage(model: model,)),
      ],
    );
  }
}
*/
