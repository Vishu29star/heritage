import 'package:Heritage/data/remote/apiModels/apiResponse.dart';
import 'package:Heritage/src/studenntForm/studentFormService.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../constants/FormWidgetTextField.dart';
import '../../constants/HeritageYesNoWidget.dart';
import '../../constants/HeritagedatePicker.dart';
import '../../data/firestore_constants.dart';
import '../../utils/Utils.dart';

import '../mainViewModel.dart';

class StudentFormVM extends ChangeNotifier {
  StudentFormVM(this.studentFormService, this.mainModel);

  final MainViewMoel? mainModel;
  final StudentFormService? studentFormService;

  late BuildContext context;
  late String formUserId;
  late String currentUID;
  late SharedPreferences preferences;

  bool isLoading =  true;
  dynamic errorText ;
  int firstInt = 0;
  var nameErrorText = null;
  var cityVillageErrorText = null;
  var studentContactError = null;
  var studentemailError = null;
  var emailParentError = null;
  DateTime date = DateTime.now();
  TextEditingController nameController = TextEditingController();
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
  late DateTime twelveFromDate = DateTime.now();
  late DateTime twelveToDate = DateTime.now();
  late DateTime ieltsYear = DateTime.now();
  TextEditingController tenthStreamController = TextEditingController();
  TextEditingController tenthPercentagemarksController =
  TextEditingController();
  TextEditingController tenthBacklogController = TextEditingController();
  TextEditingController tenthBoardController = TextEditingController();
  TextEditingController twelveStreamController = TextEditingController();
  TextEditingController twelvePercentagemarksController =
  TextEditingController();
  TextEditingController twelveBacklogController = TextEditingController();
  TextEditingController twelveBoardController = TextEditingController();
  TextEditingController travelHistoryController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController refusalReasonController = TextEditingController();
  String married = "";
  String anyRefusal = "";
  String criminalHistory = "";

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
  var studentData;



  Future<void> checkForStudentForm(BuildContext context,String uid) async {
    bool isnewData = false;
    this.context = context;
    formUserId= uid;
    print(formUserId);
    preferences = await SharedPreferences.getInstance();
    currentUID = await preferences.getString(FirestoreConstants.uid) ?? "currentUserId";
    print("vgbhnjkm");
    print(currentUID);
    isLoading = true;
    Future.delayed(Duration(microseconds: 100),(){
      mainModel?.showhideprogress(true, context);
      notifyListeners();
    });
    try{
      ApiResponse? result = await studentFormService?.checkForStudentForm(formUserId);
      if(result != null && result.status=="success"){
        studentCaseId = result.data.toString();
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
      else{
        var uuid = Uuid();
        var case_id = uuid.v1();
        Map<String,dynamic> data = {
          FirestoreConstants.case_id:case_id,
          FirestoreConstants.createdAt:FieldValue.serverTimestamp(),
          FirestoreConstants.updatedAt:FieldValue.serverTimestamp(),
          FirestoreConstants.logs:FieldValue.arrayUnion([{FirestoreConstants.time:DateTime.now().millisecondsSinceEpoch,FirestoreConstants.uid:currentUID}])
        };
        await studentFormService?.createUserStudentForm(data);
        studentCaseId = case_id;
        studentFormService?.updateUserWithStudentFormId(case_id,formUserId);
        isnewData = true;
      }
    }catch(e){
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
    if(data.containsKey(FirestoreConstants.student_form_number_of_children)){
      noOfChildren.text = data[FirestoreConstants.student_form_number_of_children];
    }
    if(data.containsKey(FirestoreConstants.student_form_married)){
      married = data[FirestoreConstants.student_form_married];
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
                HeritageTextFeild(
                  errorText: emailParentError,
                  controller: emailParentController,
                  hintText: context.resources.strings.enterParentemail,
                  labelText: context.resources.strings.emailHint,
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
                  labelText: context.resources.strings.spousesName,
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
                //HeritagedatePicker(rowORColumn: 1, result: DOBdate,dateFormat: 'yyyy-MM-dd',labelText: "DOB",),
                //Divider(),
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
                        rowORColumn: 2,
                        result: tenFromDate,
                        dateFormat: context.resources.strings.monthyearDateFormat,
                        labelText: context.resources.strings.fromMMYYYY,
                      ),
                    ),
                    verticleDivider,
                    Expanded(
                      child: HeritagedatePicker(
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
                          controller: tenthStreamController,
                          hintText: context.resources.strings.scienceHistory,
                          labelText: context.resources.strings.stream,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
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
                          controller: tenthPercentagemarksController,
                          hintText: context.resources.strings.percentageHint,
                          labelText: context.resources.strings.percentage,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: tenthBacklogController,
                          hintText: context.resources.strings.zero,
                          labelText: context.resources.strings.noofBacklogsifany,
                        )),
                  ],
                ),
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
                        rowORColumn: 2,
                        result: twelveFromDate,
                        dateFormat: context.resources.strings.monthyearDateFormat,
                        labelText: context.resources.strings.fromMMYYYY,
                      ),
                    ),
                    verticleDivider,
                    Expanded(
                      child: HeritagedatePicker(
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
                          controller: twelveStreamController,
                          hintText: context.resources.strings.scienceHistory,
                          labelText: context.resources.strings.stream,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
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
                          controller: twelvePercentagemarksController,
                          hintText: context.resources.strings.percentageHint,
                          labelText: context.resources.strings.percentage,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: twelveBacklogController,
                          hintText: context.resources.strings.zero,
                          labelText: context.resources.strings.noofBacklogsifany,
                        )),
                  ],
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
                    labelText:context.resources.strings.anyRefusals, selected: anyRefusal),
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
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsRController,
                          hintText: context.resources.strings.eight,
                          labelText: context.resources.strings.R,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsWController,
                          hintText: context.resources.strings.eight,
                          labelText: context.resources.strings.W,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsSController,
                          hintText: context.resources.strings.eight,
                          labelText: context.resources.strings.S,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          controller: travelHistoryController,
                          hintText: context.resources.strings.eight,
                          labelText:context.resources.strings.OA,
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: countryController,
                          hintText: context.resources.strings.OA,
                          labelText: context.resources.strings.IDPBC,
                        )),
                  ],
                ),
                HeritageTextFeild(
                  controller: travelHistoryController,
                  hintText: context.resources.strings.dubai,
                  labelText:
                  context.resources.strings.anyProvincePreferenceInCanadaIfNoThenMentionNONE,
                ),
                HeritageTextFeild(
                  controller: countryController,
                  hintText: context.resources.strings.canadianUniversity,
                  labelText:
                  context.resources.strings.anyCollegeProgramPreferenceIFNoThenMentionNONE,
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
      var result = await studentFormService!.updateStudentForm(getMapData(), studentCaseId);
      pagePostion = pagePostion + 1;
      print("pagePostion");
      print(pagePostion);
      pageController.animateToPage(
        pagePostion,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }catch(e){
      print(e);
    }
    //notifyListeners();
  }

  Map<String ,dynamic> getMapData(){
    Map<String ,dynamic> data = {};
    switch(pagePostion){
      case 0:{
        data.addAll(
            {FirestoreConstants.student_form_date:date.millisecondsSinceEpoch,
              FirestoreConstants.student_form_DOB:DOBDate.millisecondsSinceEpoch,
              FirestoreConstants.student_form_name:nameController.text,
              FirestoreConstants.student_form_reffered_by:refferdByController.text,
              FirestoreConstants.student_form_city_village:cityVillageController.text,
            }
        );
        break;
      }
      case 1:{
        print("DOmarriedBDate");
        print(married);
        data.addAll(
            {FirestoreConstants.student_form_contact:studentContactController.text,
              FirestoreConstants.student_form_email:emailStudentController.text,
              FirestoreConstants.student_form_parent_email:emailParentController.text,
              FirestoreConstants.student_form_number_of_children:noOfChildren.text,
              FirestoreConstants.student_form_married:married,
            }
        );

        break;
      }
      case 2:{
        print("DOmarriedBDate");
        print(married);
        data.addAll(
            {FirestoreConstants.student_spouse_name:spouseNameController.text,
              FirestoreConstants.student_spouse_occupation:spouseOccupationController.text,
              FirestoreConstants.student_father_name:fatherNameController.text,
              FirestoreConstants.student_father_occupation:fatherOccupationController.text,
              FirestoreConstants.student_mother_name:motherNameController.text,
              FirestoreConstants.student_mother_occupation:motherOccupationController.text,
              FirestoreConstants.student_parent_contact:parentContactController.text,
              FirestoreConstants.student_family_net_income:netFamilyIncomeController.text,
            }
        );

        break;
      }
    }
    return data;
  }

 bool isValidate(){
    bool isValid = true;
    switch(pagePostion){
      case 0:{
        if(nameController.text.isEmpty && nameController.text.length<3){
          nameErrorText = "Please enter atleast 3 character";
          isValid = false;
        }
        if(cityVillageController.text.isEmpty && cityVillageController.text.length<3){
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
        if(studentContactController.text.isEmpty && studentContactController.text.length<10){
          studentContactError = "Please enter valid phone number";
          isValid = false;
        }
        if (emailStudentController.text.isEmpty) {
          isValid = false;
          studentemailError =  context.resources.strings.cantBeEmpty;
        }
        if (emailStudentController.text.length < 4) {
          isValid = false;
          studentemailError =  context.resources.strings.tooShort;
        }
        if(!isEmail(emailStudentController.text)){
          isValid = false;
          studentemailError =  context.resources.strings.notValidEmail;
        }
        if (emailParentController.text.isEmpty) {
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
        if(isValid){
          studentContactError = null;
          studentemailError = null;
          emailParentError = null;
        }
        break;
      }
      case 2:{
        /*if(nameController.text.isEmpty && nameController.text.length<3){
          nameErrorText = "Please enter atleast 3 character";
          isValid = false;
        }
        if(cityVillageController.text.isEmpty && cityVillageController.text.length<3){
          cityVillageErrorText = "Please enter valid city or village";
          isValid = false;
        }
        if(isValid){
          nameErrorText = null;
          cityVillageErrorText = null;
        }*/
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
}