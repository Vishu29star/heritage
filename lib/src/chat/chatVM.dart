import 'dart:io';

import 'package:Heritage/src/chat/chatService.dart';
import 'package:Heritage/src/chat/entities/text_message_entity.dart';
import 'package:Heritage/src/mainViewModel.dart';
import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
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

  sendMedia(List<File> files) async {
    List<String> docIds = [];
    files.forEach((file) {
     final document = chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).doc();
     String doc_id = document.id;
     print("string");
     print(doc_id);
     docIds.add(doc_id);
     Map<String ,dynamic> msgObject = {
        "time":Timestamp.now(),
        "senderId":currentUserId,
        "content":doc_id,
        "senderName":name,
        "type": "UPLOADING"
      };
     document.set(msgObject);
    });
    for(int i = 0;i<docIds.length;i++){
      File compressfile =files[i] /*await compressFile(files[i])*/;
      List<String> fileUrl = await chatService!.getMediaUrl(compressfile);
      Map<String,dynamic> map = {"type":fileUrl[1],"content":fileUrl[0]};
      print("url");
      print(docIds[i]);
      chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).doc(docIds[i]).update(map);
    }
  }

  Future<List<File>?> imgFromGallery() async {
    ImagePicker _imagePicker = ImagePicker();
    List<XFile>? images = await _imagePicker.pickMultiImage();
    if (images != null) {
      List<File> compressFiles = [];
      images.forEach((element) {
        File file =File(element.path);
        compressFiles.add(file);
      });

      return compressFiles;
    }
  }

  Future<List<File>?> documnetFormFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      List<File> compressFiles = [];
      files.forEach((element) {
        compressFiles.add(element);
      });
      return compressFiles;
    }
  }

  Future<File?> imageFromCamera( ) async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (image != null) {
      File file = File(image.path);
      return file;
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

}