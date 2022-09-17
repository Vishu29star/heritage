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

  Future<void> updateUserData(Map<String, dynamic> data) async {
    data.addAll({FirestoreConstants.updatedAt:FieldValue.serverTimestamp()});
    print(data[FirestoreConstants.uid]);
    userRefrence.doc(data[FirestoreConstants.uid]).update(data);
  }
  Future<Map<String,String>> deleteEmployyeComment({bool isFilterApplied = false,DateTime? starDate,DateTime? endDate}) async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    try{
      QuerySnapshot snapshot;
      if(isFilterApplied){
        snapshot = await instance.collection(studentFormCollection)
            .where(FirestoreConstants.user_type,isEqualTo: "customer")
            .where(FirestoreConstants.createdAt, isLessThanOrEqualTo: starDate!)
            .where(FirestoreConstants.createdAt, isGreaterThanOrEqualTo: endDate!).get();
      }else{
        snapshot = await instance.collection(studentFormCollection).where(FirestoreConstants.user_type,isEqualTo: "customer").get();
      }
      for (DocumentSnapshot ds in snapshot.docs){
        Map<String ,dynamic> dd = ds.data()! as Map<String, dynamic>;
        Map<String , dynamic> map = {};
        if(dd.containsKey(FirestoreConstants.form_1_employee_comment)){
          map.addAll({FirestoreConstants.form_1_employee_comment:"",});
        }
        if(dd.containsKey(FirestoreConstants.form_2_employee_comment)){
          map.addAll({FirestoreConstants.form_2_employee_comment:"",});
        }
        if(dd.containsKey(FirestoreConstants.form_3_employee_comment)){
          map.addAll({FirestoreConstants.form_3_employee_comment:"",});
        }
        if(dd.containsKey(FirestoreConstants.form_4_employee_comment)){
          map.addAll({FirestoreConstants.form_4_employee_comment:"",});
        }
        if(dd.containsKey(FirestoreConstants.form_5_employee_comment)){
          map.addAll({FirestoreConstants.form_5_employee_comment:"",});
        }
        if(dd.containsKey(FirestoreConstants.form_6_employee_comment)){
          map.addAll({FirestoreConstants.form_6_employee_comment:"",});
        }
        batch.update(instance.collection(studentFormCollection).doc(ds.id), map);
      }
     var result = await batch.commit();
      return {"status":"success","message":"Data deleted successfully."};
    }catch(e){
      print(e);
      return {"status":"failed","message":e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCurrentUserData(String currentUserId) async {
    var snapshot = await userdoc.doc(currentUserId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data;

  }
}