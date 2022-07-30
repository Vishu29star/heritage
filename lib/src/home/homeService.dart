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
}