import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../constants/FormWidgetTextField.dart';
import '../../constants/HeritageYesNoWidget.dart';
import '../../constants/HeritagedatePicker.dart';
import '../../utils/Utils.dart';
import '../mainViewModel.dart';
import 'CISFormService.dart';

class CISFormVM extends ChangeNotifier {
  CISFormVM(this.cisFormService, this.mainModel);

  final MainViewMoel? mainModel;
  final CISFormService? cisFormService;

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
  TextEditingController ageController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherOccupationController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController motherOccupationController = TextEditingController();
  TextEditingController netFamilyIncomeController = TextEditingController();
  TextEditingController studentContactController = TextEditingController();
  TextEditingController parentContactController = TextEditingController();
  late DateTime tenFromDate= DateTime.now();
  late DateTime marriageDate= DateTime.now();
  late DateTime tenToDate= DateTime.now();
  late DateTime twelveFromDate= DateTime.now();
  late DateTime twelveToDate= DateTime.now();
  late DateTime ieltsYear= DateTime.now();
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
  String marriedStatus= "";
  String previousMarriage= "";
  String anyRefusal= "";
  String criminalHistory= "";

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

  List<TextEditingController> highestEducationNameList = [];
  List<TextEditingController> higehstEducationInsituteList = [];
  List<TextEditingController> higehstEducationDurationList = [];
  List<TextEditingController> higehstEducationLevelList = [];
  List<String> highestEducationIsCompletedList = [];
  List<String> highestEducationIsRegularList = [];
  List<Widget> highestEducationWidgetList = [];
  ScrollController highesteducationScrollerController = ScrollController();
  ItemScrollController itemScrollController = ItemScrollController();
  int highestcount = 0;

  String wesDone = "";
  String officialTranscript = "";
  String joboffer = "";
  String empSupportinApplication = "";
  String resume = "";


  int pagePostion = 0;
  PageController pageController = PageController(initialPage: 0,keepPage: true,viewportFraction: 1);

  var form1Widget;
  var form2Widget;
  var form3Widget;
  var form4Widget;
  var form5Widget;
  var form6Widget;
  List<Widget> formWidgets =[];



 List<Widget> getFormWidget(BuildContext context){
   print("highestEducationWidgetList");
   print(highestEducationWidgetList.length);
   this.context = context;
    form1Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeritagedatePicker(rowORColumn: 1,
                  result:date,
                  dateFormat: 'yyyy-MM-dd',
                  labelText: "Date",),
                Divider(),
                HeritageTextFeild(controller:nameController,
                  hintText: "vishal",
                  labelText: "Name of Prospect",),
                HeritageTextFeild(controller:studentContactController,
                  hintText: "987634543",
                  labelText: "Enter Student Contact No.",),
                HeritageTextFeild(controller:emailStudentController,
                  hintText: "vishal@gmail.com",
                  labelText: "Enter Student Email",),
                HeritageTextFeild(controller:refferdByController,
                  hintText: "chetan",
                  labelText: "Reffered By",),
                HeritagedatePicker(rowORColumn: 1,
                  result:DOBDate,
                  dateFormat: 'yyyy-MM-dd',
                  labelText: "DOB",),
                Divider(),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        button(),
      ],
    );
    form2Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                YesNoWidget(labelText: "Married Status", selected:marriedStatus,value1: "single",value2:  "marrried",),
                HeritageTextFeild(controller:noOfChildren, hintText: "0", labelText: "No. of children (If any)",),
                HeritageTextFeild(controller:ageController, hintText: "30", labelText: "Age",),
                YesNoWidget(labelText: "Any Previous Marriage", selected:previousMarriage),
                HeritagedatePicker(rowORColumn: 1,
                  result:marriageDate,
                  dateFormat: 'yyyy-MM-dd',
                  labelText: "Date of Marriage ",),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        button(),
      ],
    );
   if(highestcount==0){
     print("lkojihgfxdcgvhugyvcv bn");
     highestcount = 1;
     getHighesteducationList();
   }

   form3Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //HeritagedatePicker(rowORColumn: 1, result:DOBdate,dateFormat: 'yyyy-MM-dd',labelText: "DOB",),
                //Divider(),
                Text("Educational Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                SizedBox(height: 16,),
                Text("10th",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Expanded(child: HeritagedatePicker(rowORColumn: 2,
                      result:tenFromDate,
                      dateFormat: 'MM/YYYY',
                      labelText: "From(MM/YYYY)",),),
                    verticleDivider,
                    Expanded(child: HeritagedatePicker(rowORColumn: 2,
                      result:tenToDate,
                      dateFormat: 'MM/YYYY',
                      labelText: "To(MM/YYYY)",),),
                  ],
                ),
                SizedBox(height: 16,),
                Text("12th",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Expanded(child: HeritagedatePicker(rowORColumn: 2,
                      result:twelveFromDate,
                      dateFormat: 'MM/YYYY',
                      labelText: "From(MM/YYYY)",),),
                    verticleDivider,
                    Expanded(child: HeritagedatePicker(rowORColumn: 2,
                      result:twelveToDate,
                      dateFormat: 'MM/YYYY',
                      labelText: "To(MM/YYYY)",),),
                  ],
                ),
                SizedBox(height: 16,),
                Text("Highest level to Class 12 th ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                SizedBox(height: 8,),
                Container(
                  height: 400,
                  child: ListView(
                    controller:highesteducationScrollerController,
                    children:highestEducationWidgetList,
                    shrinkWrap: true,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeumorphicButton(
                      onPressed: (){
                        getHighesteducationList();
                        print("highestEducationWidgetList.length");
                        print(highestEducationWidgetList.length);
                       notifyListeners();
                       Future.delayed(Duration(seconds: 1),(){
                         itemScrollController.scrollTo(
                             index: highestEducationWidgetList.length-1,
                             duration: Duration(seconds: 1),
                             curve: Curves.easeInOutCubic);
                         notifyListeners();
                       });
                      },
                      child: Container(
                          width: 200,
                          child: Center(child: Text("Add Education",style: TextStyle(color: Colors.white,fontSize: 16),))
                      ),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                        depth: 100,
                        lightSource: LightSource.topLeft,
                        color: Theme.of(context).primaryColor,

                      ),

                    ),
                  ],
                )

              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        button(),
      ],
    );
    form4Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //HeritagedatePicker(rowORColumn: 1, result:DOBdate,dateFormat: 'yyyy-MM-dd',labelText: "DOB",),
                //Divider(),

                YesNoWidget(labelText: "WES Done", selected:wesDone),
                Divider(height: 12,),
                YesNoWidget(labelText: "Official Transcript", selected:officialTranscript),
                Divider(height: 12,),
                YesNoWidget(labelText: "Job Offer Available", selected:joboffer),
                Divider(height: 12,),
                YesNoWidget(labelText: "Emp supporting Application", selected:empSupportinApplication),
                Divider(height: 12,),
                YesNoWidget(labelText: "Resume", selected:resume),
                Divider(height: 12,),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        button(),
      ],
    );
    form5Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //HeritagedatePicker(rowORColumn: 1, result:DOBdate,dateFormat: 'yyyy-MM-dd',labelText: "DOB",),
                //Divider(),
                Text("Assessment Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                SizedBox(height: 16,),
                YesNoWidget(labelText: "Criminal History",
                    selected:criminalHistory),
                HeritageTextFeild(controller:travelHistoryController,
                  hintText: "Dubai",
                  labelText: "Travel History (mention   country name only)",),
                HeritageTextFeild(controller:countryController,
                  hintText: "Canada",
                  labelText: "Country (If applicable)",),
                YesNoWidget(
                    labelText: "Any Refusal(s)", selected:anyRefusal),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        button(),
      ],
    );
    form6Widget = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //HeritagedatePicker(rowORColumn: 1, result:DOBdate,dateFormat: 'yyyy-MM-dd',labelText: "DOB",),
                //Divider(),
                Text("IELTS (Gen/ Aca)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                SizedBox(height: 16,),
                HeritagedatePicker(rowORColumn: 1,
                  result:ieltsYear,
                  dateFormat: 'YYYY',
                  labelText: "Year",),
                Row(
                  children: [
                    Expanded(child: HeritageTextFeild(
                      controller:ieltsLController,
                      hintText: "6",
                      labelText: "L",)),
                    verticleDivider,
                    Expanded(child: HeritageTextFeild(
                      controller:ieltsRController,
                      hintText: "7",
                      labelText: "R",)),
                    verticleDivider,
                    Expanded(child: HeritageTextFeild(
                      controller:ieltsWController,
                      hintText: "8",
                      labelText: "W",)),
                    verticleDivider,
                    Expanded(child: HeritageTextFeild(
                      controller:ieltsSController,
                      hintText: "6",
                      labelText: "S",)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: HeritageTextFeild(
                      controller:travelHistoryController,
                      hintText: "7",
                      labelText: "O.A.",)),
                    verticleDivider,
                    Expanded(child: HeritageTextFeild(
                      controller:countryController,
                      hintText: "O.A.",
                      labelText: "IDP / BC",)),
                  ],
                ),
                HeritageTextFeild(controller:travelHistoryController,
                  hintText: "Toronto",
                  labelText: "Any Province preference (In Canada), if no then mention NONE",),
                HeritageTextFeild(controller:countryController,
                  hintText: "Canadian University",
                  labelText: "Any College/Program Preference, if no then mention NONE",),

              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        button(),
      ],
    );

    formWidgets.add(Container(child: form1Widget,));
    formWidgets.add(Container(child: form2Widget,));
    formWidgets.add(Container(child: form3Widget,));
    formWidgets.add(Container(child: form4Widget,));
    formWidgets.add(Container(child: form5Widget,));
    formWidgets.add(Container(child: form6Widget,));
    return formWidgets;
  }

  getHighesteducationList(){

    highestEducationNameList.add(TextEditingController());
    higehstEducationInsituteList.add(TextEditingController());
    higehstEducationLevelList.add(TextEditingController());
    higehstEducationDurationList.add(TextEditingController());
    highestEducationIsCompletedList.add("");
    highestEducationIsRegularList.add("");
    highestEducationWidgetList.add(Container(
      child: Column(
        children: [
          HeritageTextFeild(controller:highestEducationNameList.last, hintText: "Btech", labelText: "Name Of Education"),
          HeritageTextFeild(controller:higehstEducationInsituteList.last, hintText: "R.I.E.I.T", labelText: "Name Of Insitute"),
          Row(
            children: [
              Expanded(child: HeritageTextFeild(controller:higehstEducationDurationList.last, hintText: "4", labelText: "Duration"),),
              VerticalDivider(color: Colors.black,thickness: 2,width: 20,),
              Expanded(child: HeritageTextFeild(controller:higehstEducationLevelList.last, hintText: "Level", labelText: "Level of Education"),),
            ],
          ),
          YesNoWidget(labelText: "Regular\nCorrespondence", selected:highestEducationIsRegularList.last,value1: "Regular",value2:  "Correspondence",),
          SizedBox(height: 12,),
          YesNoWidget(labelText: "Study completed", selected:highestEducationIsCompletedList.last),

          SizedBox(height: 20,),
          Divider(),
        ],
      ),
    ));
    //notifyListeners();

  }

  Widget button(){
    return NeumorphicButton(
      onPressed: (){
        print("erftghyjk");
       pagePostion =pagePostion+1;
       pageController.animateToPage(
         pagePostion,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
       notifyListeners();
      },
      child: Container(

          child: Center(child: Text("Next",style: TextStyle(color: Colors.white,fontSize: 16),))
      ),
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        depth: 100,
        lightSource: LightSource.topLeft,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

}