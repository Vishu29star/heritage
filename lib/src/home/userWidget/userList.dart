import 'package:Heritage/constants/roundExpansionTile.dart';
import 'package:Heritage/route/myNavigator.dart';
import 'package:Heritage/route/routes.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants/noDataHeritageWidget.dart';
import '../../../data/firestore_constants.dart';
import '../../../utils/encryptry.dart';
import '../../../utils/responsive/responsive.dart';
import '../homeVM.dart';

class UserList extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final HomeVM model;
  const UserList(this.snapshot, this.model, {Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.model.initSearch();
  }
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> userList = [];
    for(int i = 0;i <widget.snapshot.data!.docs.length;i++){
      var data = widget.snapshot.data!.docs[i].data()! as Map<String, dynamic>;
      userList.add(data);
    }
    List<Widget> typesChildren = [];
    for(int i = 0;i<widget.model.searchTypes.length;i++){
     typesChildren.add(InkWell(
       onTap: () => widget.model.changeSearchType(i),
       child: Container(
         padding: EdgeInsets.symmetric(vertical: 7),
         decoration: BoxDecoration(
             color: widget.model.searchTypes[i]["isSelected"]!
                 ? context.resources.color.colorPrimary
                 : Colors.white,
             borderRadius: BorderRadius.all(Radius.circular(
                 widget.model.searchTypes[i]["isSelected"] ? 0 : 0))),
         child: Padding(
           padding: const EdgeInsets.only(left: 10.0),
           child: Text(widget.model.searchTypes[i]["key"]!,style: TextStyle(color:widget.model.searchTypes[i]["isSelected"] ? Colors.white : context.resources.color.colorPrimary),),
         ),
       ),
     ));
    }
    print("bhnjcrfvvfv ");

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
          child: RoundedExpansionTile
            (
            title: Text(widget.model.selectedSearchType!["key"],style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w500),),trailing: Icon(Icons.keyboard_arrow_down) ,
            children: typesChildren,),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: widget.model.searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: GestureDetector(
                onTap: () {
                  widget.model.searchUser();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                  child: widget.model.isSearching ? CircularProgressIndicator() : Text("Search",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w500),),
                ),
              ),
              border: OutlineInputBorder(),
              hintText: 'Search...',
            ),
          ),
        ),
        Expanded(
          child: widget.model.searchResult.length>0 ? listWidget(widget.model.searchResult) : listWidget(userList) ,
        ),
      ],
    );
  }

  Widget listWidget(List<Map<String, dynamic>> searchResult){
    List<Map<String, dynamic>> finalList = [];
    searchResult.forEach((element) {
      if(element[FirestoreConstants.user_type]=="customer"){
        finalList.add(element);
      }
    });
    if(finalList.length>0){
      return ListView.separated(
          separatorBuilder: (context, index) => Divider(color: Colors.black),
          itemCount: finalList.length,
          itemBuilder: (BuildContext ctx, int index) {
            Map<String, dynamic> data = finalList[index];
            if (widget.model.selectedUserId == "") {
              widget.model.selectuser(finalList[0][FirestoreConstants.uid], isFirst: true);
            }
            String name = "";
            if (data.containsKey(FirestoreConstants.first_name)) {
              name = encrydecry()
                  .decryptMsg(data[FirestoreConstants.first_name])
                  .toString()
                  .capitalize() +
                  " " +
                  encrydecry()
                      .decryptMsg(data[FirestoreConstants.last_name])
                      .toString()
                      .capitalize();
            }
            String email =
            encrydecry().decryptMsg(data[FirestoreConstants.email]);
            return ListTile(
              selected:
              widget.model.selectedUserId == data[FirestoreConstants.uid],
              onTap: () {
                widget.model.selectuser(data[FirestoreConstants.uid]);
                if (Responsive.isMobile(context)) {
                  var passValue = {"model": widget.model};
                  myNavigator.pushNamed(context, Routes.userDetail,
                      arguments: passValue);
                }
              },
              title: Text(name),
              subtitle: Text(email),
            );
          });
    }
    else{
      print("gyfgvhbjhoihughvbjnhk");
      widget.model.NoUserData = true;
      return HeritageNoDataWidget();
    };

  }
}
