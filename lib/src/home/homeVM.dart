import 'dart:math';

import 'package:Heritage/src/cisForm/cis_form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/firestore_constants.dart';
import '../../route/myNavigator.dart';
import '../../src/home/homeService.dart';
import '../studenntForm/student_form_widget.dart';
import '../../utils/responsive/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/collipsible_nav/collapsible_sidebar/collapsible_item.dart';
import '../../route/routes.dart';
import '../mainViewModel.dart';

class HomeVM extends ChangeNotifier{
  final GlobalKey<ScaffoldState> key = GlobalKey(); // Create a key
  HomeVM(this.homeService,this.mainModel);
  final MainViewMoel? mainModel;
  final HomeService? homeService;

  BuildContext? context;
  var width;
  var height;
  int firstInit = 0;
  int pagePosition = 0;
  bool isCollapsed = true;
  bool isDataLoad = false;
  late String name, email;

  List<String> homeItems = [];
  List<Widget> generateItems =  [];

  firstInt(BuildContext context){
    this.context  = context;

    addNavItems();
    homeItems.addAll(["Express Entry","Spousal sponsership","Student visa","Care Giver Visa","Care Giver PR","Work Permits","visitor Visa"]);
    isDataLoad = true;
    notifyListeners();
  }

  openDrawer(){
    key.currentState!.openDrawer();
  }

  getLocalData(){


  }
  addNavItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var first_name = await preferences.getString(FirestoreConstnats.first_name) ?? "first name";
    var last_name = await preferences.getString(FirestoreConstnats.last_name) ?? "last name";
    name = first_name + " " + last_name;
    email = await preferences.getString(FirestoreConstnats.email) ?? "email";
    generateItems.addAll([ /*DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text('Name'),
    ),*/
      UserAccountsDrawerHeader( // <-- SEE HERE
        decoration: BoxDecoration(color: Theme.of(context!).primaryColor),
        accountName: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        accountEmail: Text(
          email,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        currentAccountPicture: FlutterLogo(),
      ),

      ListTile(
        leading: Icon(
          Icons.home,
        ),
        title: const Text('Home'),
        onTap: () {
          changeHomeItem(0);
        },
      ),
      ListTile(
        leading: Icon(
          Icons.person,
        ),
        title: const Text('Profile'),
        onTap: () {
          changeHomeItem(1);
         // Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(
          Icons.meeting_room,
        ),
        title: const Text('Metting'),
        onTap: () {
          changeHomeItem(2);
        },
      ),
    ]);
  }

  openClosedDrawer(bool collapsed){
    isCollapsed = collapsed;
    print("isCollapsed");
    print(isCollapsed);
    notifyListeners();
  }
  changeHomeItem(int pagePosition){
    print("pagePosition");
    print(pagePosition);
    for(int i = 0;i<generateItems.length;i++){
     /* if(i==pagePosition){
        generateItems[i].isSelected = true;
      }else{
        generateItems[i].isSelected = false;
      }*/
    }
    this.pagePosition = pagePosition;
    notifyListeners();
  }


  handleServiceClick(String title ){
    switch(title){
      case "Student visa":
        if(Responsive.isMobile(context!)){
          myNavigator.pushNamed(context!, Routes.studentForm);
        }else{
          showDialog(
              context: context!,
              builder: (BuildContext context){
                return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(20.0)),
                    child: Container(constraints: BoxConstraints(minWidth: 300, maxWidth: 450),child:StudenFormWidegt()));
              }
          );
        }
        break;
      case "Express Entry":
        if(Responsive.isMobile(context!)){
          myNavigator.pushNamed(context!, Routes.cisForm);
        }else{
          showDialog(
              context: context!,
              builder: (BuildContext context){
                return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(20.0)),
                    child: Container(constraints: BoxConstraints(minWidth: 300, maxWidth: 450),child:CISFormWidget()));
              }
          );
        }
        break;
    }
  }
}