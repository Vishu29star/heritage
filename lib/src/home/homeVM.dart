import 'package:Heritage/src/cisForm/cis_form_widget.dart';
import 'package:Heritage/utils/encryptry.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/firestore_constants.dart';
import '../../route/myNavigator.dart';
import '../../route/routes.dart';
import '../../src/home/homeService.dart';
import '../../utils/responsive/responsive.dart';
import '../mainViewModel.dart';
import '../studenntForm/student_form_widget.dart';

class HomeVM extends ChangeNotifier{
  final GlobalKey<ScaffoldState> key = GlobalKey(); // Create a key
  HomeVM(this.homeService,this.mainModel);
  final MainViewMoel? mainModel;
  final HomeService? homeService;
  String selectedUserId = "";
  String currentUserId = "";
  List<Map<String,dynamic>> searchResult = [];

  BuildContext? context;
  var width;
  var height;
  int firstInit = 0;
  int pagePosition = 0;
  bool isCollapsed = true;
  bool isDataLoad = false;
  late String name, email,userType;

  List<String> homeItems = [];
  List<Widget> generateItems =  [];
  List<dynamic> searchTypes = [];
  dynamic? selectedSearchType  ;
  bool isSearching = false;

  firstInt(BuildContext context) async {
    isDataLoad = false;
    //notifyListeners();
    this.context  = context;
    await addNavItems();
    homeItems.addAll(["Express Entry","Spousal sponsership","Student visa","Care Giver Visa","Care Giver PR","Work Permits","visitor Visa"]);
    isDataLoad = true;
    notifyListeners();
  }

  openDrawer(){
    key.currentState!.openDrawer();
  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    myNavigator.popAllAndPushNamedReplacement(context!, Routes.login);
  }

  getLocalData(){


  }
  addNavItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var first_name = await preferences.getString(FirestoreConstants.name) ?? "name";
    name = first_name;
    email = await preferences.getString(FirestoreConstants.email) ?? "email";
    currentUserId = await preferences.getString(FirestoreConstants.uid) ?? "currentUserId";
    print("vgbhnjkm");
    print(currentUserId);
    String userType = "customer";
    if(email.toLowerCase().trim()=="admin@heritage.com"){
      print("rdftghbjnkm");
      userType = "admin";
    }
    if(email.toLowerCase().trim()=="super@heritage.com"){
      print("lhfghkjlk;l");
      userType = "superadmin";
    }
    this.userType = userType;
    print(userType);
    generateItems.addAll([
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
      ListTile(
        leading: Icon(
          Icons.logout_sharp,
        ),
        title: const Text('Logout'),
        onTap: () {
          _signOut();
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


  handleServiceClick(String title,String userId){
    switch(title){
      case "Student visa":
        if(Responsive.isMobile(context!)){
          myNavigator.pushNamed(context!, Routes.studentForm,arguments: userId);
        }else{
          showDialog(
              context: context!,
              builder: (BuildContext context){
                return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(20.0)),
                    child: Container(constraints: BoxConstraints(minWidth: 300, maxWidth: 450),child:StudenFormWidegt(userId: userId,)));
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


  //Admin users data

  final TextEditingController searchController = new TextEditingController();
  String _searchText = '';
  bool showClearText = false;

  initSearch(){
    initSearchTypes();
    searchController.addListener(() {
      if(searchController.text.trim().length == 0){
        searchResult.clear();
        notifyListeners();
      }
    });
    print("ftgvybuhnijmokl,.;,l");
  }

  initSearchTypes(){
    print("vgbhjnkmlkjbhjnkm");
    searchTypes.add({"key":context!.resources.strings.firstName,"value":FirestoreConstants.first_name,"isSelected":false});
    searchTypes.add({"key":context!.resources.strings.lastName,"value":FirestoreConstants.last_name,"isSelected":false});
    searchTypes.add({"key":context!.resources.strings.phonenumber,"value":FirestoreConstants.phone_number,"isSelected":false});
    searchTypes.add({"key":context!.resources.strings.email,"value":FirestoreConstants.email,"isSelected":false});
    searchTypes.add({"key":context!.resources.strings.createdAt,"value":FirestoreConstants.createdAt,"isSelected":false});
    searchTypes.add({"key":context!.resources.strings.updatedAt,"value":FirestoreConstants.updatedAt,"isSelected":false});
    selectedSearchType  = searchTypes[0];
  }
  
  searchUser() async {
    isSearching = true;
    notifyListeners();
    QuerySnapshot? querySnapshot = await homeService?.searchUser(encrydecry().encryptMsg(searchController.text.trim()),selectedSearchType["value"]);
    if(querySnapshot!=null){
      print("querySnapshot.size");
      print(querySnapshot.size);
      searchResult.clear();
      var data = querySnapshot.docs.map((e) => e.data() as Map<String ,dynamic>).toList();
      searchResult.addAll(data);
    }
    isSearching = false;
    notifyListeners();
  }


  changeSearchType(int index){
    for(int i = 0 ;i<searchTypes.length;i++){
      if(index == i){
        searchTypes[i]["isSelected"] = true;
        selectedSearchType = searchTypes[index]!;
      }else{
        searchTypes[i]["isSelected"] = false;
      }
    }
    notifyListeners();
  }
  selectuser(String selectedUserId,{bool isFirst = false}){
    this.selectedUserId = selectedUserId;
    print("selectedUserId");
    print(selectedUserId);
    if(!isFirst){
      notifyListeners();
    }else{
      Future.delayed(Duration(seconds: 1),(){
        notifyListeners();
      });
    }

  }
}