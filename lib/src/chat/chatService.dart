import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/firestore_constants.dart';
import '../../data/remote/mainService.dart';

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
}