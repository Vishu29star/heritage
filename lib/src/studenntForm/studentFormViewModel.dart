import 'package:Heritage/src/studenntForm/studentFormService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/FormWidgetTextField.dart';
import '../../constants/HeritageYesNoWidget.dart';
import '../../constants/HeritagedatePicker.dart';
import '../../utils/Utils.dart';
import '../mainViewModel.dart';

class StudentFormVM extends ChangeNotifier {
  StudentFormVM(this.studentFormService, this.mainModel);

  final MainViewMoel? mainModel;
  final StudentFormService? studentFormService;

  late BuildContext context;
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



  List<Widget> getWidgetList(BuildContext context){
    this.context = context;
    form1Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeritagedatePicker(
                  rowORColumn: 1,
                  result: date,
                  dateFormat: 'yyyy-MM-dd',
                  labelText: "Date",
                ),
                Divider(),
                HeritageTextFeild(
                  controller: nameController,
                  hintText: "vishal",
                  labelText: "Enter Name",
                ),
                HeritageTextFeild(
                  controller: refferdByController,
                  hintText: "chetan",
                  labelText: "Reffered By",
                ),
                HeritagedatePicker(
                  rowORColumn: 1,
                  result: DOBDate,
                  dateFormat: 'yyyy-MM-dd',
                  labelText: "DOB",
                ),
                Divider(),
                HeritageTextFeild(
                  controller: cityVillageController,
                  hintText: "Mohali",
                  labelText: "City/Village",
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
                  controller: studentContactController,
                  hintText: "987634543",
                  labelText: "Enter Student Contact No.",
                ),
                HeritageTextFeild(
                  controller: emailStudentController,
                  hintText: "vishal@gmail.com",
                  labelText: "Enter Student Email",
                ),
                HeritageTextFeild(
                  controller: emailParentController,
                  hintText: "chetan@gmail.com",
                  labelText: "Enter Parent's Email",
                ),
                HeritageTextFeild(
                  controller: noOfChildren,
                  hintText: "0",
                  labelText: "No. of children (If any)",
                ),
                YesNoWidget(labelText: "Married", selected: married),
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
                  controller: spouseNameController,
                  hintText: "Ram",
                  labelText: "Spouse’s Name",
                ),
                HeritageTextFeild(
                  controller: spouseOccupationController,
                  hintText: "Manager",
                  labelText: "Spouse’s Occupation",
                ),
                HeritageTextFeild(
                  controller: fatherNameController,
                  hintText: "Sham",
                  labelText: "Father’s Name",
                ),
                HeritageTextFeild(
                  controller: fatherOccupationController,
                  hintText: "Business man",
                  labelText: "Father’s Occupation",
                ),
                HeritageTextFeild(
                  controller: motherNameController,
                  hintText: "Radhe",
                  labelText: "Mother’s Name",
                ),
                HeritageTextFeild(
                  controller: motherOccupationController,
                  hintText: "HouseWife",
                  labelText: "Enter Parent's Email",
                ),
                HeritageTextFeild(
                  controller: parentContactController,
                  hintText: "234567",
                  labelText: "Parent’s Contact No.",
                ),
                HeritageTextFeild(
                  controller: netFamilyIncomeController,
                  hintText: "1230087",
                  labelText: "Net family income(annually)",
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
                  "Educational Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "10th",
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
                        dateFormat: 'MM/YYYY',
                        labelText: "From(MM/YYYY)",
                      ),
                    ),
                    verticleDivider,
                    Expanded(
                      child: HeritagedatePicker(
                        rowORColumn: 2,
                        result: tenToDate,
                        dateFormat: 'MM/YYYY',
                        labelText: "To(MM/YYYY)",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          controller: tenthStreamController,
                          hintText: "Science,History",
                          labelText: "Stream",
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: tenthBoardController,
                          hintText: "P.S.E.B",
                          labelText: "Board/University/College",
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          controller: tenthPercentagemarksController,
                          hintText: "67",
                          labelText: "Percentage",
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: tenthBacklogController,
                          hintText: "0",
                          labelText: "No. of Backlogs (if any)",
                        )),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "12th",
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
                        dateFormat: 'MM/YYYY',
                        labelText: "From(MM/YYYY)",
                      ),
                    ),
                    verticleDivider,
                    Expanded(
                      child: HeritagedatePicker(
                        rowORColumn: 2,
                        result: twelveToDate,
                        dateFormat: 'MM/YYYY',
                        labelText: "To(MM/YYYY)",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          controller: twelveStreamController,
                          hintText: "Science,History",
                          labelText: "Stream",
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: twelveBoardController,
                          hintText: "P.S.E.B",
                          labelText: "Board/University/College",
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          controller: twelvePercentagemarksController,
                          hintText: "67",
                          labelText: "Percentage",
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: twelveBacklogController,
                          hintText: "0",
                          labelText: "No. of Backlogs (if any)",
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
                  "Assessment Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                YesNoWidget(
                    labelText: "Criminal History",
                    selected: criminalHistory),
                HeritageTextFeild(
                  controller: travelHistoryController,
                  hintText: "Dubai",
                  labelText: "Travel History (mention   country name only)",
                ),
                HeritageTextFeild(
                  controller: countryController,
                  hintText: "Canada",
                  labelText: "Country (If applicable)",
                ),
                YesNoWidget(
                    labelText: "Any Refusal(s)", selected: anyRefusal),
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
                  "IELTS (Gen/ Aca)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                HeritagedatePicker(
                  rowORColumn: 1,
                  result: ieltsYear,
                  dateFormat: 'YYYY',
                  labelText: "Year",
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsLController,
                          hintText: "6",
                          labelText: "L",
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsRController,
                          hintText: "7",
                          labelText: "R",
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsWController,
                          hintText: "8",
                          labelText: "W",
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: ieltsSController,
                          hintText: "6",
                          labelText: "S",
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeritageTextFeild(
                          controller: travelHistoryController,
                          hintText: "7",
                          labelText: "O.A.",
                        )),
                    verticleDivider,
                    Expanded(
                        child: HeritageTextFeild(
                          controller: countryController,
                          hintText: "O.A.",
                          labelText: "IDP / BC",
                        )),
                  ],
                ),
                HeritageTextFeild(
                  controller: travelHistoryController,
                  hintText: "Toronto",
                  labelText:
                  "Any Province preference (In Canada), if no then mention NONE",
                ),
                HeritageTextFeild(
                  controller: countryController,
                  hintText: "Canadian University",
                  labelText:
                  "Any College/Program Preference, if no then mention NONE",
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
          onPressed: () {
            print("erftghyjk");
            pagePostion = pagePostion + 1;
            pageController.animateToPage(
              pagePostion,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
            );
           notifyListeners();
          },
          labelText: "Next",
        ));
  }
}