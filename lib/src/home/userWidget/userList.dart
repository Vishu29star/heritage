import 'package:Heritage/constants/roundExpansionTile.dart';
import 'package:Heritage/models/user_model.dart';
import 'package:Heritage/route/myNavigator.dart';
import 'package:Heritage/route/routes.dart';
import 'package:Heritage/utils/colors/appColors.dart';
import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_popUps.dart';
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
    widget.model.selectedItemValue.clear();

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
            UserModel userModel = UserModel.fromJson(data);
            if (widget.model.selectedUserId == "") {
              widget.model.selectuser(finalList[0][FirestoreConstants.uid], isFirst: true);
            }
            String name = "";
            if (data.containsKey(FirestoreConstants.first_name)) {
              name = userModel.first_name! +
                  " " +
                  userModel.last_name!.capitalize();
            }
            String email = userModel.email!;
            return Column(
              children: [
                ListTile(
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
                ),
                widget.model.userType == "superadmin" ? assignedAdmin(userModel) : userModel.isLastAdminReached ? assignAdminDropDown(widget.model.selectedItemValue,index) : assignToNextAdmin()
              ],
            );
          });
    }
    else{
      print("gyfgvhbjhoihughvbjnhk");
      widget.model.NoUserData = true;
      return HeritageNoDataWidget();
    };

  }
  Widget assignToNextAdmin(){
    return InkWell(
      onTap: () async {
        var result = await userAssignToAdminDialog(context ,isPaymentOption : widget.model.userType == "2" );
        if(result != null){
          var adminType = CommanWidgets.getNextAdminCode(widget.model.userType);
          if(adminType=="4"){
            result.addAll({FirestoreConstants.isLastAdminReached:true});
          }
          result.addAll({FirestoreConstants.assign_admins :[adminType]});
          widget.model.updateUserData(result);
        }

      },
      child: Container(
        color: AppColor().colorPrimary,
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Assign to",style: TextStyle(color: Colors.white)),
            Icon(Icons.arrow_forward,color: Colors.white,),
            Text(CommanWidgets.getNextAdmin(widget.model.userType),style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget assignedAdmin(UserModel model){
    return InkWell(
      onTap: () async {
      /*  var result = await userAssignToAdminDialog(context ,isPaymentOption : widget.model.userType == "2" );
        if(result != null){
          var adminType = CommanWidgets.getNextAdminCode(widget.model.userType);
          if(adminType=="4"){
            result.addAll({FirestoreConstants.isLastAdminReached:true});
          }
          result.addAll({FirestoreConstants.assign_admins :[adminType]});
          widget.model.updateUserData(result);
        }*/

      },
      child: Container(
        color: AppColor().colorPrimary,
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Assiged Admin",style: TextStyle(color: Colors.white)),
            Icon(Icons.arrow_forward,color: Colors.white,),
            Text(CommanWidgets.getAdmin(model.assign_admins ?? [""]),style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget assignAdminDropDown(List<String> selectedItemValue, int index) {

    selectedItemValue.add("FRONT  OFFICE");
    List<String> ddl = CommanWidgets.getAdminList(widget.model.userType);
    return Container(
      //color: AppColor().colorPrimary,
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Assign to"/*,style: TextStyle(color: Colors.white)*/),
         // Icon(Icons.arrow_forward,color: Colors.white,),
          CustomDropdownButton2(
            //isExpanded: true,
            value: selectedItemValue[index].toString(),

            dropdownItems: ddl,
            onChanged: (value) async {
              selectedItemValue[index] = value.toString();
              setState(() {

              });
              print(value.toString());
              var result = await userAssignToAdminDialog(context);
              if(result != null){
                result.addAll({FirestoreConstants.assign_admins :[CommanWidgets.getNextAdminCode(widget.model.userType)]});
                widget.model.updateUserData(result);
              }
            },
            hint: 'Select Admin',
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = CommanWidgets.getAdminList(widget.model.userType);
    return ddl
        .map((value) => DropdownMenuItem(

      value: value,
      child: Text(value),
    ))
        .toList();
  }


}
