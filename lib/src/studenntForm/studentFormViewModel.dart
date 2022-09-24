import 'dart:convert';

import 'package:Heritage/data/remote/apiModels/apiResponse.dart';
import 'package:Heritage/main.dart';
import 'package:Heritage/route/routes.dart';
import 'package:Heritage/src/studenntForm/studentFormService.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:Heritage/route/myNavigator.dart';

import '../../constants/FormWidgetTextField.dart';
import '../../constants/HeritageYesNoWidget.dart';
import '../../constants/HeritagedatePicker.dart';
import '../../constants/image_picker_utils.dart';
import '../../constants/pdfPreview.dart';
import '../../constants/uploadDocumentWidget.dart';
import '../../data/firestore_constants.dart';
import '../../models/user_model.dart';
import '../../utils/Utils.dart';

import '../../utils/comman/commanWidget.dart';
import '../../utils/responsive/responsive.dart';
import '../mainViewModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:intl/intl.dart';


class StudentFormVM extends ChangeNotifier {
  StudentFormVM(this.studentFormService, this.mainModel);

  final MainViewMoel? mainModel;
  final StudentFormService? studentFormService;

  late BuildContext context;
  late String formUserId;
  late String currentUID;
  late UserModel currentUserModel;
  late UserModel formUserModel;
  late String currentUserEmail;
  late String currentUserType = "customer";
  late SharedPreferences preferences;

  bool isLoading =  true;
  dynamic errorText ;
  int firstInt = 0;
  var nameErrorText = null;
  var pdfFont ;
  var cityVillageErrorText = null;
  var studentContactError = null;
  var PPIMageError = null;
  var tenMSError = null;
  var tweleveMSError = null;
  var studentemailError = null;
  var emailParentError = null;
  DateTime date = DateTime.now();
  DateTime passportExpiryDate = DateTime.now();
  TextEditingController nameController = TextEditingController();
  Map<String,dynamic>? PPImage = null;
  bool isPassportUpdated = false;
  TextEditingController refferdByController = TextEditingController();
  TextEditingController emailStudentController = TextEditingController();
  TextEditingController emailParentController = TextEditingController();
  TextEditingController noOfChildren = TextEditingController();
  late DateTime DOBDate = DateTime.now();
  TextEditingController cityVillageController = TextEditingController();
  String SelctedMarriageOption = "";
  TextEditingController ifChildrenController = TextEditingController();
  TextEditingController spouseNameController = TextEditingController();
  TextEditingController spouseOccupationController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherOccupationController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController motherOccupationController = TextEditingController();
  TextEditingController netFamilyIncomeController = TextEditingController();
  TextEditingController studentContactController = TextEditingController();
  TextEditingController parentContactController = TextEditingController();
  late DateTime tenFromDate = DateTime.now();
  late DateTime tenToDate = DateTime.now();
  Map<String,dynamic>? tenMarkSheetImage= null;
  late DateTime twelveFromDate = DateTime.now();
  late DateTime twelveToDate = DateTime.now();
  late DateTime ieltsYear = DateTime.now();
  Map<String,dynamic>? twelveMarkSheetImage = null;
  TextEditingController tenthStreamController = TextEditingController();
  TextEditingController tenthPercentagemarksController = TextEditingController();
  TextEditingController tenthBacklogController = TextEditingController();
  TextEditingController tenthBoardController = TextEditingController();
  TextEditingController twelveStreamController = TextEditingController();
  TextEditingController twelvePercentagemarksController = TextEditingController();
  TextEditingController twelveBacklogController = TextEditingController();
  TextEditingController twelveBoardController = TextEditingController();
  TextEditingController travelHistoryController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController refusalReasonController = TextEditingController();
  String married = "";
  String anyRefusal = "";
  String criminalHistory = "";
  double profilePerCent = 0.0;

  TextEditingController ieltsLController = TextEditingController();
  TextEditingController ieltsRController = TextEditingController();
  TextEditingController ieltsWController = TextEditingController();
  TextEditingController ieltsSController = TextEditingController();
  TextEditingController ieltsOAController = TextEditingController();
  TextEditingController ieltsIDBBCController = TextEditingController();
  TextEditingController anyProvinceController = TextEditingController();
  TextEditingController anyCollegeController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController advisorController = TextEditingController();

  TextEditingController form1EmployeeCommentController = TextEditingController();
  TextEditingController form1CustomerCommentController = TextEditingController();
  TextEditingController form2EmployeeCommentController = TextEditingController();
  TextEditingController form2CustomerCommentController = TextEditingController();
  TextEditingController form3EmployeeCommentController = TextEditingController();
  TextEditingController form3CustomerCommentController = TextEditingController();
  TextEditingController form4EmployeeCommentController = TextEditingController();
  TextEditingController form4CustomerCommentController = TextEditingController();
  TextEditingController form5EmployeeCommentController = TextEditingController();
  TextEditingController form5CustomerCommentController = TextEditingController();
  TextEditingController form6EmployeeCommentController = TextEditingController();
  TextEditingController form6CustomerCommentController = TextEditingController();

  int pagePostion = 0;
  PageController pageController =
  PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  var form1Widget;
  var form2Widget;
  var form3Widget;
  var form4Widget;
  var form5Widget;
  var form6Widget;
  List<Widget> formWidgets = [];

  var studentCaseId = null;
  int studentPercent = 0;
  bool isNotificationAlreadySend = false;
  var studentData;



  Future<void> checkForStudentForm(BuildContext context,String uid) async {
    bool isnewData = false;
    this.context = context;
    formUserId= uid;
    print(formUserId);
    preferences = await SharedPreferences.getInstance();
    var model = await preferences.getString(FirestoreConstants.userProfile) ?? "currentUserId";
    currentUserModel = UserModel.fromJson(jsonDecode(model));
    currentUID = currentUserModel.uid!;
    currentUserEmail = currentUserModel.email!;


    if(currentUserEmail.toLowerCase().trim()=="super@heritage.com"){
      print("lhfghkjlk;l");
      currentUserType = "superadmin";
    }
    currentUserType = currentUserModel.user_type!;
    print("vgbhnjkm");
    print(currentUID);
    isLoading = true;
    Future.delayed(Duration(microseconds: 100),(){
      mainModel?.showhideprogress(true, context);
      notifyListeners();
    });
    try{
      ApiResponse? result = await studentFormService?.checkForStudentForm(formUserId);
      print("1111111");

      if(result != null && result.status=="success"){
        print("2222222");
        studentCaseId = result.data[FirestoreConstants.studentFormCaseID].toString();
        print("studentCaseId");
        print(studentCaseId);
        formUserModel = UserModel.fromJson(result.data);
        studentCaseId = formUserModel.studentFormCaseID;
        studentPercent = checkAndGetValue(result.data,FirestoreConstants.studentFormPercent,defaultValue: 0);
        if(studentPercent>75){
          isNotificationAlreadySend = true;
        }
        ApiResponse? studentDataResponse = await studentFormService?.getUserStudentForm(studentCaseId);
        Map<String,dynamic> studentData = studentDataResponse!.data;
        List<dynamic> list = studentData[FirestoreConstants.logs];
        list.insert(0,{FirestoreConstants.time:DateTime.now().millisecondsSinceEpoch,FirestoreConstants.uid:currentUID});
        Map<String,dynamic> data = {
          FirestoreConstants.updatedAt:FieldValue.serverTimestamp(),
          FirestoreConstants.logs:list
        };
        await studentFormService?.updateStudentForm(data,studentCaseId);
      }
      else if(result != null && result.status=="fail"){
        print("33333333333");
        formUserModel = UserModel.fromJson(result.data);
        int? count = await studentFormService?.getFormCount(FirestoreConstants.studentformcount);
       // var uuid = Uuid();
        //var case_id = firstName[0]+firstName[firstName.length-1]+ DateTime.now().millisecondsSinceEpoch.toString()+lastName[0]+lastName[lastName.length-1] ;

        var case_id = "cl"+"-"+DateFormat('yy').format(DateTime.now())+"-"+mainModel!.formatter.format(count);
        Map<String,dynamic> data = {
          FirestoreConstants.case_id:case_id,
          FirestoreConstants.createdAt:FieldValue.serverTimestamp(),
          FirestoreConstants.updatedAt:FieldValue.serverTimestamp(),
          FirestoreConstants.logs:FieldValue.arrayUnion([{FirestoreConstants.time:DateTime.now().millisecondsSinceEpoch,FirestoreConstants.uid:currentUID}])
        };
        await studentFormService?.createUserStudentForm(data);
        studentCaseId = case_id;
        print("studentCaseId");
        print(studentCaseId);
        studentFormService?.updateUserWithStudentFormId(case_id,formUserId);
        isnewData = true;
      }
    }catch(e){
      print("vbhnjmk,");
      print(e);
      errorText = e.toString();
    }
    isLoading = false;
    mainModel?.showhideprogress(false, context);
    if(isnewData){
      Future.delayed(Duration(milliseconds: 500),(){
        notifyListeners();
      });
    }
    if(!isnewData){
      notifyListeners();
    }

  }

  void setData(Map<String, dynamic> data){
    //form 1
    if(data.containsKey(FirestoreConstants.student_form_date)){
      date = DateTime.fromMillisecondsSinceEpoch(data[FirestoreConstants.student_form_date]);
    }
    if(data.containsKey(FirestoreConstants.student_form_name)){
      nameController.text = data[FirestoreConstants.student_form_name];
    }
    if(data.containsKey(FirestoreConstants.student_form_reffered_by)){
      refferdByController.text = data[FirestoreConstants.student_form_reffered_by];
    }
    if(data.containsKey(FirestoreConstants.student_form_DOB)){
      DOBDate = DateTime.fromMillisecondsSinceEpoch(data[FirestoreConstants.student_form_DOB]);
    }
    if(data.containsKey(FirestoreConstants.student_form_city_village)){
      cityVillageController.text = data[FirestoreConstants.student_form_city_village];
    }
    if(data.containsKey(FirestoreConstants.student_form_city_village)){
      cityVillageController.text = data[FirestoreConstants.student_form_city_village];
    }
    if(data.containsKey(FirestoreConstants.form_1_employee_comment)){
      form1EmployeeCommentController.text = data[FirestoreConstants.form_1_employee_comment];
    }
    if(data.containsKey(FirestoreConstants.form_1_customer_comment)){
      form1CustomerCommentController.text = data[FirestoreConstants.form_1_customer_comment];
    }

    //form 2
    if(data.containsKey(FirestoreConstants.student_form_contact)){
      studentContactController.text = data[FirestoreConstants.student_form_contact];
    }
    if(data.containsKey(FirestoreConstants.student_form_email)){
      emailStudentController.text = data[FirestoreConstants.student_form_email];
    }
    if(data.containsKey(FirestoreConstants.student_form_parent_email)){
      emailParentController.text = data[FirestoreConstants.student_form_parent_email];
    }
    if(data.containsKey(FirestoreConstants.passport_image)){
      PPImage = data[FirestoreConstants.passport_image];
    }
    if(data.containsKey(FirestoreConstants.student_form_date)){
      passportExpiryDate = DateTime.fromMillisecondsSinceEpoch(data[FirestoreConstants.passport_expiry_date]);
    }
    if(data.containsKey(FirestoreConstants.student_form_number_of_children)){
      noOfChildren.text = data[FirestoreConstants.student_form_number_of_children];
    }
    if(data.containsKey(FirestoreConstants.student_form_married)){
      married = data[FirestoreConstants.student_form_married];
    }
    if(data.containsKey(FirestoreConstants.form_2_employee_comment)){
      form2EmployeeCommentController.text = data[FirestoreConstants.form_2_employee_comment];
    }
    if(data.containsKey(FirestoreConstants.form_2_customer_comment)){
      form2CustomerCommentController.text = data[FirestoreConstants.form_2_customer_comment];
    }

    //form 3
    if(data.containsKey(FirestoreConstants.student_spouse_name)){
      spouseNameController.text = data[FirestoreConstants.student_spouse_name];
    }
    if(data.containsKey(FirestoreConstants.student_spouse_occupation)){
      spouseOccupationController.text = data[FirestoreConstants.student_spouse_occupation];
    }
    if(data.containsKey(FirestoreConstants.student_father_name)){
      fatherNameController.text = data[FirestoreConstants.student_father_name];
    }
    if(data.containsKey(FirestoreConstants.student_father_occupation)){
      fatherOccupationController.text = data[FirestoreConstants.student_father_occupation];
    }
    if(data.containsKey(FirestoreConstants.student_mother_name)){
      motherNameController.text = data[FirestoreConstants.student_mother_name];
    }
    if(data.containsKey(FirestoreConstants.student_mother_occupation)){
      motherOccupationController.text = data[FirestoreConstants.student_mother_occupation];
    }
    if(data.containsKey(FirestoreConstants.student_parent_contact)){
      parentContactController.text = data[FirestoreConstants.student_parent_contact];
    }
    if(data.containsKey(FirestoreConstants.student_family_net_income)){
      netFamilyIncomeController.text  = data[FirestoreConstants.student_family_net_income];
    }
    if(data.containsKey(FirestoreConstants.form_3_employee_comment)){
      form3EmployeeCommentController.text = data[FirestoreConstants.form_3_employee_comment];
    }
    if(data.containsKey(FirestoreConstants.form_3_customer_comment)){
      form3CustomerCommentController.text = data[FirestoreConstants.form_3_customer_comment];
    }
    //student form 4
    if(data.containsKey(FirestoreConstants.student_tenth_from_date)){
      tenFromDate = DateTime.fromMillisecondsSinceEpoch(data[FirestoreConstants.student_tenth_from_date]);
    }
    if(data.containsKey(FirestoreConstants.student_tenth_to_date)){
      tenToDate = DateTime.fromMillisecondsSinceEpoch(data[FirestoreConstants.student_tenth_to_date]);
    }
    if(data.containsKey(FirestoreConstants.student_tenth_stream)){
      tenthStreamController.text  = data[FirestoreConstants.student_tenth_stream];
    }
    if(data.containsKey(FirestoreConstants.student_tenth_board)){
      tenthBoardController.text  = data[FirestoreConstants.student_tenth_board];
    }
    if(data.containsKey(FirestoreConstants.student_tenth_marks_percentage)){
      tenthPercentagemarksController.text  = data[FirestoreConstants.student_tenth_marks_percentage];
    }
    if(data.containsKey(FirestoreConstants.student_tenth_backlog)){
      tenthBacklogController.text  = data[FirestoreConstants.student_tenth_backlog];
    }

    if(data.containsKey(FirestoreConstants.student_twelve_from_date)){
      twelveFromDate = DateTime.fromMillisecondsSinceEpoch(data[FirestoreConstants.student_twelve_from_date]);
    }
    if(data.containsKey(FirestoreConstants.student_twelve_to_date)){
      twelveToDate = DateTime.fromMillisecondsSinceEpoch(data[FirestoreConstants.student_twelve_to_date]);
    }
    if(data.containsKey(FirestoreConstants.student_twelve_stream)){
      twelveStreamController.text  = data[FirestoreConstants.student_twelve_stream];
    }
    if(data.containsKey(FirestoreConstants.student_twelve_marks_percentage)){
      twelvePercentagemarksController.text  = data[FirestoreConstants.student_twelve_marks_percentage];
    }
    if(data.containsKey(FirestoreConstants.student_twelve_board)){
      twelveBoardController.text  = data[FirestoreConstants.student_twelve_board];
    }
    if(data.containsKey(FirestoreConstants.student_twelve_backlog)){
      twelveBacklogController.text  = data[FirestoreConstants.student_twelve_backlog];
    }
    if(data.containsKey(FirestoreConstants.form_4_employee_comment)){
      form4EmployeeCommentController.text = data[FirestoreConstants.form_4_employee_comment];
    }
    if(data.containsKey(FirestoreConstants.student_form_tenth_MS)){
      tenMarkSheetImage = data[FirestoreConstants.student_form_tenth_MS];
    }
    if(data.containsKey(FirestoreConstants.student_form_twelve_MS)){
      twelveMarkSheetImage = data[FirestoreConstants.student_form_twelve_MS];
    }

    //student form 5
    if(data.containsKey(FirestoreConstants.student_travel_history)){
      travelHistoryController.text = data[FirestoreConstants.student_travel_history];
    }
    if(data.containsKey(FirestoreConstants.student_country)){
      countryController.text = data[FirestoreConstants.student_country];
    }
    if(data.containsKey(FirestoreConstants.student_criminal_history)){
      criminalHistory = data[FirestoreConstants.student_criminal_history];
    }
    if(data.containsKey(FirestoreConstants.student_any_refusal)){
      anyRefusal = data[FirestoreConstants.student_any_refusal];
    }
    if(data.containsKey(FirestoreConstants.form_5_employee_comment)){
      form5EmployeeCommentController.text = data[FirestoreConstants.form_5_employee_comment];
    }
    if(data.containsKey(FirestoreConstants.form_5_customer_comment)){
      form5CustomerCommentController.text = data[FirestoreConstants.form_5_customer_comment];
    }
    //student form 6
    if(data.containsKey(FirestoreConstants.student_ielts_year)){
      ieltsYear = DateTime.fromMillisecondsSinceEpoch(data[FirestoreConstants.student_ielts_year]);
    }
    if(data.containsKey(FirestoreConstants.student_ielts_l)){
      ieltsLController.text = data[FirestoreConstants.student_ielts_l];
    }
    if(data.containsKey(FirestoreConstants.student_ielts_r)){
      ieltsRController.text = data[FirestoreConstants.student_ielts_r];
    }
    if(data.containsKey(FirestoreConstants.student_ielts_w)){
      ieltsWController.text = data[FirestoreConstants.student_ielts_w];
    }
    if(data.containsKey(FirestoreConstants.student_ielts_s)){
      ieltsSController.text = data[FirestoreConstants.student_ielts_s];
    }
    if(data.containsKey(FirestoreConstants.student_ielts_OA)){
      ieltsOAController.text = data[FirestoreConstants.student_ielts_OA];
    }
    if(data.containsKey(FirestoreConstants.student_ielts_IDBBC)){
      ieltsIDBBCController.text = data[FirestoreConstants.student_ielts_IDBBC];
    }
    if(data.containsKey(FirestoreConstants.student_ielts_any_province)){
      anyProvinceController.text = data[FirestoreConstants.student_ielts_any_province];
    }
    if(data.containsKey(FirestoreConstants.student_ielts_any_college)){
      anyCollegeController.text = data[FirestoreConstants.student_ielts_any_college];
    }

    if(data.containsKey(FirestoreConstants.student_ielts_advisor)){
      advisorController.text = data[FirestoreConstants.student_ielts_advisor];
    }
    if(data.containsKey(FirestoreConstants.student_ielts_remark)){
      remarkController.text = data[FirestoreConstants.student_ielts_remark];
    }
    if(data.containsKey(FirestoreConstants.form_6_employee_comment)){
      form6EmployeeCommentController.text = data[FirestoreConstants.form_6_employee_comment];
    }
    if(data.containsKey(FirestoreConstants.form_6_customer_comment)){
      form6CustomerCommentController.text = data[FirestoreConstants.form_6_customer_comment];
    }
  }


  onBackPress(){
    if(pagePostion==0){
      Navigator.of(context).pop();
    }else{
      pagePostion--;
      pageController.animateToPage(
        pagePostion,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
     // notifyListeners();
    }
  }

  List<Widget> getWidgetList(Map<String, dynamic> data){
    studentData = data;
    setData(data);
    form1Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeritagedatePicker(
                  isEnable: false,
                  onDateSelection: (dd){
                    date = dd;
                  },
                  rowORColumn: 1,
                  result: date,
                  dateFormat: context.resources.strings.DDMMYYYY,
                  labelText: context.resources.strings.date,
                ),
                Divider(),
                HeritageTextFeild(
                  errorText: nameErrorText,
                  controller: nameController,
                  hintText: context.resources.strings.hintName,
                  labelText: context.resources.strings.enterName,
                ),
                HeritageTextFeild(
                  controller: refferdByController,
                  hintText: context.resources.strings.hintName,
                  labelText: context.resources.strings.refferedby,
                ),
                HeritagedatePicker(
                  isDOB:true,
                  onDateSelection: (dd){
                    DOBDate = dd;
                  },
                  rowORColumn: 1,
                  result: DOBDate,
                  dateFormat: context.resources.strings.DDMMYYYY,
                  labelText: context.resources.strings.dateOfBirth,
                ),
                Divider(),
                HeritageTextFeild(
                  errorText: cityVillageErrorText,
                  controller: cityVillageController,
                  hintText: context.resources.strings.hintCityName,
                  labelText: context.resources.strings.cityVillage,
                ),
                HeritageTextFeild(
                  controller: form1CustomerCommentController,
                  hintText: context.resources.strings.customerComment,
                  labelText: context.resources.strings.customerComment,
                ),
                HeritageTextFeild(
                  controller: form1EmployeeCommentController,
                  hintText: context.resources.strings.employeeComment,
                  labelText: context.resources.strings.employeeComment,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        button1(),
      ],
    );

    form2Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeritageTextFeild(
                  errorText: studentContactError,
                  controller: studentContactController,
                  hintText: context.resources.strings.hintphoneNumber,
                  labelText: context.resources.strings.enterStudentContactNo,
                  keyboardType: TextInputType.phone,
                  prefixText: context.resources.strings.phoneNumberPrefix,
                  inputformator: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter(10),],
                ),
                HeritageTextFeild(
                  errorText: studentemailError,
                  controller: emailStudentController,
                  hintText: context.resources.strings.emailHint,
                  labelText: context.resources.strings.enterEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                HeritageDoumentUpload(imageError: PPIMageError,image: PPImage,labelText: "Passport Image",
                  onImageSelection: (image){
                    PPImage = image;
                  },
                ),

                HeritagedatePicker(
                  isEnable: true,
                  onDateSelection: (dd){
                    passportExpiryDate = dd;
                  },
                  rowORColumn: 1,
                  result: passportExpiryDate,
                  dateFormat: context.resources.strings.DDMMYYYY,
                  labelText: context.resources.strings.passportExpiryDate,
                ),
                Divider(),
                HeritageTextFeild(
                  errorText: emailParentError,
                  controller: emailParentController,
                  hintText: context.resources.strings.emailHint,
                  labelText: context.resources.strings.enterParentemail,
                  keyboardType: TextInputType.emailAddress,
                ),
                HeritageTextFeild(
                  keyboardType: TextInputType.phone,
                  controller: noOfChildren,
                  hintText: context.resources.strings.zero,
                  labelText: context.resources.strings.numberOfChildren,
                  inputformator: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter(2),],
                ),
                YesNoWidget(labelText: context.resources.strings.married, selected: married,onSelection: (result){
                  married = result;
                },),

                HeritageTextFeild(
                  controller: form2CustomerCommentController,
                  hintText: context.resources.strings.customerComment,
                  labelText: context.resources.strings.customerComment,
                ),
                HeritageTextFeild(
                  controller: form2EmployeeCommentController,
                  hintText: context.resources.strings.employeeComment,
                  labelText: context.resources.strings.employeeComment,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        button1(),
      ],
    );
    form3Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //HeritagedatePicker(rowORColumn: 1, result: DOBdate,dateFormat: 'yyyy-MM-dd',labelText: "DOB",),
                //Divider(),
                HeritageTextFeild(
                  keyboardType: TextInputType.name,
                  controller: spouseNameController,
                  hintText: context.resources.strings.hintName,
                  labelText: context.resources.strings.spousesName,
                ),
                HeritageTextFeild(
                  keyboardType: TextInputType.name,
                  controller: spouseOccupationController,
                  hintText: context.resources.strings.manager,
                  labelText: context.resources.strings.spousesOccupation,
                ),
                HeritageTextFeild(
                  keyboardType: TextInputType.name,
                  controller: fatherNameController,
                  hintText: context.resources.strings.hintName,
                  labelText: context.resources.strings.fathersName,
                ),
                HeritageTextFeild(
                  keyboardType: TextInputType.name,
                  controller: fatherOccupationController,
                  hintText: context.resources.strings.manager,
                  labelText: context.resources.strings.fathersOccupation,
                ),
                HeritageTextFeild(
                  keyboardType: TextInputType.name,
                  controller: motherNameController,
                  hintText: context.resources.strings.hintName,
                  labelText: context.resources.strings.mothersName,
                ),
                HeritageTextFeild(
                  keyboardType: TextInputType.name,
                  controller: motherOccupationController,
                  hintText: context.resources.strings.manager,
                  labelText: context.resources.strings.mothersOccupation,
                ),
                HeritageTextFeild(
                  keyboardType: TextInputType.phone,
                  controller: parentContactController,
                  hintText: context.resources.strings.hintphoneNumber,
                  labelText: "Parent’s Contact No.",
                  prefixText: context.resources.strings.phoneNumberPrefix,
                  inputformator: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter(10),],
                ),
                HeritageTextFeild(
                  keyboardType: TextInputType.number,
                  controller: netFamilyIncomeController,
                  hintText: context.resources.strings.hintphoneNumber,
                  labelText: context.resources.strings.netFamilyIncomeAnnually,
                  inputformator: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter(10),],
                ),

                HeritageTextFeild(
                  controller: form3CustomerCommentController,
                  hintText: context.resources.strings.customerComment,
                  labelText: context.resources.strings.customerComment,
                ),
                HeritageTextFeild(
                  controller: form3EmployeeCommentController,
                  hintText: context.resources.strings.employeeComment,
                  labelText: context.resources.strings.employeeComment,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        button1(),
      ],
    );
    form4Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.resources.strings.educationalInformation,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  context.resources.strings.tenth,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: HeritagedatePicker(
                        onDateSelection: (dd){
                          tenFromDate = dd;
                        },
                        rowORColumn: 2,
                        result: tenFromDate,
                        dateFormat: context.resources.strings.monthyearDateFormat,
                        labelText: context.resources.strings.fromMMYYYY,
                      ),
                    ),
                    verticleDivider,
                    Expanded(
                      child: HeritagedatePicker(
                        onDateSelection: (dd){
                          tenToDate = dd;
                        },
                        rowORColumn: 2,
                        result: tenToDate,
                        dateFormat:context.resources.strings.monthyearDateFormat,
                        labelText: context.resources.strings.toMMYYYY,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          keyboardType: TextInputType.text,
                          controller: tenthStreamController,
                          hintText: context.resources.strings.scienceHistory,
                          labelText: context.resources.strings.stream,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          keyboardType: TextInputType.text,
                          controller: tenthBoardController,
                          hintText: context.resources.strings.CBSE,
                          labelText: context.resources.strings.boardUniversityCollege,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputformator: [DecimalTextInputFormatter(decimalRange: 2),LengthLimitingTextInputFormatter(5),],
                          controller: tenthPercentagemarksController,
                          hintText: context.resources.strings.percentageHint,
                          labelText: context.resources.strings.percentage,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          keyboardType: TextInputType.text,
                          controller: tenthBacklogController,
                          hintText: context.resources.strings.zero,
                          labelText: context.resources.strings.noofBacklogsifany,
                        )),
                  ],
                ),
                HeritageDoumentUpload(imageError: tenMSError,image: tenMarkSheetImage,labelText: "10th MarkSheet",onImageSelection: (image){
                  tenMarkSheetImage = image;
                },),
                SizedBox(
                  height: 16,
                ),
                Text(
                context.resources.strings.twelveth,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: HeritagedatePicker(
                        onDateSelection: (dd){
                          twelveFromDate = dd;
                        },
                        rowORColumn: 2,
                        result: twelveFromDate,
                        dateFormat: context.resources.strings.monthyearDateFormat,
                        labelText: context.resources.strings.fromMMYYYY,
                      ),
                    ),
                    verticleDivider,
                    Expanded(
                      child: HeritagedatePicker(
                        onDateSelection: (dd){
                          twelveToDate = dd;
                        },
                        rowORColumn: 2,
                        result: twelveToDate,
                        dateFormat: context.resources.strings.monthyearDateFormat,
                        labelText: context.resources.strings.toMMYYYY,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          keyboardType: TextInputType.text,
                          controller: twelveStreamController,
                          hintText: context.resources.strings.scienceHistory,
                          labelText: context.resources.strings.stream,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          keyboardType: TextInputType.text,
                          controller: twelveBoardController,
                          hintText: context.resources.strings.CBSE,
                          labelText: context.resources.strings.boardUniversityCollege,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          keyboardType: TextInputType.number,
                          controller: twelvePercentagemarksController,
                          hintText: context.resources.strings.percentageHint,
                          labelText: context.resources.strings.percentage,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputformator: [DecimalTextInputFormatter(decimalRange: 2),LengthLimitingTextInputFormatter(5),],
                          controller: twelveBacklogController,
                          hintText: context.resources.strings.zero,
                          labelText: context.resources.strings.noofBacklogsifany,
                        )),


                  ],
                ),
                HeritageDoumentUpload(imageError: tweleveMSError,image: twelveMarkSheetImage,labelText: "12th MarkSheet",onImageSelection: (image){
                  twelveMarkSheetImage = image;
                },),
                HeritageTextFeild(
                  controller: form4CustomerCommentController,
                  hintText: context.resources.strings.customerComment,
                  labelText: context.resources.strings.customerComment,
                ),
                HeritageTextFeild(
                  controller: form4EmployeeCommentController,
                  hintText: context.resources.strings.employeeComment,
                  labelText: context.resources.strings.employeeComment,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        button1(),
      ],
    );
    form5Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //HeritagedatePicker(rowORColumn: 1, result: DOBdate,dateFormat: 'yyyy-MM-dd',labelText: "DOB",),
                //Divider(),
                Text(
                  context.resources.strings.assessmentInformation,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                YesNoWidget(
                  onSelection: (result){
                    criminalHistory = result;
                  },
                    labelText: context.resources.strings.criminalHistory,
                    selected: criminalHistory),
                HeritageTextFeild(
                  controller: travelHistoryController,
                  hintText: context.resources.strings.dubai,
                  labelText:context.resources.strings.travelHistory,
                ),
                HeritageTextFeild(
                  controller: countryController,
                  hintText: context.resources.strings.dubai,
                  labelText:context.resources.strings.CountryIfapplicable,
                ),
                YesNoWidget(
                    onSelection: (result){
                      anyRefusal = result;
                    },
                    labelText:context.resources.strings.anyRefusals, selected: anyRefusal),

                HeritageTextFeild(
                  controller: form5CustomerCommentController,
                  hintText: context.resources.strings.customerComment,
                  labelText: context.resources.strings.customerComment,
                ),
                HeritageTextFeild(
                  controller: form5EmployeeCommentController,
                  hintText: context.resources.strings.employeeComment,
                  labelText: context.resources.strings.employeeComment,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        button1(),
      ],
    );
    form6Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //HeritagedatePicker(rowORColumn: 1, result: DOBdate,dateFormat: 'yyyy-MM-dd',labelText: "DOB",),
                //Divider(),
                Text(
                  context.resources.strings.IELTSGenAca,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                HeritagedatePicker(
                  onDateSelection: (dd){
                    ieltsYear = dd;
                  },
                  rowORColumn: 1,
                  result: ieltsYear,
                  dateFormat: context.resources.strings.yearFormat,
                  labelText: context.resources.strings.year,
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsLController,
                          hintText: context.resources.strings.eight,
                          labelText: context.resources.strings.L,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputformator: [DecimalTextInputFormatter(decimalRange: 2),LengthLimitingTextInputFormatter(3),],
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsRController,
                          hintText: context.resources.strings.eight,
                          labelText: context.resources.strings.R,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputformator: [DecimalTextInputFormatter(decimalRange: 2),LengthLimitingTextInputFormatter(3),],
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsWController,
                          hintText: context.resources.strings.eight,
                          labelText: context.resources.strings.W,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputformator: [DecimalTextInputFormatter(decimalRange: 2),LengthLimitingTextInputFormatter(3),],
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsSController,
                          hintText: context.resources.strings.eight,
                          labelText: context.resources.strings.S,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputformator: [DecimalTextInputFormatter(decimalRange: 2),LengthLimitingTextInputFormatter(3),],
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsOAController,
                          hintText: context.resources.strings.eight,
                          labelText:context.resources.strings.OA,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputformator: [DecimalTextInputFormatter(decimalRange: 2),LengthLimitingTextInputFormatter(3),],
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsIDBBCController,
                          hintText: context.resources.strings.OA,
                          labelText: context.resources.strings.IDPBC,
                        )),
                  ],
                ),
                HeritageTextFeild(
                  controller: anyProvinceController,
                  hintText: context.resources.strings.dubai,
                  labelText: context.resources.strings.anyProvincePreferenceInCanadaIfNoThenMentionNONE,
                ),
                HeritageTextFeild(
                  controller: anyCollegeController,
                  hintText: context.resources.strings.canadianUniversity,
                  labelText:
                  context.resources.strings.anyCollegeProgramPreferenceIFNoThenMentionNONE,
                ),
                HeritageTextFeild(
                  controller: remarkController,
                  //hintText: context.resources.strings.dubai,
                  labelText: context.resources.strings.remark,
                ),
                HeritageTextFeild(
                  controller: advisorController,
                 // hintText: context.resources.strings.canadianUniversity,
                  labelText: context.resources.strings.nameOfAdvisor,
                ),


                HeritageTextFeild(
                  controller: form6CustomerCommentController,
                  hintText: context.resources.strings.customerComment,
                  labelText: context.resources.strings.customerComment,
                ),
                HeritageTextFeild(
                  controller: form6EmployeeCommentController,
                  hintText: context.resources.strings.employeeComment,
                  labelText: context.resources.strings.employeeComment,
                ),
              ],
            ),
          ),
        ),

        SizedBox(
          height: 20,
        ),
        button1(),
      ],
    );
    formWidgets.add(Container(
      child: form1Widget,
    ));
    formWidgets.add(Container(
      child: form2Widget,
    ));
    formWidgets.add(Container(
      child: form3Widget,
    ));
    formWidgets.add(Container(
      child: form4Widget,
    ));
    formWidgets.add(Container(
      child: form5Widget,
    ));
    formWidgets.add(Container(
      child: form6Widget,
    ));
    return formWidgets;
  }

  Widget button1() {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child: Button(
          isEnabled: true,
          onPressed: () async {
            checkTheData();
          },
          labelText:context.resources.strings.next,
        ));
  }

  Future<void> checkTheData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(!isValidate()){
      mainModel!.showTopErrorMessage(context, "Please enter valid Data");
      return;
    }
    try{
      Map<String ,dynamic> mapData = await getMapData();
      var result = await studentFormService!.updateStudentForm(mapData, studentCaseId);
      Map<String,dynamic> userUpdateData = {FirestoreConstants.studentFormPercent:profilePerCent.ceil()};
      if(isPassportUpdated){
        userUpdateData.addAll({FirestoreConstants.passport_image:mapData[FirestoreConstants.passport_image]});
        userUpdateData.addAll({FirestoreConstants.passport_expiry_date:passportExpiryDate.millisecondsSinceEpoch});
        isPassportUpdated = false;
      }
      studentFormService?.updateUserPercentStudentFormId(formUserId,userUpdateData);
      if(pagePostion==4 /*&& !isNotificationAlreadySend*/){
        List<UserModel>? financeuser = await mainModel!.mainService.getFilteruser(filterName: "2");
        List<String> tokenList = [];
        List<String> finance_uids = [];
        if(financeuser?.length != null){
          financeuser!.forEach((element) {
            finance_uids.add(element.uid!);
            if(element.web_firebase_token != null && element.web_firebase_token != ""){
              tokenList.add(element.web_firebase_token!);
            }
            if(element.iOS_firebase_token != null && element.iOS_firebase_token != ""){
              tokenList.add(element.iOS_firebase_token!);
            }
            if(element.android_firebase_token != null && element.android_firebase_token != ""){
              tokenList.add(element.android_firebase_token!);
            }
          });
        }
        Map<String,dynamic> notificationObject = {
          "title": "Financial Profile for "+ formUserModel.name!,
          "body":"New Profile for payment",
          "mutable_content": true,
          "sound": "Tri-tone"};
        Map<String,dynamic> dataObject = {
          FirestoreConstants.uid: formUserModel.uid,
          "dl": "",
          "type":"payment_finacial_admin"
        };

        await mainModel!.sendNotification(tokenList, notificationObject, dataObject);
        await mainModel!.createNotification(finance_uids, notificationObject, dataObject);
        Map<String,dynamic> updateData = {FirestoreConstants.assign_admins : ["2"],FirestoreConstants.uid:formUserModel.uid,FirestoreConstants.is_payment_done:false};
        await mainModel!.mainService.updateUserDataMain(updateData);
      }
      if(pagePostion==5){
        mainModel!.showTopSuccessMessage(context, "Student Form Submitted");
        Navigator.pop(context);
      }else{
        pagePostion = pagePostion + 1;
        print("pagePostion");
        print(pagePostion);
        pageController.animateToPage(
          pagePostion,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }

    }catch(e){
      print(e);
    }
    //notifyListeners();
  }

  Future<Map<String,dynamic>> uploadFile(Map<String,dynamic> imageObject,{bool isPassport = false}) async {
    if(imageObject["type"] == "xfile" || imageObject["type"] == "filPicker"){
      if(imageObject["type"] == "xfile"){
        Map<String,dynamic>  dddd =  await studentFormService!.getSingleMediaUrl(imageObject["data"]);
        if(isPassport){
          dddd.addAll({"update":true});
        }
        return dddd;
      } else {
        Map<String,dynamic>  dddd =  await studentFormService!.getMediaUrlFromByte(imageObject["data"]);
        if(isPassport){
          dddd.addAll({"update":true});
        }
        return dddd;
      }
    }
    return imageObject;
  }
  Future<Map<String, dynamic>> getMapData() async {
    profilePerCent = 0.0;
    Map<String ,dynamic> data = {};
    switch(pagePostion){
      case 0:{

        data.addAll(
            {
              FirestoreConstants.student_form_DOB:DOBDate.millisecondsSinceEpoch,
              FirestoreConstants.student_form_name:nameController.text.trim(),
              FirestoreConstants.student_form_reffered_by:refferdByController.text.trim(),
              FirestoreConstants.student_form_city_village:cityVillageController.text.trim(),
              FirestoreConstants.form_1_employee_comment:form1EmployeeCommentController.text.trim(),
              FirestoreConstants.form_1_customer_comment:form1CustomerCommentController.text.trim(),
            }
        );
        profilePerCent = 11.11;
        break;
      }
      case 1:{
        print("DOmarriedBDate");
        print(married);
        Map<String,dynamic> imageObject =  await uploadFile(PPImage!,isPassport: true);
        if(imageObject.containsKey("update")) {
          imageObject.remove("update");
          isPassportUpdated = true;
        }
        data.addAll(
            {FirestoreConstants.passport_image:imageObject,
              FirestoreConstants.passport_expiry_date:passportExpiryDate.millisecondsSinceEpoch,
              FirestoreConstants.student_form_contact:studentContactController.text.trim(),
              FirestoreConstants.student_form_email:emailStudentController.text.trim(),
              FirestoreConstants.student_form_parent_email:emailParentController.text.trim(),
              FirestoreConstants.student_form_number_of_children:noOfChildren.text.trim(),
              FirestoreConstants.student_form_married:married,
              FirestoreConstants.form_2_employee_comment:form2EmployeeCommentController.text.trim(),
              FirestoreConstants.form_2_customer_comment:form2CustomerCommentController.text.trim(),
            }
        );
        profilePerCent = 22.22;
        break;
      }
      case 2:{
        print("DOmarriedBDate");
        print(married);
        data.addAll(
            {FirestoreConstants.student_spouse_name:spouseNameController.text.trim(),
              FirestoreConstants.student_spouse_occupation:spouseOccupationController.text.trim(),
              FirestoreConstants.student_father_name:fatherNameController.text.trim(),
              FirestoreConstants.student_father_occupation:fatherOccupationController.text.trim(),
              FirestoreConstants.student_mother_name:motherNameController.text.trim(),
              FirestoreConstants.student_mother_occupation:motherOccupationController.text.trim(),
              FirestoreConstants.student_parent_contact:parentContactController.text.trim(),
              FirestoreConstants.student_family_net_income:netFamilyIncomeController.text.trim(),
              FirestoreConstants.form_3_employee_comment:form3EmployeeCommentController.text.trim(),
              FirestoreConstants.form_3_customer_comment:form3CustomerCommentController.text.trim(),
            }
        );
        profilePerCent = 39.99;
        break;
      }
      case 3:{
        Map<String,dynamic> tenthMS =  await uploadFile(tenMarkSheetImage!);
        Map<String,dynamic> twelveMS =  await uploadFile(twelveMarkSheetImage!);
        data.addAll(
            {FirestoreConstants.student_tenth_to_date:tenToDate.millisecondsSinceEpoch,
              FirestoreConstants.student_tenth_from_date:tenFromDate.millisecondsSinceEpoch,
              FirestoreConstants.student_form_tenth_MS:tenthMS,
              FirestoreConstants.student_form_twelve_MS:twelveMS,
              FirestoreConstants.student_tenth_backlog:tenthBacklogController.text.trim(),
              FirestoreConstants.student_tenth_board:tenthBoardController.text.trim(),
              FirestoreConstants.student_tenth_stream:tenthStreamController.text.trim(),
              FirestoreConstants.student_tenth_marks_percentage:tenthPercentagemarksController.text.trim(),
              FirestoreConstants.student_twelve_from_date:twelveFromDate.millisecondsSinceEpoch,
              FirestoreConstants.student_twelve_to_date:twelveToDate.millisecondsSinceEpoch,
              FirestoreConstants.student_twelve_backlog:twelveBacklogController.text.trim(),
              FirestoreConstants.student_twelve_board:twelveBoardController.text.trim(),
              FirestoreConstants.student_twelve_stream:twelveStreamController.text.trim(),
              FirestoreConstants.student_twelve_marks_percentage:twelvePercentagemarksController.text.trim(),
              FirestoreConstants.form_4_employee_comment:form4EmployeeCommentController.text.trim(),
              FirestoreConstants.form_4_customer_comment:form4CustomerCommentController.text.trim(),
            }
        );
        profilePerCent = 66.65;
        break;
      }
      case 4:{
        data.addAll(
            {FirestoreConstants.student_criminal_history:criminalHistory,
              FirestoreConstants.student_any_refusal:anyRefusal,
              FirestoreConstants.student_travel_history:travelHistoryController.text.trim(),
              FirestoreConstants.student_country:countryController.text.trim(),
              FirestoreConstants.form_5_employee_comment:form5EmployeeCommentController.text.trim(),
              FirestoreConstants.form_5_customer_comment:form5CustomerCommentController.text.trim(),
            }
        );
        profilePerCent = 75.53;
        break;
      }
      case 5:{
        data.addAll(
            {FirestoreConstants.student_ielts_year:ieltsYear.millisecondsSinceEpoch,
              FirestoreConstants.student_ielts_l:ieltsLController.text.trim(),
              FirestoreConstants.student_ielts_s:ieltsSController.text.trim(),
              FirestoreConstants.student_ielts_r:ieltsRController.text.trim(),
              FirestoreConstants.student_ielts_w:ieltsWController.text.trim(),
              FirestoreConstants.student_ielts_OA:ieltsOAController.text.trim(),
              FirestoreConstants.student_ielts_IDBBC:ieltsIDBBCController.text.trim(),
              FirestoreConstants.student_ielts_any_province:anyProvinceController.text.trim(),
              FirestoreConstants.student_ielts_any_college:anyCollegeController.text.trim(),
              FirestoreConstants.student_ielts_remark:remarkController.text.trim(),
              FirestoreConstants.student_ielts_advisor:advisorController.text.trim(),
              FirestoreConstants.form_6_employee_comment:form6EmployeeCommentController.text.trim(),
              FirestoreConstants.form_6_customer_comment:form6CustomerCommentController.text.trim(),
            }
        );
        profilePerCent = 100;
        break;
      }
    }
    return data;
  }

 bool isValidate(){
    bool isValid = true;
    switch(pagePostion){
      case 0:{
        if(nameController.text.trim().isEmpty && nameController.text.trim().length<3){
          nameErrorText = "Please enter atleast 3 character";
          isValid = false;
        }
        if(cityVillageController.text.trim().isEmpty && cityVillageController.text.trim().length<3){
          cityVillageErrorText = "Please enter valid city or village";
          isValid = false;
        }
        if(isValid){
          nameErrorText = null;
          cityVillageErrorText = null;
        }
        break;
      }
      case 1:{
        if(studentContactController.text.trim().isEmpty && studentContactController.text.trim().length<10){
          studentContactError = "Please enter valid phone number";
          isValid = false;
        }
        if(PPImage==null){
          print("yvygbhnjklm,l");
          PPIMageError == "Please select passport image";
          isValid = false;
        }
        print("passportExpiryDate");
        print(passportExpiryDate);
        if(passportExpiryDate == null){
          isValid = false;
          //passport_expiry_date =  "Please add passport expiry date";
        }
        if (emailStudentController.text.trim().isEmpty) {
          isValid = false;
          studentemailError =  context.resources.strings.cantBeEmpty;
        }
        if (emailStudentController.text.trim().isEmpty) {
          isValid = false;
          studentemailError =  context.resources.strings.cantBeEmpty;
        }
        if (emailStudentController.text.trim().length < 4) {
          isValid = false;
          studentemailError =  context.resources.strings.tooShort;
        }
        if(!isEmail(emailStudentController.text)){
          isValid = false;
          studentemailError =  context.resources.strings.notValidEmail;
        }
        if (emailParentController.text.trim().isEmpty) {
          isValid = false;
          emailParentError =  context.resources.strings.cantBeEmpty;
        }
        if (emailParentController.text.length < 4) {
          isValid = false;
          emailParentError =  context.resources.strings.tooShort;
        }
        if(!isEmail(emailParentController.text)){
          isValid = false;
          emailParentError =  context.resources.strings.notValidEmail;
        }
        if(married==""){
          isValid = false;
        }
        if(isValid){
          studentContactError = null;
          studentemailError = null;
          emailParentError = null;
        }
        break;
      }
      case 2:{
        if(spouseNameController.text.trim().isEmpty && spouseNameController.text.length<3){
          isValid = false;
        }
        if(spouseOccupationController.text.trim().isEmpty ){
          isValid = false;
        }
        if(fatherNameController.text.trim().isEmpty && fatherNameController.text.length<3){
          isValid = false;
        }
        if(fatherOccupationController.text.trim().isEmpty ){
          isValid = false;
        }
        if(motherNameController.text.trim().isEmpty && motherNameController.text.length<3){
          isValid = false;
        }
        if(motherOccupationController.text.trim().isEmpty ){
          isValid = false;
        }
        if(parentContactController.text.trim().isEmpty && parentContactController.text.trim().length<10){
          isValid = false;
        }
        if(netFamilyIncomeController.text.trim().isEmpty && netFamilyIncomeController.text.trim().length<5){
          isValid = false;
        }

        break;
      }
      case 3:{
        if(tenToDate.isBefore(tenFromDate)){
          isValid = false;
        }
        if(tenthStreamController.text.trim().isEmpty ){
          isValid = false;
        }
        if(tenthBoardController.text.trim().isEmpty ){
          isValid = false;
        }
        if(tenthPercentagemarksController.text.trim().isEmpty ){
          isValid = false;
        }
        if(twelveToDate.isBefore(twelveFromDate)){
          isValid = false;
        }
        if(twelveStreamController.text.trim().isEmpty ){
          isValid = false;
        }
        if(twelveBoardController.text.trim().isEmpty ){
          isValid = false;
        }
        if(twelvePercentagemarksController.text.trim().isEmpty ){
          isValid = false;
        }
        if(tenMarkSheetImage==null){
          tenMSError == "Please select 10th Marksheet";
          isValid = false;
        }
        if(twelveMarkSheetImage==null){
          tweleveMSError == "Please select 12th Marksheet";
          isValid = false;
        }
        break;
      }

      case 4:{
        if(travelHistoryController.text.trim().isEmpty ){
          isValid = false;
        }
        if(countryController.text.trim().isEmpty ){
          isValid = false;
        }
        if(criminalHistory == ""){
          isValid = false;
        }
        if(anyRefusal == ""){
          isValid = false;
        }
        break;
      }
      case 5:{
        if(ieltsLController.text.trim().isEmpty){
          isValid = false;
        }
        if(ieltsSController.text.trim().isEmpty){
          isValid = false;
        }
        if(ieltsRController.text.trim().isEmpty){
          isValid = false;
        }
        if(ieltsWController.text.trim().isEmpty){
          isValid = false;
        }
        if(ieltsOAController.text.trim().isEmpty ){
          isValid = false;
        }
        if(ieltsIDBBCController.text.trim().isEmpty ){
          isValid = false;
        }
        if(anyProvinceController.text.trim().isEmpty ){
          isValid = false;
        }
        if(anyCollegeController.text.trim().isEmpty ){
          isValid = false;
        }
        if(advisorController.text.trim().isEmpty ){
          isValid = false;
        }
        if(remarkController.text.trim().isEmpty ){
          isValid = false;
        }
        break;
      }
    }
    return isValid;
  }

  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  savepdf(pw.Document pdf) async {
    var ppp = await pdf.save();

    /*https://stackoverflow.com/questions/61373742/flutter-web-display-pdf-file-generated-in-application-uint8list-format*/
   /* var directory = await getApplicationDocumentsDirectory();
    String name = "StudentForm${DateTime.now().millisecondsSinceEpoch.toString()}.pdf";
    final File file = File('${directory.path}/'+name);
    await file.writeAsBytes(await pdf.save());*/
    mainModel?.showhideprogress(false, context);
    notifyListeners();
    mainModel!.showTopSuccessMessage(context, "Student Form Pdf Created");
    if(Responsive.isMobile(context)){
    myNavigator.pushNamed(context, Routes.pdfPreview, arguments: ppp);
    }
    else{
      showDialog(
          context: context,
          builder: (BuildContext context){
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0)),
                child: Container(constraints: BoxConstraints(minWidth: 300, maxWidth: 450),child:PdfPreviewPage(ppp)));
          }
      );
    }

  }

  createPdf(bool withEmployeComment) async {
    mainModel?.showhideprogress(true, context);
    notifyListeners();
    final imageLogo1 = pw.MemoryImage((await rootBundle.load('assets/images/heritage_logo1.jpeg')).buffer.asUint8List());
    final imageLogo2 = pw.MemoryImage((await rootBundle.load('assets/images/heritage_logo_2.jpeg')).buffer.asUint8List());
    pdfFont = await PdfGoogleFonts.nunitoExtraLight();
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                getPdfHeader(imageLogo2),
                pw.SizedBox(height: 20),
                pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black),
                    children: [
                      getTableRow(this.context.resources.strings.date,DateFormat(this.context.resources.strings.DDMMYYYY).format(DateTime.fromMillisecondsSinceEpoch(studentData[FirestoreConstants.student_form_date])).toString()),
                      getTableRow(this.context.resources.strings.enterName,studentData[FirestoreConstants.student_form_name]),
                      getTableRow(this.context.resources.strings.refferedby,studentData[FirestoreConstants.student_form_reffered_by]),
                      getTableRow(this.context.resources.strings.dateOfBirth,DateFormat(this.context.resources.strings.DDMMYYYY).format(DateTime.fromMillisecondsSinceEpoch(studentData[FirestoreConstants.student_form_DOB])).toString()),
                      getTableRow(this.context.resources.strings.cityVillage,studentData[FirestoreConstants.student_form_city_village]),
                      getTableRow(this.context.resources.strings.customerComment,checkAndGetValue(studentData, FirestoreConstants.form_1_customer_comment,defaultValue: "")),
                      if(withEmployeComment)
                        getTableRow(this.context.resources.strings.employeeComment,checkAndGetValue(studentData, FirestoreConstants.form_1_employee_comment,defaultValue: "")),

                      getTableRow(this.context.resources.strings.enterStudentContactNo,studentData[FirestoreConstants.student_form_contact].toString()),
                      getTableRow(this.context.resources.strings.enterEmail,studentData[FirestoreConstants.student_form_email].toString()),
                      getTableRow(this.context.resources.strings.enterParentemail,studentData[FirestoreConstants.student_form_parent_email].toString()),
                      getTableRow(this.context.resources.strings.numberOfChildren,studentData[FirestoreConstants.student_form_number_of_children].toString()),
                      getTableRow(this.context.resources.strings.married,studentData[FirestoreConstants.student_form_married].toString()),
                      getTableRow(this.context.resources.strings.customerComment,studentData[FirestoreConstants.form_2_customer_comment].toString()),
                      if(withEmployeComment)
                        getTableRow(this.context.resources.strings.employeeComment,checkAndGetValue(studentData, FirestoreConstants.form_2_employee_comment,defaultValue: "")),
                    ]
                )
              ],
            );
          }
      ),
    );
    pdf.addPage(
      pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                getPdfHeader(imageLogo2),
                pw.SizedBox(height: 20),
                pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black),
                    children: [
                      getTableRow(this.context.resources.strings.spousesName,studentData[FirestoreConstants.student_spouse_name].toString()),
                      getTableRow(this.context.resources.strings.spousesOccupation,studentData[FirestoreConstants.student_spouse_occupation].toString()),
                      getTableRow(this.context.resources.strings.fathersName,studentData[FirestoreConstants.student_father_name].toString()),
                      getTableRow(this.context.resources.strings.fathersOccupation,studentData[FirestoreConstants.student_father_occupation].toString()),
                      getTableRow(this.context.resources.strings.mothersName,studentData[FirestoreConstants.student_mother_name].toString()),
                      getTableRow(this.context.resources.strings.mothersOccupation,studentData[FirestoreConstants.student_mother_occupation].toString()),
                      getTableRow("Parent’s Contact No.",studentData[FirestoreConstants.student_parent_contact].toString()),
                      getTableRow(this.context.resources.strings.netFamilyIncomeAnnually,studentData[FirestoreConstants.student_family_net_income].toString()),
                      getTableRow(this.context.resources.strings.customerComment,studentData[FirestoreConstants.form_3_customer_comment].toString()),
                      if(withEmployeComment)
                        getTableRow(this.context.resources.strings.employeeComment,checkAndGetValue(studentData, FirestoreConstants.form_3_employee_comment,defaultValue: "")),
                    ]
                )
              ],
            );
          }
      ),
    );
    pdf.addPage(
      pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                getPdfHeader(imageLogo2),
                pw.SizedBox(height: 20),
                pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black),
                    children: [
                      getSingleTableRow(this.context.resources.strings.educationalInformation),
                      getSingleTableRow(this.context.resources.strings.tenth),
                      getTableRow(this.context.resources.strings.fromMMYYYY,DateFormat(this.context.resources.strings.monthyearDateFormat).format(DateTime.fromMillisecondsSinceEpoch(studentData[FirestoreConstants.student_tenth_from_date])).toString()),
                      getTableRow(this.context.resources.strings.toMMYYYY,DateFormat(this.context.resources.strings.monthyearDateFormat).format(DateTime.fromMillisecondsSinceEpoch(studentData[FirestoreConstants.student_tenth_to_date])).toString()),
                      getTableRow(this.context.resources.strings.stream,studentData[FirestoreConstants.student_tenth_stream].toString()),
                      getTableRow(this.context.resources.strings.boardUniversityCollege,studentData[FirestoreConstants.student_tenth_board].toString()),
                      getTableRow(this.context.resources.strings.percentage,studentData[FirestoreConstants.student_tenth_marks_percentage].toString()),
                      getTableRow(this.context.resources.strings.noofBacklogsifany,studentData[FirestoreConstants.student_tenth_backlog].toString()),
                      getSingleTableRow(this.context.resources.strings.twelveth),
                      getTableRow(this.context.resources.strings.fromMMYYYY,DateFormat(this.context.resources.strings.monthyearDateFormat).format(DateTime.fromMillisecondsSinceEpoch(studentData[FirestoreConstants.student_twelve_from_date])).toString()),
                      getTableRow(this.context.resources.strings.toMMYYYY,DateFormat(this.context.resources.strings.monthyearDateFormat).format(DateTime.fromMillisecondsSinceEpoch(studentData[FirestoreConstants.student_twelve_to_date])).toString()),
                      getTableRow(this.context.resources.strings.stream,studentData[FirestoreConstants.student_twelve_stream].toString()),
                      getTableRow(this.context.resources.strings.boardUniversityCollege,studentData[FirestoreConstants.student_twelve_board].toString()),
                      getTableRow(this.context.resources.strings.percentage,studentData[FirestoreConstants.student_twelve_marks_percentage].toString()),
                      getTableRow(this.context.resources.strings.customerComment,studentData[FirestoreConstants.form_4_customer_comment].toString()),
                      if(withEmployeComment)
                        getTableRow(this.context.resources.strings.employeeComment,checkAndGetValue(studentData, FirestoreConstants.form_4_employee_comment,defaultValue: "")),
                    ]
                )
              ],
            );


          }
      ),
    );

    pdf.addPage(
      pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                getPdfHeader(imageLogo2),
                pw.SizedBox(height: 20),
                pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black),
                    children: [
                      getSingleTableRow(this.context.resources.strings.assessmentInformation),
                      getTableRow(this.context.resources.strings.criminalHistory,studentData[FirestoreConstants.student_criminal_history].toString()),
                      getTableRow(this.context.resources.strings.travelHistory,studentData[FirestoreConstants.student_travel_history].toString()),
                      getTableRow(this.context.resources.strings.CountryIfapplicable,studentData[FirestoreConstants.student_country].toString()),
                      getTableRow(this.context.resources.strings.anyRefusals,studentData[FirestoreConstants.student_any_refusal].toString()),
                      getTableRow(this.context.resources.strings.customerComment,studentData[FirestoreConstants.form_5_customer_comment].toString()),
                      if(withEmployeComment)
                        getTableRow(this.context.resources.strings.employeeComment,checkAndGetValue(studentData, FirestoreConstants.form_5_employee_comment,defaultValue: "")),
                    ]
                )
              ],
            );
          }
      ),
    );

    pdf.addPage(
      pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                getPdfHeader(imageLogo2),
                pw.SizedBox(height: 20),
                pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black),
                    children: [
                      getSingleTableRow(this.context.resources.strings.IELTSGenAca),
                      getTableRow(this.context.resources.strings.year,DateFormat(this.context.resources.strings.yearFormat).format(DateTime.fromMillisecondsSinceEpoch(studentData[FirestoreConstants.student_ielts_year])).toString()),
                      getTableRow(this.context.resources.strings.L,studentData[FirestoreConstants.student_ielts_l].toString()),
                      getTableRow(this.context.resources.strings.R,studentData[FirestoreConstants.student_ielts_r].toString()),
                      getTableRow(this.context.resources.strings.W,studentData[FirestoreConstants.student_ielts_w].toString()),
                      getTableRow(this.context.resources.strings.S,studentData[FirestoreConstants.student_ielts_s].toString()),
                      getTableRow(this.context.resources.strings.OA,studentData[FirestoreConstants.student_ielts_OA].toString()),
                      getTableRow(this.context.resources.strings.IDPBC,studentData[FirestoreConstants.student_ielts_IDBBC].toString()),
                      getTableRow(this.context.resources.strings.anyProvincePreferenceInCanadaIfNoThenMentionNONE,studentData[FirestoreConstants.student_ielts_any_province].toString()),
                      getTableRow(this.context.resources.strings.nameOfAdvisor,studentData[FirestoreConstants.student_ielts_advisor].toString()),
                      getTableRow(this.context.resources.strings.remark,studentData[FirestoreConstants.student_ielts_remark].toString()),
                      getTableRow(this.context.resources.strings.customerComment,studentData[FirestoreConstants.form_6_customer_comment].toString()),
                      if(withEmployeComment)
                        getTableRow(this.context.resources.strings.employeeComment,checkAndGetValue(studentData, FirestoreConstants.form_6_employee_comment,defaultValue: "")),
                    ]
                )
              ],
            );
          }
      ),
    );

    savepdf(pdf);

  }

  getTableRow(String title,String value){
    return pw.TableRow(

        children: [

          pw.Expanded(
              flex: 1,
              child: getPaddedtext(title)
          ),
          pw.Expanded(
              flex: 2,
              child: getPaddedtext(value)
          ),
        ]
    );
  }

  getSingleTableRow(String title){
    return pw.TableRow(

        children: [

          pw.Expanded(
              child: getPaddedtext(title)
          ),
        ]
    );
  }

  getPaddedtext(final String text, {final pw.TextAlign align = pw.TextAlign.left,}) {
    return
        pw.Padding(
          padding: pw.EdgeInsets.all(10),
          child: pw.Text(
            text,
            style: pw.TextStyle(font: pdfFont),
            textAlign: align,
          ),
        );
  }

  pw.Row getPdfHeader(pw.MemoryImage imageLogo1){
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text("Student form",style: pw.TextStyle(font: pdfFont,fontSize: 24,color: PdfColor.fromHex("#7f3841"))),
        pw.SizedBox(
          height: 150,
          width: 150,
          child: pw.Image(imageLogo1),
        )
      ],
    );
  }

  Widget getFileWidget(Map<String , dynamic > fileData){
    if(fileData["type"]=="xfile"){
      return kIsWeb
          ? Image.network(fileData["data"].path)
          : Image.file(File(fileData["data"].path));
    }
    if(fileData["type"]=="filPicker"){
      return Center(child: Icon(Icons.picture_as_pdf,size: 30,),);
    }
    if(fileData["type"]=="document"){
      return Center(child: Icon(Icons.picture_as_pdf,size: 30,),);
    }
    if(fileData["type"]=="image"){
      return Image.network(fileData["data"].path);
    }
    return Container();
  }
}
