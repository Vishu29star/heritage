
import 'dart:async';

import 'package:Heritage/src/chat/chatVM.dart';
import 'package:Heritage/src/chat/entities/text_message_entity.dart';
import 'package:Heritage/src/chat/entities/singleChatEntity.dart';
import 'package:Heritage/src/home/homeVM.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../constants/HeritageCircularProgressBar.dart';
import '../../constants/HeritageErrorWidget(.dart';
import '../../data/firestore_constants.dart';
import '../../utils/responsive/responsive.dart';


class SingleChatPage extends StatefulWidget {
  final ChatVM model;
  const SingleChatPage({Key? key,required this.model})
      : super(key: key);

  @override
  _SingleChatPageState createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  String messageContent = "";

  bool _changeKeyboardType = false;
  int _menuIndex = 0;


  @override
  void initState() {
    widget.model.messageController.addListener(() {
      setState(() {});
    });
    print("widget.model.selectedgroupChatId");
    print(widget.model.selectedgroupChatId);
    if(widget.model.selectedgroupChatId != ""){
      widget.model.chatStream  =  widget.model.chatService!.groupChatCollection.doc(widget.model.selectedgroupChatId).collection(widget.model.chatService!.messageCollection).orderBy('time').snapshots();

    }

    //  BlocProvider.of<ChatCubit>(context).getMessages(channelId: widget.singleChatEntity.groupId)
    //FIXME: call get all messages
    super.initState();
  }
  @override
  void dispose() {
    widget.model.messageController.dispose();
    widget.model.scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.model.selectedgroupChatId==""){
      return Container();
    }
    return Scaffold(
      appBar: Responsive.isMobile(context) ? AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "${widget.model.selectedgroup[FirestoreConstants.groupChatName]}",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Theme.of(context).primaryColor),
        ),
      ) : PreferredSize(
          preferredSize: Size.fromHeight(0.0), // here the desired height
          child: AppBar(
            // ...
          )
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.model.chatStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return HeritageErrorWidget();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(child: Center(child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Loading.....")
              ],
            ),),);
          }
          List<TextMessageEntity> messageList = [];
         // List<TextMessageEntity> messageList = [];
          for(int i = 0;i < snapshot.data!.docs.length;i++){
            var data = snapshot.data!.docs[i].data()! as Map<String, dynamic>;
            TextMessageEntity textMessageEntity = TextMessageEntity.fromJson(data);
            messageList.add(textMessageEntity);
          }
          return Column(
            children: [
              _messagesListWidget(messageList),
              _sendMessageTextField(),
            ],
          );
        },
      ),
    );
  }

  Widget _sendMessageTextField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      offset: Offset(0.0, 0.50),
                      spreadRadius: 1,
                      blurRadius: 1,
                    )
                  ]),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.insert_emoticon,
                    color: Colors.grey[500],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 60),
                        child: Scrollbar(
                          child: TextField(
                            style: TextStyle(fontSize: 14),
                            controller: widget.model.messageController,
                            maxLines: null,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.link,
                        color: Colors.grey[500],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      widget.model.messageController.text.isEmpty
                          ? Icon(
                        Icons.camera_alt,
                        color: Colors.grey[500],
                      )
                          : Text(""),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              if (widget.model.messageController.text.isEmpty) {
                //TODO:send voice message
              } else {
                widget.model.sendMessage(widget.model.messageController.text);
                print(widget.model.messageController.text);

                setState(() {
                  widget.model.messageController.clear();
                });
              }
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Icon(
                widget.model.messageController.text.isEmpty ? Icons.mic : Icons
                    .send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _messagesListWidget(List<TextMessageEntity> messageList) {
    Timer(Duration(milliseconds: 100), () {
      widget.model.scrollController.animateTo(
        widget.model.scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInQuad,
      );
    });
    print("messageList.length");
    print(messageList.length);
    return Expanded(
      child: ListView.builder(
        controller: widget.model.scrollController,
        itemCount: messageList.length,
        itemBuilder: (_, index) {
          final message = messageList[index];

          if (message.senderId == widget.model.currentUserId)
            return _messageLayout(
              name: "Me",
              alignName: TextAlign.end,
              color: Colors.lightGreen[400],
              time: DateFormat('hh:mm a').format(message.time!.toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.end,
              nip: BubbleNip.rightTop,
              text: message.content,
            );
          else
            return _messageLayout(
              color: Colors.white,
              name: "${message.senderName}",
              alignName: TextAlign.end,
              time: DateFormat('hh:mm a').format(message.time!.toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.start,
              nip: BubbleNip.leftTop,
              text: message.content,
            );
        },
      ),
    );
  }

  Widget _messageLayout({
    text,
    time,
    color,
    align,
    boxAlign,
    nip,
    crossAlign,
    String? name,
    alignName,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$name",
                    textAlign: alignName,
                    style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                  ),
                  Text(
                    text,
                    textAlign: align,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }


}