import 'package:Heritage/src/chat/chatService.dart';
import 'package:Heritage/src/chat/entities/text_message_entity.dart';
import 'package:Heritage/src/mainViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/firestore_constants.dart';
import '../../data/remote/mainService.dart';

class ChatVM extends ChangeNotifier {

  final MainViewMoel? mainModel;
  final ChatService? chatService;
  final String currentUserId;
  final String userType;
  String selectedgroupChatId = "";
  late Map<String,dynamic> selectedgroup;
  late String name ;
  late Stream<QuerySnapshot> groupStream  ;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late Stream<QuerySnapshot> chatStream;
  late SharedPreferences preferences;


  ChatVM(this.chatService, this.mainModel,this.currentUserId,this.userType) : super() {
   // chatStream  =  chatService!.groupChatCollection.doc(widget.singleChatEntity.groupId).collection(FirestoreConstants.messages).orderBy('time').snapshots();
    groupStream  =  chatService!.groupChatCollection.where(FirestoreConstants.groupChatUserIds, arrayContainsAny: [currentUserId]).snapshots();
    init();
  }

  init() async {
    preferences = await SharedPreferences.getInstance();
    name = await preferences.getString(FirestoreConstants.name) ?? "name";
  }

  selectGroupChatId(Map<String,dynamic> group, {bool isFirst = false}){
    selectedgroup = group;
    messageController = TextEditingController();
    scrollController = ScrollController();
    selectedgroupChatId = group[FirestoreConstants.groupChatId];
    if (!isFirst) {
      notifyListeners();
    } else {
      Future.delayed(Duration(seconds: 1), () {
        notifyListeners();
      });
    }
  }

  sendMessage(String message){
    Map<String ,dynamic> msgObject = {
      "time":Timestamp.now(),
      "senderId":currentUserId,
      "content":message,
      "senderName":name,
      "type": "TEXT"
    };
    Map<String ,dynamic> group = {
      FirestoreConstants.groupChatlastMessageUpdateTime:FieldValue.serverTimestamp(),
      FirestoreConstants.groupChatlastMessageUserId:currentUserId,
      FirestoreConstants.groupChatlastMessage:message,
    };
    chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).add(msgObject);
    chatService!.groupChatCollection.doc(selectedgroupChatId).update({FirestoreConstants.groupChatlastMessageObject:group});
  }

}