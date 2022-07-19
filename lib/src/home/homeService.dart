import 'package:Heritage/data/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/remote/mainService.dart';

class HomeService extends MainService{
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection(userCollection).orderBy(FirestoreConstnats.updatedAt).snapshots();
  final CollectionReference userdoc = FirebaseFirestore.instance.collection(userCollection);
}