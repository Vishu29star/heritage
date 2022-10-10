import 'dart:async';
import 'dart:io';

import 'package:Heritage/constants/image_picker_utils.dart';
import 'package:Heritage/route/routes.dart';
import 'package:Heritage/src/chat/chatVM.dart';
import 'package:Heritage/src/chat/entities/text_message_entity.dart';
import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../constants/HeritageErrorWidget(.dart';
import '../../constants/pdfPreview.dart';
import '../../data/firestore_constants.dart';
import '../../utils/fullImage_view/full_image_view.dart';
import '../../utils/responsive/responsive.dart';
import 'package:Heritage/route/myNavigator.dart';
import 'addChatUser.dart';
import 'mediaUrlWidget.dart';

class SingleChatPage extends StatefulWidget {
  final ChatVM model;
  SingleChatPage({Key? key, required this.model}) : super(key: key);

  @override
  _SingleChatPageState createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> with AutomaticKeepAliveClientMixin{
  String messageContent = "";

  bool isPlaying = false;
  bool _changeKeyboardType = false;
  int _menuIndex = 0;
  Duration playerPostion = Duration.zero;
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          widget.model.soundPlayer.positionStream,
          widget.model.soundPlayer.bufferedPositionStream,
          widget.model.soundPlayer.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  void initState() {
    widget.model.messageController.addListener(() {
      setState(() {});
    });
    initPlayer();
    //FIXME: call get all messages
    super.initState();
  }
  initPlayer(){
    /*https://www.youtube.com/watch?v=MB3YGQ-O`1lk*/
    /* widget.model.soundPlayer.onPlayerStateChanged.listen((state) {
      print("onPlayerStateChanged");
      isPlaying = CommanWidgets().isPLAYING(state);

    });

    widget.model.soundPlayer.onPlayerComplete.listen((event) {
      playerPostion = Duration.zero;
      widget.model.soundPlayer.stop();
      isPlaying = false;
    });

    widget.model.soundPlayer.onDurationChanged.listen((newPosition) {
      print("onDurationChanged");
      print(newPosition);
      widget.model.playerDuration = newPosition;
    });
    widget.model.soundPlayer.onPositionChanged.listen((newPosition) {
     playerPostion =newPosition;
      setState(() {
      });
    });*/
  }
  @override
  void dispose() {
    widget.model.messageController.dispose();
    widget.model.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.selectedgroupChatId == "") {
      return Container();
    }
    if(widget.model.chatStream==null){
      return Container();
    }
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.model.userType != "customer" ? "${widget.model.selectedgroup[FirestoreConstants.groupChatName]}":"Admin",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Theme.of(context).primaryColor),
        ),
        actions: [
          widget.model.userType != "customer"
              ? TextButton(
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
                              child: AddChatUser(widget.model,createGroup: false,)));
                    });
              }, child: Text("Add Chat User",style: TextStyle(color: Colors.white),))
              : Container()],
      )
          : PreferredSize(
          preferredSize: Size.fromHeight(0.0), // here the desired height
          child: AppBar(
            actions: [
              widget.model.userType != "customer"
                  ? TextButton(
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
                                  child: AddChatUser(widget.model,createGroup: false,)));
                        });
                  }, child: Text("Add Chat User",style: TextStyle(color: Colors.white),))
                  : Container()],

          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.model.chatStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          widget.model.audioListindex = -1;
          if (snapshot.hasError) {
            return HeritageErrorWidget();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Loading.....")
                  ],
                ),
              ),
            );
          }
          List<TextMessageEntity> messageList = [];
          // List<TextMessageEntity> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            var data = snapshot.data!.docs[i].data()! as Map<String, dynamic>;
            TextMessageEntity textMessageEntity =
            TextMessageEntity.fromJson(data);
            messageList.add(textMessageEntity);
          }
          return Column(
            children: [
              _messagesListWidget(messageList),
              widget.model.isRecorderOpen ?  recorderWidget() :_sendMessageTextField(),
            ],
          );
        },
      ),
    );
  }


  Widget recorderWidget(){
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
      child:Row(
        children: [
          IconButton(onPressed: (){
            widget.model.isRecorderOpen = false;
            setState(() {
              widget.model.audioFile = null;
            });
          },
              icon: Icon(Icons.delete)),
          SizedBox(width: 16,),
          Expanded(child:  widget.model.recorder.isRecording ? recordigWidget() : audioPlayerWidget(),),
          SizedBox(width: 16,),
          InkWell(
            onTap: (){
              widget.model.isRecorderOpen = false;
              widget.model.sendAudio(widget.model.audioFile);
              widget.model.audioFile = null;
              setState(() {
              });
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child:Icon(Icons.send,color: Colors.white,),
            ),
          )
         ,
        ],
      ),
    );
  }

  Widget recordigWidget(){
    return Row(
      children: [
        IconButton(onPressed: () async {
          await widget.model.stopRecording();
          setState(() {});
        }, icon: widget.model.recorder.isRecording ? Icon(Icons.stop) : Icon(Icons.mic)),
        SizedBox(width: 16,),
        Expanded(child: LinearProgressIndicator()),
        SizedBox(width: 16,),
        StreamBuilder<RecordingDisposition>(
            stream: widget.model.recorder.onProgress,
            builder: (context, snapshot) {
              final duration = snapshot.hasData ? snapshot.data!.duration :Duration.zero;
              String twoDigits(int n) => n.toString().padLeft(1);
              final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
              final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
              return Text(
                '$twoDigitMinutes:$twoDigitSeconds',
                style: TextStyle(fontSize: 15),
              );
            }),
      ],
    );
  }

  Widget audioPlayerWidget(){

    return StreamBuilder<PositionData>(
      stream: Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          widget.model.soundPlayer.positionStream,
          widget.model.soundPlayer.bufferedPositionStream,
          widget.model.soundPlayer.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero)),
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return Row(
          children: [
            InkWell(onTap : () async {
              if(isPlaying){
                isPlaying = false;
                await widget.model.soundPlayer.pause();
                setState(() {

                });
              }else{
                print("ecrvtbynumi,");
                isPlaying  = true;
                await  widget.model.soundPlayer.play();
                setState(() {
                });
              }
            }, child:isPlaying ? Icon(Icons.stop) : Icon(Icons.play_arrow)),
            SizedBox(width: 16,),
            Expanded(
              child: SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  widget.model.soundPlayer.seek(newPosition);
                },
              ),
            ),
           /* Expanded(
              child: Slider(
                min: 0,
                max: widget.model.playerDuration.inSeconds.toDouble(),
                value: playerPostion.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await widget.model.soundPlayer.seek(position);
                },
              ),
            ),
            SizedBox(width: 16,),
            Text(
              '$twoDigitMinutes:$twoDigitSeconds',
              style: TextStyle(fontSize: 15),
            )*/
          ],
        );
      }
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
                 /* SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.insert_emoticon,
                    color: Colors.grey[500],
                  ),*/
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
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.grey[500]),
                        onPressed: () {
                          ImagePickerUtils.show(
                            context: context,
                            onGalleryClicked: () async {
                              List<XFile>? files = await widget.model.imgFromGallery();
                              Navigator.of(context).pop();
                              if(files!=null){
                                widget.model.sendMedia(files);
                              }
                            },
                            onDocumentClicked: () async {
                              FilePickerResult? result  = await widget.model.documnetFormFile();
                              Navigator.of(context).pop();
                              if(result!=null){

                                widget.model.sendMediabyte(result);
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      widget.model.messageController.text.isEmpty
                          ? IconButton(
                          onPressed: () async {
                            XFile? file = await widget.model.imageFromCamera();
                            //Navigator.of(context).pop();

                            if(file!=null){
                              List<XFile> files = [];
                              files.add(file);
                              widget.model.sendMedia(files);
                            }
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[500],
                          ))
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
            onTap: () async {
              if(kIsWeb){
                if (widget.model.messageController.text.isNotEmpty) {
                  widget.model.sendMessage(widget.model.messageController.text);
                  widget.model.messageController.clear();
                }
              }
              if (widget.model.messageController.text.isEmpty) {
                //TODO:send voice message
                await widget.model.startRecording();
                widget.model.isRecorderOpen = true;
                setState(() {

                });
              } else {
                widget.model.sendMessage(widget.model.messageController.text);
                widget.model.messageController.clear();
              }
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Icon(
                kIsWeb ? Icons.send : widget.model.messageController.text.isEmpty
                    ? Icons.mic
                    : Icons.send,
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
    return Expanded(
      child: ListView.builder(
        controller: widget.model.scrollController,
        cacheExtent: 9999,
        itemCount: messageList.length,
        itemBuilder: (_, index) {
          final message = messageList[index];

          if (message.senderId == widget.model.currentUserId)
            return _messageLayout(
              name: "Me",
              alignName: TextAlign.end,
              color: Colors.lightGreen[400],
              time: DateFormat('hh:mm a').format(message.time == null ? DateTime.now(): message.time!.toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.end,
              nip: BubbleNip.rightTop,
              text: message.content,
              type: message.type,
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
              type: message.type,
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
    type
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
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  getDataType(type,text,align),
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

  Widget getDataType(String type,String content, align){
    if(type == "TEXT"){
      return  Text(
        content,
        textAlign: align,
        style: TextStyle(fontSize: 16),
      );
    }
    else if(type == "UPLOADING"){
      return  Container(
        height: 200,
        width: 200,
        child: Center(child: CircularProgressIndicator(),),
      );
    }
    else if(type == "IMAGE"){
      return InkWell(
        onTap:(){
          List<String> imageList = [];
          imageList.add(content);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullscreenImageScreen(
                    attachment: imageList,
                  )));
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.70,
            maxHeight: MediaQuery.of(context).size.height * 0.70,
          ),
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: CachedNetworkImageProvider(content),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    else if(type == "DOCUMENT"){
      return  InkWell(
        onTap:() async {
          var ppp = await widget.model.chatService!.getByteData(content);
          if(Responsive.isMobile(context)){
            myNavigator.pushNamed(context, Routes.pdfPreview, arguments: ppp);
          }
          else{
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0)),
                      child: Container(constraints: BoxConstraints(minWidth: 300, maxWidth: 450),child:PdfPreviewPage(ppp)));
                }
            );
          }
          /*if (content.endsWith(".pdf")) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PdfViewScreen(content)));
          }*/
        },
        child: Container(
          height: 200,
          width: 200,
          child: Center(child: Icon(Icons.picture_as_pdf,size: 40,),),
        ),
      );
    }
    else if(type == "UPLOADINGAUDIO"){
      return  ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.50,
          maxHeight: MediaQuery.of(context).size.height * 0.10,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Center(child: LinearProgressIndicator(
            minHeight: 10,
          ),),
        ),
      );
    }
    else if(type == "AUDIO"){
      widget.model.isFirstAudio = false;
      widget.model.audioListindex++;

      widget.model.audioList.add({"url":content,"isPlaying":false,"index":widget.model.audioListindex});
      widget.model.audioPlayerList.add(AudioPlayer());
      if(widget.model.isFirstAudio){

      }
      //AudioPlayer player = AudioPlayer();
      return  ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.50,
          maxHeight: MediaQuery.of(context).size.height * 0.10,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: MediaPlayerUrl(widget.model.audioList,widget.model.audioPlayerList,widget.model.audioListindex),
        ),
      );
    }
    return Container();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
