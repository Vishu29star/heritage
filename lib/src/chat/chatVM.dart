import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:Heritage/utils/webComman/web_comman.dart';
import 'package:audio_session/audio_session.dart' as AS;
import 'package:Heritage/src/chat/chatService.dart';
import 'package:Heritage/src/mainViewModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/firestore_constants.dart';
import '../../models/user_model.dart';
import '../../utils/comman/commanWidget.dart';
import 'mediaUrlWidget.dart';
/*
chat tutoril link
https://abhaymanu1205.medium.com/flutter-voice-messaging-app-4d980bb4108a
whatapp audio animation
https://flutterappworld.com/audio-chat-app-built-with-flutter
/
*/
class ChatVM extends ChangeNotifier {

  final MainViewMoel? mainModel;
  final ChatService? chatService;
  int audioListindex =- 1;
  bool isFirstAudio =false;
  List<Map<String,dynamic>> audioList =[];
  List<AudioPlayer> audioPlayerList =[];
  late String currentUserId;
  late String userType;
  String selectedgroupChatId = "";
  late Map<String,dynamic> selectedgroup;
  late String name ;
  late Stream<QuerySnapshot> groupStream  ;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late Stream<QuerySnapshot> chatStream;
  late SharedPreferences preferences;
  bool isRecorderOpen = false;
  bool isRecorderReady = false;
  bool isPlayerReady = false;
  var audioFile;
  var audioPath;
  var soundPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration playerDuration = Duration.zero;
  Duration playerPostion = Duration.zero;
  FlutterSoundRecorder recorder = FlutterSoundRecorder();


  ChatVM(this.chatService, this.mainModel,final Map<String, dynamic> mapData) : super() {
    currentUserId = mapData["currentUserId"];
    userType = mapData["userType"];
   // chatStream  =  chatService!.groupChatCollection.doc(widget.singleChatEntity.groupId).collection(FirestoreConstants.messages).orderBy('time').snapshots();
    groupStream  =  chatService!.groupChatCollection.where(FirestoreConstants.groupChatUserIds, arrayContainsAny: [currentUserId]).snapshots();
    init();
  }

  init() async {
    preferences = await SharedPreferences.getInstance();
    var data = await preferences.getString(FirestoreConstants.userProfile) ?? "name";
    UserModel currentUserModel = UserModel.fromJson(jsonDecode(data));
    name = currentUserModel.name ?? (currentUserModel.first_name! + currentUserModel.last_name!);
    initRecorder();
    //initPlayer();
  }

  selectGroupChatId(Map<String,dynamic> group, {bool isFirst = false}){
    selectedgroup = group;
    messageController = TextEditingController();
    scrollController = ScrollController();
    selectedgroupChatId = group[FirestoreConstants.groupChatId];
    print("edrftgyhuji");
    if (selectedgroupChatId != "") {
      chatStream = chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).orderBy('time').snapshots();
    }
    if (!isFirst) {
      notifyListeners();
    } else {
      Future.delayed(Duration(seconds: 1), () {
        notifyListeners();
      });
    }
  }

  createGroup() async {
    List<String> userIds = await getFrontDeskUserIds() ?? [];
    List<String> userEmail = [];
    userIds.add(currentUserId);
    Map<String,dynamic> lastUpdateMessage = {
      FirestoreConstants.groupChatlastMessage:"",
      FirestoreConstants.groupChatlastMessageUpdateTime:FieldValue.serverTimestamp(),
      FirestoreConstants.groupChatlastMessageUserId:currentUserId,
    };

    Map<String,dynamic> data = {
      FirestoreConstants.groupChatUserIds:userIds,
      FirestoreConstants.groupChatName:name,
      FirestoreConstants.groupChatCreatorId:currentUserId,
      FirestoreConstants.groupChatlastMessageObject:lastUpdateMessage,
    };

   chatService!.createChatGroup(data);
  }


  Future<List<String>?> getFrontDeskUserIds() async {
    List<UserModel>? frontDeskUser = await mainModel!.mainService.getFilteruser(filterName: "1");
    if(frontDeskUser!=null){
      List<String> ids =[];
      frontDeskUser.forEach((element) {
        ids.add(element.uid!);
      });
      return ids;
    }
  }

  sendMessage(String message){
    Map<String ,dynamic> msgObject = {
    FirestoreConstants.time:FieldValue.serverTimestamp(),
    FirestoreConstants.senderId:currentUserId,
    FirestoreConstants.content:message,
    FirestoreConstants.senderName:name,
    FirestoreConstants.type: "TEXT"
    };
    Map<String ,dynamic> group = {
      FirestoreConstants.groupChatlastMessageUpdateTime:FieldValue.serverTimestamp(),
      FirestoreConstants.groupChatlastMessageUserId:currentUserId,
      FirestoreConstants.groupChatlastMessage:message,
    };
    chatService!.groupChatCollection.doc(selectedgroupChatId).update({
      FirestoreConstants.updatedAt:FieldValue.serverTimestamp(),
      FirestoreConstants.groupChatlastMessageObject:group});
    chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).add(msgObject);
  }

  sendMediabyte(FilePickerResult result) async {
    List<String> docIds = [];
    List<Uint8List?> filess = result.files.map((e) => e.bytes).toList();
    List<String?> filesNames = result.files.map((e) => e.name).toList();
    filess.forEach((file) {
      final document = chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).doc();
      String doc_id = document.id;
      print("string");
      print(doc_id);
      docIds.add(doc_id);
      Map<String ,dynamic> msgObject = {
        FirestoreConstants.time:FieldValue.serverTimestamp(),
        FirestoreConstants.senderId:currentUserId,
        FirestoreConstants.content:doc_id,
        FirestoreConstants.senderName:name,
        FirestoreConstants.type: "UPLOADING"
      };
      document.set(msgObject);
    });
    for(int i = 0;i<docIds.length;i++){
      List<String> fileUrl = await chatService!.getMediaUrlFromBytes(filess[i]!,filesNames[i]!);
      Map<String,dynamic> map = {FirestoreConstants.type:fileUrl[1],FirestoreConstants.content:fileUrl[0]};
      print("url");
      print(docIds[i]);
      chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).doc(docIds[i]).update(map);
    }
  }

  sendMedia(List<XFile> files) async {
    List<String> docIds = [];
    files.forEach((file) {
     final document = chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).doc();
     String doc_id = document.id;
     docIds.add(doc_id);
     Map<String ,dynamic> msgObject = {
       FirestoreConstants.time:FieldValue.serverTimestamp(),
       FirestoreConstants.senderId:currentUserId,
       FirestoreConstants.content:doc_id,
       FirestoreConstants.senderName:name,
       FirestoreConstants.type: "UPLOADING"
      };
     document.set(msgObject);
    });
    print("11111111");
    for(int i = 0;i<docIds.length;i++){

      List<String> fileUrl = await chatService!.getMediaUrl(files[i]);
      Map<String,dynamic> map = {FirestoreConstants.type:fileUrl[1],FirestoreConstants.content:fileUrl[0]};
      print("url");
      print(docIds[i]);
      chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).doc(docIds[i]).update(map);
    }
  }

  sendAudio(File file) async {
    final document = chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).doc();
    String doc_id = document.id;
    Map<String ,dynamic> msgObject = {
      FirestoreConstants.time:FieldValue.serverTimestamp(),
      FirestoreConstants.senderId:currentUserId,
      FirestoreConstants.content:doc_id,
      FirestoreConstants.senderName:name,
      FirestoreConstants.type: "UPLOADINGAUDIO"
    };
    document.set(msgObject);
    List<String> fileUrl = await chatService!.getMediaUrlForAudio(audioPath);
    Map<String,dynamic> map = {FirestoreConstants.type:fileUrl[1],FirestoreConstants.content:fileUrl[0]};
    chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).doc(doc_id).update(map);
  }

  Future<List<XFile>?> imgFromGallery() async {
    ImagePicker _imagePicker = ImagePicker();
    List<XFile>? images = await _imagePicker.pickMultiImage();
    if (images != null) {
      List<File> compressFiles = [];
      images.forEach((element) {
        File file =File(element.path);
        compressFiles.add(file);
      });

      return images;
    }
  }

  Future<FilePickerResult?> documnetFormFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      /*List<File> files = result.paths.map((path) => File(path!)).toList();
      List<File> compressFiles = [];
      files.forEach((element) {
        compressFiles.add(element);
      });*/
      return result;
    }
  }

  Future<XFile?> imageFromCamera( ) async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (image != null) {
      return image;
    }

  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, outPath,
      quality: 5,
    );
    print(file.lengthSync());
    print(result!.lengthSync());
    return result;
  }

  Future initRecorder() async {
    if(kIsWeb){
    /* bool result = await WebComman.askWebMicrophonePermission();
     if(!result){
       throw "MicroPhone permission not Granted.";
     }*/
    }else{
      final status  = await Permission.microphone.request();
      if(status != PermissionStatus.granted){
        throw "MicroPhone permission not Granted.";
      }
    }
    await recorder.openRecorder();
    final session = await AS.AudioSession.instance;
    await session.configure(AS.AudioSessionConfiguration(
      avAudioSessionCategory: AS.AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AS.AVAudioSessionCategoryOptions.allowBluetooth |
      AS.AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AS.AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AS.AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AS.AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AS.AndroidAudioAttributes(
        contentType: AS.AndroidAudioContentType.speech,
        flags: AS.AndroidAudioFlags.none,
        usage: AS.AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AS.AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }


  Future stopRecording () async{
    /*if(!isRecorderReady) return;*/
    final path = await recorder.stopRecorder();
    print(path);
    audioPath = path;
    final audioFile = File(path!);
    this.audioFile = audioFile;
    print("Recorded Audio File : $audioFile");
    await  soundPlayer.setFilePath(audioFile.path);

  }

  Future startRecording () async{
    if(!isRecorderReady) return;
    print("startttttt");
    await recorder.startRecorder(toFile: 'audio');
  }

  void disposeChat() {
    recorder.closeRecorder();
    soundPlayer.dispose();
    for(int i = 0;i<audioPlayerList.length;i++){
      audioPlayerList[i].dispose();
    }
  }

}