import 'package:Heritage/data/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/remote/mainService.dart';

class HomeService extends MainService{
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection(userCollection).orderBy(FirestoreConstants.updatedAt).snapshots();
  final CollectionReference userdoc = FirebaseFirestore.instance.collection(userCollection);


  Future<QuerySnapshot> searchUser(String search,String searchType) async {
   var snapshot =  await userdoc.where(searchType,isEqualTo: search).get();
   return snapshot;
  }

  Future<void> deleteEmployyeComment() async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    try{
      QuerySnapshot snapshot = await instance.collection(studentFormCollection).where(FirestoreConstants.user_type,isEqualTo: "customer").get();
      for (DocumentSnapshot ds in snapshot.docs){
        Map<String , dynamic> map = {
          FirestoreConstants.form_1_employee_comment:"",
          FirestoreConstants.form_2_employee_comment:"",
          FirestoreConstants.form_3_employee_comment:"",
          FirestoreConstants.form_4_employee_comment:"",
          FirestoreConstants.form_5_employee_comment:"",
          FirestoreConstants.form_6_employee_comment:"",
        };
        batch.update(instance.collection(studentFormCollection).doc(ds.id), map);
      }
     var result = await batch.commit();
      print("tfvygbuhnijmko,l.;");
    }catch(e){
      print(e);
    }
  }

  Future<void> updateUserWithToken(String token,String user_id) async {
    CollectionReference userCollection1= FirebaseFirestore.instance.collection(userCollection);
    try{
      userCollection1.doc(user_id).update({FirestoreConstants.firebaseToken:token});
    }catch(e){
      print(e);
    }
  }
}