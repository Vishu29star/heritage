import 'package:Heritage/data/firestore_constants.dart';
import 'package:Heritage/utils/encryptry.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants/HeritageCircularProgressBar.dart';
import '../../../constants/HeritageErrorWidget(.dart';
import '../../../utils/responsive/responsive.dart';
import '../homeVM.dart';

class UserDetail extends StatelessWidget {
  final HomeVM model;
  const UserDetail(this.model ,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(model.selectedUserId == ""){
      return Center(child: HeritageProgressBar());
    }
    final Stream<DocumentSnapshot> userStream  =  model.homeService!.userdoc.doc(model.selectedUserId).snapshots();
    return SafeArea(
      child: Scaffold(
        appBar: Responsive.isMobile(context) ? AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            context.resources.strings.userDetail,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).primaryColor),
          ),
        ) : PreferredSize(
            preferredSize: Size.fromHeight(0.0), // here the desired height
            child: AppBar(
              // ...
            )
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: userStream,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return HeritageErrorWidget();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return HeritageProgressBar();
            }

            List<Widget> children = [];
            int studentPercent = 0;
            Color studentPercentColor  = Colors.green;
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            if(data.containsKey(FirestoreConstants.studentFormCaseID)){
              if(data.containsKey(FirestoreConstants.studentFormPercent)){
                studentPercent = data[FirestoreConstants.studentFormPercent];
                if(studentPercent<25){
                  studentPercentColor  = Colors.redAccent;
                }else if(studentPercent<50){
                  studentPercentColor  = Colors.orangeAccent;
                }
                else if(studentPercent<75){
                  studentPercentColor  = Colors.blueAccent;
                }
              }else{
                studentPercentColor = Colors.redAccent;
              }
            }
            children.add(Text("Select Service",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),));
            children.add(SizedBox(height: 16,));
            children.add( Container(
              height: 80,
              child: ListView.builder(
                itemCount: model.homeItems.length,
                scrollDirection: Axis.horizontal,
                //padding: EdgeInsets.only(left: 8.0),
                itemBuilder: (context, i) {
                  return Container(
                    width: 250,
                    margin: EdgeInsets.only(left: i == 0 ? 0 : 12),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onTap: (){
                        model.handleServiceClick(model.homeItems[i],model.selectedUserId);
                      },
                      title: Text(model.homeItems[i].toString()),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Blah, Blah",),
                        if(model.homeItems[i]== "Student visa" && data.containsKey(FirestoreConstants.studentFormCaseID))
                          Text(studentPercent.toString()+"%",style: TextStyle(color: studentPercentColor),)
                          ],
                      )),
                  );
                },
              ),
            ),);
            if(data.containsKey(FirestoreConstants.first_name)){
              children.add(headingWithValue(context.resources.strings.name,encrydecry().decryptMsg(data[FirestoreConstants.first_name])+" "+encrydecry().decryptMsg(data[FirestoreConstants.first_name]),decrypt: false));
            }
            children.add(headingWithValue(context.resources.strings.email,data[FirestoreConstants.email]));
            if(data.containsKey(FirestoreConstants.phone_number)){
              children.add(headingWithValue(context.resources.strings.phonenumber,data[FirestoreConstants.phone_number]));
            }
            if(data.containsKey(FirestoreConstants.pincode)){
              children.add(headingWithValue(context.resources.strings.pincode,data[FirestoreConstants.pincode]));
            }
            if(data.containsKey(FirestoreConstants.dob)){
              children.add(headingWithValue(context.resources.strings.dateOfBirth,data[FirestoreConstants.dob]));
            }

            return ListView(
              padding: EdgeInsets.all(16),
              children: children,
            );
          },
        ),
      ),
    );

  }
  Widget headingWithValue(String head, String value,{bool decrypt = true}){

    return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex:3,child: Text(head)),
            Expanded(flex:7,child: Text(decrypt?encrydecry().decryptMsg(value):value)),
          ],
        )
    );
  }
}
