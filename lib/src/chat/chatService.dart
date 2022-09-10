import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../data/firestore_constants.dart';
import '../../data/remote/mainService.dart';
import '../../utils/comman/commanWidget.dart';

class ChatService extends MainService {
  final CollectionReference userdoc = FirebaseFirestore.instance.collection(userCollection);
  final CollectionReference groupChatCollection = FirebaseFirestore.instance.collection(groupChatChannel);
  late CollectionReference ChatCollection ;
  String messageCollection = messages;

  Future<void> createChatGroup(Map<String, dynamic> data) async {
    String id = await groupChatCollection.doc().id;
    data.addAll({FirestoreConstants.updatedAt:FieldValue.serverTimestamp()});
    data.addAll({FirestoreConstants.createdAt:FieldValue.serverTimestamp()});
    data.addAll({FirestoreConstants.groupChatId:id});
    groupChatCollection.doc(id).set(data);
  }

  Future<List<String>> getMediaUrl(File file) async {
    String fileName = file.path.split('/').last;
    if(CommanWidgets().isImage(file.path) ?? false){
      var snapshot = await imageStorageRefrrence.child("image/$fileName").putFile(file);
      List<String> strings =[];
      String one = await snapshot.ref.getDownloadURL();
      strings.add(one);
      strings.add("IMAGE");
      return strings;
    }else{
      var snapshot = await docuMentStorageRefrrence.child("document/$fileName").putFile(file);
      List<String> strings =[];
      String one = await snapshot.ref.getDownloadURL();
      strings.add(one);
      strings.add("DOCUMENT");
      return strings;
    }

  }
}