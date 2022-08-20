import 'package:Heritage/data/remote/mainService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/firestore_constants.dart';

class SuperAdminReportServices extends MainService{
  var userCollectInstance = FirebaseFirestore.instance.collection(userCollection).where(FirestoreConstants.user_type,isEqualTo: "customer");

}