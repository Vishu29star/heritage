import 'dart:convert';

import 'package:Heritage/src/personForm/person_form_service.dart';
import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/firestore_constants.dart';
import '../../data/remote/apiModels/apiResponse.dart';
import '../../models/user_model.dart';
import '../../utils/Utils.dart';
import '../mainViewModel.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:intl/intl.dart';

class PersonFormVM extends ChangeNotifier {
  final PersonService personService;
  final MainViewMoel mainModel;
  late SharedPreferences preferences;
  BuildContext context;

  PersonFormVM(this.personService, this.mainModel,this.context,this.formUserId): super() {
   getCurrentUserData();
  }

  bool isLoading =  true;
  late String formUserId;
  late String currentUID;
  late UserModel currentUserModel;
  late UserModel formUserModel;
  late String currentUserType = "customer";
  int tabPosition = 0;
  var immigartionCaseId = null;
  int studentPercent = 0;
  bool isNotificationAlreadySend = false;
  late Map<String,dynamic> studentData;



  Future<void> checkForImmigrationForm(String uid) async {
    bool isnewData = false;
    isLoading = true;
    Future.delayed(Duration(microseconds: 100),(){
      mainModel.showhideprogress(true, context);
      notifyListeners();
    });

    try{
      ApiResponse? result = await personService.checkForImmigrationForm(formUserId);
      if(result != null && result.status=="success"){
        immigartionCaseId = result.data[FirestoreConstants.immigrationFormCaseID].toString();
        print("studentCaseId");
        print(immigartionCaseId);
        formUserModel = UserModel.fromJson(result.data);

        studentPercent = checkAndGetValue(result.data,FirestoreConstants.studentFormPercent,defaultValue: 0);
        if(studentPercent>75){
          isNotificationAlreadySend = true;
        }
        ApiResponse? studentDataResponse = await personService.getUserStudentForm(immigartionCaseId);
        studentData = studentDataResponse.data;
        List<dynamic> list = studentData[FirestoreConstants.logs];
        list.insert(0,{FirestoreConstants.time:DateTime.now().millisecondsSinceEpoch,FirestoreConstants.uid:currentUID});
        Map<String,dynamic> data = {
          FirestoreConstants.updatedAt:FieldValue.serverTimestamp(),
          FirestoreConstants.logs:list
        };
        await personService.updateStudentForm(data,immigartionCaseId);

      }else{
        print("33333333333");
        formUserModel = UserModel.fromJson(result.data);
        int? count = await personService.getFormCount(FirestoreConstants.studentformcount);
        // var uuid = Uuid();
        //var case_id = firstName[0]+firstName[firstName.length-1]+ DateTime.now().millisecondsSinceEpoch.toString()+lastName[0]+lastName[lastName.length-1] ;

        var case_id = "cl"+"-"+DateFormat('yy').format(DateTime.now())+"-"+mainModel.formatter.format(count);
        Map<String,dynamic> data = {
          FirestoreConstants.case_id:case_id,
          FirestoreConstants.createdAt:FieldValue.serverTimestamp(),
          FirestoreConstants.updatedAt:FieldValue.serverTimestamp(),
          FirestoreConstants.logs:FieldValue.arrayUnion([{FirestoreConstants.time:DateTime.now().millisecondsSinceEpoch,FirestoreConstants.uid:currentUID}])
        };
        await personService.createUserStudentForm(data);
        immigartionCaseId = case_id;
        personService.updateUserWithStudentFormId(case_id,formUserId);
        isnewData = true;
      }
    }catch(e){
      CommanWidgets.showToast(e.toString());
    }

    isLoading = false;
    mainModel.showhideprogress(false, context);
    if(isnewData){
      Future.delayed(Duration(milliseconds: 500),(){
        notifyListeners();
      });
    }
    if(!isnewData){
      notifyListeners();
    }
  }

  onBackPress(){
    if(tabPosition==0){
      Navigator.of(context).pop();
    }else{
      tabPosition--;
      // notifyListeners();
    }
  }
  getCurrentUserData() async {
    preferences = await SharedPreferences.getInstance();
    var model = await preferences.getString(FirestoreConstants.userProfile) ?? "currentUserId";
    currentUserModel = UserModel.fromJson(jsonDecode(model));
    currentUID = currentUserModel.uid!;
    var currentUserEmail = currentUserModel.email!;
    if(currentUserEmail.toLowerCase().trim() == "super@heritage.com"){
      currentUserType = "superadmin";
    }
    currentUserType = currentUserModel.user_type!;
    checkForImmigrationForm(formUserId);
  }

  List<String> getTabs(Map<String, dynamic> data) {
    studentData = data;
    return ["All", "Personal Detail", "Education Detail", "ielts","Work Experience","Job offer","Travel History","Financials","Family information",];
  }


//personal Detail Data
  TextEditingController nameController = TextEditingController();
  var nameErrorText = null;
  TextEditingController refferdByController = TextEditingController();
  DateTime currentDate = DateTime.now();
  late DateTime DOBDate = currentDate;

  TextEditingController studentContactController = TextEditingController();
  var studentContactError = null;
  String selectedCallTime = "10:00 AM - 11:59 AM";
  var studentemailError = null;
  TextEditingController emailStudentController = TextEditingController();
  String married = "";
  String previousMarriage = "";
  late DateTime marriageDate = DOBDate.add(Duration(days: 5000));
  var noOfChildrenError = null;
  TextEditingController noOfChildren = TextEditingController();
  TextEditingController noOfChildrenPreviousMarriage = TextEditingController();
  TextEditingController reasonOfPreviousMarriageEnding = TextEditingController();
  TextEditingController TypeOfPreviousMarriageRelation = TextEditingController();



  // Educational Data

  List<Map<String, dynamic>> educationDetailsArray = [];
  String selectedEducationLevel = CommanWidgets.educationLevel[0];
  List<String> listEducationLevel = CommanWidgets.educationLevel;

  late DateTime selectedFromDate = currentDate;
  late DateTime selectedToDate = currentDate;
  String regularCorrespondance = "";
  String credentialAwarded = "";
  String markSheetAvailable = "";
  TextEditingController selectedStream = TextEditingController();
  TextEditingController selectedUniversity = TextEditingController();
  Map<String,dynamic>? markSheetImage= null;
  var MSError = null;


  // Work Experience

  List<Map<String, dynamic>> WorkExperienceDetailsArray = [];
  late DateTime selectedWEFromDate = currentDate;
  late DateTime selectedWEToDate = currentDate;
  TextEditingController selectedWorkTitle = TextEditingController();
  TextEditingController selectedCompany = TextEditingController();
  TextEditingController selectedIndustries = TextEditingController();
  TextEditingController selectedWorkLocation = TextEditingController();

  Future<void> checkTheData(int tabposition) async {
    FocusManager.instance.primaryFocus?.unfocus();
    Map<String,dynamic> checkValidation = isValidate(tabposition);
    if(!checkValidation["isValid"]){
      mainModel.showTopErrorMessage(context, checkValidation["errorText"]);
      return;
    }else{

      Map<String ,dynamic> mainData = {};
      Map<String ,dynamic> mapData = await getMapData(tabposition);
      switch(tabposition){
        case 1 : {
          mainData.addAll({FirestoreConstants.immi_personal_detail : mapData});
          break;
        }
      }

      var result = await personService.updateStudentForm(mainData, immigartionCaseId);
    }

  }


  Map<String,dynamic> isValidate(int tabposition)  {
    bool isValid = true;
    String errorText = "";
    switch(tabposition){
      case 1 : {
        if(nameController.text.trim().isEmpty && nameController.text.trim().length<3){
          nameErrorText = "Please enter atleast 3 character";
          errorText = "Please enter atleast 3 character";
          isValid = false;
          return {"errorText":errorText,"isValid":isValid};
        }
        if(DOBDate.isAtSameMomentAs(currentDate)){
          errorText = "Please select Date of birth";
          isValid = false;
          return {"errorText":errorText,"isValid":isValid};
        }
        if(studentContactController.text.trim().isEmpty && studentContactController.text.trim().length<10){
          studentContactError = "Please enter correct phone number";
          errorText = "Please enter correct phone number";
          isValid = false;
          return {"errorText":errorText,"isValid":isValid};
        }
        if(!CommanWidgets.isEmail(emailStudentController.text)){
          isValid = false;
          studentemailError =  context.resources.strings.notValidEmail;
          errorText =  context.resources.strings.notValidEmail;
          return {"errorText":errorText,"isValid":isValid};
        }
        if(married == ""){
          errorText = "Please select married option.";
          isValid = false;
          return {"errorText":errorText,"isValid":isValid};
        }
        if(married.toLowerCase() == "yes"){
          if(noOfChildren.text.isEmpty){
            isValid = false;
            noOfChildrenError =  "Please enter number of children if no children then enter 0";
            errorText =  "Please enter number of children if no children then enter 0";
            return {"errorText":errorText,"isValid":isValid};
          }

        }
        if(previousMarriage == ""){
          errorText = "Please select previous marriage option.";
          isValid = false;
          return {"errorText":errorText,"isValid":isValid};
        }
        if(previousMarriage.toLowerCase() == "yes"){
          if(noOfChildrenPreviousMarriage.text.isEmpty){
            isValid = false;
            errorText =  "Please enter number of children if no children then enter 0";
            return {"errorText":errorText,"isValid":isValid};
          }
          if(reasonOfPreviousMarriageEnding.text.isEmpty){
            isValid = false;
            errorText =  "Please enter previous marriage ending reason";
            return {"errorText":errorText,"isValid":isValid};
          }
          if(TypeOfPreviousMarriageRelation.text.isEmpty){
            isValid = false;
            errorText =  "Please enter previous marriage relationship type";
            return {"errorText":errorText,"isValid":isValid};
          }
        }
        break;
      }

      case 2 :{
        break;
      }
      case 3 : {


        if(selectedWEFromDate.isAtSameMomentAs(currentDate)){
          errorText = "Please select Date of birth";
          isValid = false;
          return {"errorText":errorText,"isValid":isValid};
        }
        break;
      }
    }
    return {"errorText":errorText,"isValid":isValid};
  }

  Future<Map<String, dynamic>> getMapData(int tabposition) async {
    Map<String ,dynamic> data = {};
    switch (tabposition) {
      case 1 : {
        data.addAll(
            {
              FirestoreConstants.immi_dob:DOBDate.millisecondsSinceEpoch,
              FirestoreConstants.immi_name:nameController.text.trim(),
              FirestoreConstants.immi_contact:studentContactController.text.trim(),
              FirestoreConstants.immi_refferedBy:refferdByController.text.trim(),
              FirestoreConstants.immi_email:emailStudentController.text.trim(),
              FirestoreConstants.immi_best_time_to_call:selectedCallTime,
              FirestoreConstants.immi_married:married,
              FirestoreConstants.immi_previous_marriage:previousMarriage,
            }
        );
        if(married.toLowerCase() == "yes"){
          data.addAll({
            FirestoreConstants.immi_number_of_children:noOfChildrenPreviousMarriage.text.trim(),
            FirestoreConstants.immi_marriage_date:marriageDate.millisecondsSinceEpoch,
          });
        }
        if(previousMarriage.toLowerCase() == "yes"){
          data.addAll({
            FirestoreConstants.immi_previous_marriage_number_of_children:noOfChildrenPreviousMarriage.text.trim(),
            FirestoreConstants.immi_previous_marriage_ending_reason:reasonOfPreviousMarriageEnding.text.trim(),
            FirestoreConstants.immi_previous_marriage_releation_type:TypeOfPreviousMarriageRelation.text.trim(),
          });
        }
        break;
      }
      case 2 : {
        data.addAll(
            {
              FirestoreConstants.immi_dob:DOBDate.millisecondsSinceEpoch,
              FirestoreConstants.immi_name:nameController.text.trim(),
              FirestoreConstants.immi_contact:studentContactController.text.trim(),
              FirestoreConstants.immi_refferedBy:refferdByController.text.trim(),
              FirestoreConstants.immi_email:emailStudentController.text.trim(),
              FirestoreConstants.immi_best_time_to_call:selectedCallTime,
              FirestoreConstants.immi_married:married,
              FirestoreConstants.immi_previous_marriage:previousMarriage,
            }
        );
        break;
      }
    }
    return data;
  }

  addEducationInList(){
    Map<String, dynamic> checkEducateValidate = checkEducationValidation();
    if(!checkEducateValidate["isValid"]){
      mainModel.showTopErrorMessage(context, checkEducateValidate["errorText"]);
      return;
    }
    Map<String, dynamic> educationObject = getEducationData();
    educationDetailsArray.add(educationObject);
    notifyListeners();
  }

  Map<String,dynamic> getEducationData(){
    Map<String, dynamic> educationObject = {};

    educationObject.addAll({
      FirestoreConstants.immi_education_level:selectedEducationLevel,
      FirestoreConstants.immi_education_from_date:selectedFromDate.millisecondsSinceEpoch,
      FirestoreConstants.immi_education_to_date:selectedToDate.millisecondsSinceEpoch,
      FirestoreConstants.immi_education_regular_correspondance:regularCorrespondance,
      FirestoreConstants.immi_education_credential_awarded:credentialAwarded,
      FirestoreConstants.immi_education_marksheet_available:markSheetAvailable,
      FirestoreConstants.immi_education_stream:selectedStream.text,
      FirestoreConstants.immi_education_university:selectedStream.text,
      
    });
    if(markSheetImage!=null){
      educationObject.addAll({
        FirestoreConstants.immi_education_marksheet:markSheetImage,
      });
    }
    listEducationLevel = getEducationLevel(selectedEducationLevel);
    selectedEducationLevel = listEducationLevel[0];

    selectedFromDate = currentDate;
    selectedToDate = currentDate;
    regularCorrespondance = "";
    credentialAwarded = "";
    markSheetAvailable = "";
    selectedStream.clear();
    selectedUniversity.clear();
    markSheetImage= null;
    MSError = null;
    return educationObject;
  }

  Map<String,dynamic> checkEducationValidation(){

    if(selectedFromDate.isAtSameMomentAs(currentDate)){
      return {"errorText":"Please select From Date","isValid":false};
    }
    if(selectedToDate.isAtSameMomentAs(selectedFromDate)){
      return {"errorText":"Please select To Date","isValid":false};
    }
    if(regularCorrespondance == ""){
      return {"errorText":"Please select Regular or Correspondance","isValid":false};
    }
    if(credentialAwarded == ""){
      return {"errorText":"Please select Credential Awarded","isValid":false};
    }
    if(markSheetAvailable == ""){
      return {"errorText":"Please select MarkSheet Available","isValid":false};
    }
    if(selectedStream.text.trim().isEmpty && selectedStream.text.trim().length<2){
      return {"errorText": "Please enter stream of education","isValid":false};
    }
    if(selectedUniversity.text.trim().isEmpty && selectedUniversity.text.trim().length<2){
      return {"errorText": "Please enter University of education","isValid":false};
    }
    return {"errorText":"","isValid":true};
  }
  
  List<String> getEducationLevel(String removeValue){
    List<String> list =   CommanWidgets.educationLevel..removeWhere((element) => element == removeValue);
     return list;

  }


  addWorkExperienceInList(){
    Map<String, dynamic> checkWorkExperienceValidate = checkWorkExperienceValidation();
    if(!checkWorkExperienceValidate["isValid"]){
      mainModel.showTopErrorMessage(context, checkWorkExperienceValidate["errorText"]);
      return;
    }
    Map<String, dynamic> WorkExperienceObject = getWorkExperienceData();
    WorkExperienceDetailsArray.add(WorkExperienceObject);
    notifyListeners();
  }

  Map<String,dynamic> getWorkExperienceData(){
    Map<String, dynamic> workExperienceObject = {};
    workExperienceObject.addAll({
      FirestoreConstants.immi_work_from_date:selectedWEFromDate.millisecondsSinceEpoch,
      FirestoreConstants.immi_work_to_date:selectedWEToDate.millisecondsSinceEpoch,
      FirestoreConstants.immi_education_stream:selectedWorkTitle.text,
      FirestoreConstants.immi_education_university:selectedCompany.text,
      FirestoreConstants.immi_education_university:selectedIndustries.text,
      FirestoreConstants.immi_education_university:selectedWorkLocation.text,
    });


    selectedWEFromDate = currentDate;
    selectedWEToDate = currentDate;
    selectedWorkTitle.clear();
    selectedCompany.clear();
    selectedIndustries.clear();
    selectedWorkLocation.clear();
    return workExperienceObject;
  }

  Map<String,dynamic> checkWorkExperienceValidation(){
    if(selectedWEFromDate.isAtSameMomentAs(currentDate)){
      return {"errorText":"Please select From Date","isValid":false};
    }
    if(selectedWEToDate.isAtSameMomentAs(currentDate)){
      return {"errorText":"Please select To Date","isValid":false};
    }
    if(selectedWorkTitle.text.trim().isEmpty && selectedWorkTitle.text.trim().length<2){
      return {"errorText": "Please enter work title","isValid":false};
    }
    if(selectedCompany.text.trim().isEmpty && selectedCompany.text.trim().length<2){
      return {"errorText": "Please enter Company name","isValid":false};
    }
    if(selectedIndustries.text.trim().isEmpty && selectedIndustries.text.trim().length<2){
      return {"errorText": "Please enter Company Type","isValid":false};
    }
    if(selectedWorkLocation.text.trim().isEmpty && selectedWorkLocation.text.trim().length<2){
      return {"errorText": "Please enter Company location","isValid":false};
    }
    return {"errorText":"","isValid":true};
  }

  chnageTabPosition(int position){
    tabPosition = position;
    notifyListeners();
  }


}