import 'package:Heritage/data/remote/mainService.dart';
import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/firestore_constants.dart';

class SettingService extends MainService{
  String constantDoc_id = "";
  Future<String> getChatDeleteTimeCount(String feildName) async {
    CollectionReference constantCollection= FirebaseFirestore.instance.collection(FirestoreConstants.firestoreConstants);
    try{
      var documentsnapshot = await constantCollection.get();

      constantDoc_id = documentsnapshot.docs.first.id;
      Map<String,dynamic> data = documentsnapshot.docs.first.data()! as Map<String,dynamic>;
      return data[feildName];
    }catch(e){
      return "";
    }

  }

  Future<void> UpdateChatDeleteTime(String feildName,String feildValue) async {
    CollectionReference constantCollection= FirebaseFirestore.instance.collection(FirestoreConstants.firestoreConstants);
    try{
      await constantCollection.doc(constantDoc_id).update({feildName:feildValue});
    }catch(e){
      CommanWidgets.showToast(e.toString());
    }

  }
}