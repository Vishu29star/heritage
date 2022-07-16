import 'package:Heritage/data/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/remote/mainService.dart';

class HomeService extends MainService{
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection("devusers").orderBy(FirestoreConstnats.updatedAt).snapshots();
}