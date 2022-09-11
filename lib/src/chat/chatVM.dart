import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
import '../../models/user_model.dart';

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
    var data = await preferences.getString(FirestoreConstants.userProfile) ?? "name";
    UserModel currentUserModel =UserModel.fromJson(jsonDecode(data));
    name = currentUserModel.name ?? (currentUserModel.first_name! + currentUserModel.last_name!);
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
        "time":Timestamp.now(),
        "senderId":currentUserId,
        "content":doc_id,
        "senderName":name,
        "type": "UPLOADING"
      };
      document.set(msgObject);
    });
    print("11111111");
    for(int i = 0;i<docIds.length;i++){
      List<String> fileUrl = await chatService!.getMediaUrlFromBytes(filess[i]!,filesNames[i]!);
      Map<String,dynamic> map = {"type":fileUrl[1],"content":fileUrl[0]};
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
    print("11111111");
    for(int i = 0;i<docIds.length;i++){

      List<String> fileUrl = await chatService!.getMediaUrl(files[i]);
      Map<String,dynamic> map = {"type":fileUrl[1],"content":fileUrl[0]};
      print("url");
      print(docIds[i]);
      chatService!.groupChatCollection.doc(selectedgroupChatId).collection(chatService!.messageCollection).doc(docIds[i]).update(map);
    }
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

}