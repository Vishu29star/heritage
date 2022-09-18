import 'package:Heritage/data/remote/mainService.dart';
import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/firestore_constants.dart';

class SettingService extends MainService{
  String constantDoc_id = "";
  Future<Map<String,dynamic>?> getSuperAdminConstantData() async {
    CollectionReference constantCollection= FirebaseFirestore.instance.collection(FirestoreConstants.firestoreConstants);
    try{
      var documentsnapshot = await constantCollection.get();

      constantDoc_id = documentsnapshot.docs.first.id;
      Map<String,dynamic> data = documentsnapshot.docs.first.data()! as Map<String,dynamic>;
      return data;
    }catch(e){
      return null;
    }

  }

  Future<void> UpdateChatDeleteTime(Map<String,dynamic> updateData) async {
    CollectionReference constantCollection= FirebaseFirestore.instance.collection(FirestoreConstants.firestoreConstants);
    try{
      await constantCollection.doc(constantDoc_id).update(updateData);
    }catch(e){
      CommanWidgets.showToast(e.toString());
    }

  }
}