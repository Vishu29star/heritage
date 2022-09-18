import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/firestore_constants.dart';
import '../../data/remote/mainService.dart';

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

    String fileName = DateTime.now().toIso8601String();
    Uint8List data = await file.readAsBytes();
    var snapshot = await imageStorageRefrrence.child("image/$fileName").putData(data);
    List<String> strings =[];
    String one = await snapshot.ref.getDownloadURL();
    strings.add(one);
    strings.add("IMAGE");
    return strings;
  }

  Future<List<String>> getMediaUrlForAudio(String filepath) async {
    String fileName = DateTime.now().toIso8601String();

    var snapshot;
    if(kIsWeb){
      http.Response response = await http.get(Uri.parse(filepath));
      snapshot = await imageStorageRefrrence.child("audio/$fileName").putData(response.bodyBytes);
    }else{
      Uint8List data = await File(filepath).readAsBytes();
      snapshot = await imageStorageRefrrence.child("audio/$fileName").putData(data);
    }
    List<String> strings =[];
    String one = await snapshot.ref.getDownloadURL();
    strings.add(one);
    strings.add("AUDIO");
    return strings;
  }

}