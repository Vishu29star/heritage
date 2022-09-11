import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/firestore_constants.dart';
import '../../data/remote/mainService.dart';
import '../../utils/comman/commanWidget.dart';

class ChatService extends MainService {
  final CollectionReference userdoc = FirebaseFirestore.instance.collection(userCollection);
  final CollectionReference groupChatCollection = FirebaseFirestore.instance.collection(groupChatChannel);
  late CollectionReference ChatCollection ;
  String messageCollection = messages;

  Future<void> addUserToChatGroup(String group_id,List<String> ids) async {
    var userData = await groupChatCollection.doc(group_id).get();
    Map<String, dynamic> previoiusdata = userData.data() as Map<String, dynamic>;
    List<String> previousUserId = previoiusdata[FirestoreConstants.groupChatUserIds] as List<String>;
    previousUserId.addAll(ids);
    Map<String, dynamic> data = {FirestoreConstants.groupChatUserIds:previousUserId,FirestoreConstants.updatedAt:FieldValue.serverTimestamp()};
    groupChatCollection.doc(group_id).update(data);
  }

  Future<void> createChatGroup(Map<String, dynamic> data) async {
    String id = await groupChatCollection.doc().id;
    data.addAll({FirestoreConstants.updatedAt:FieldValue.serverTimestamp()});
    data.addAll({FirestoreConstants.createdAt:FieldValue.serverTimestamp()});
    data.addAll({FirestoreConstants.groupChatId:id});
    groupChatCollection.doc(id).set(data);
  }

  Future<List<String>> getMediaUrlFromBytes(Uint8List file,String name) async {

    var snapshot = await docuMentStorageRefrrence.child("document/$name").putData(file);
    List<String> strings =[];
    String one = await snapshot.ref.getDownloadURL();
    strings.add(one);
    strings.add("DOCUMENT");
    return strings;
  }

  Future<List<String>> getMediaUrl(XFile file) async {
    print("5555555555");

    String fileName = DateTime.now().toIso8601String();
    print("666666666666");
    Uint8List data = await file.readAsBytes();
    print("77777777777777");
    var snapshot = await imageStorageRefrrence.child("image/$fileName").putData(data);
    print("88888888888");
    List<String> strings =[];
    String one = await snapshot.ref.getDownloadURL();
    strings.add(one);
    strings.add("IMAGE");
    return strings;
  }
}