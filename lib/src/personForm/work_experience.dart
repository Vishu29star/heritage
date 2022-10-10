import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/FormWidgetTextField.dart';
import '../../constants/HeritagedatePicker.dart';
import '../../data/firestore_constants.dart';

class WorkExperience extends StatefulWidget {
  final PersonFormVM personFormVM;
  const WorkExperience(this.personFormVM ,{Key? key}) : super(key: key);

  @override
  State<WorkExperience> createState() => _WorkExperienceState();
}

class _WorkExperienceState extends State<WorkExperience> {
  @override
  Widget build(BuildContext context) {
    if(widget.personFormVM.studentData.containsKey(FirestoreConstants.immi_work_experience)){
      return ListView.builder(itemBuilder: (context,index){

        return WEItem(widget.personFormVM.educationDetailsArray[index]);
      });
    }else{
      return WEFromFeild(widget.personFormVM.educationDetailsArray);
    }
  }

  Widget WEFromFeild(List<Map<String, dynamic>> workExperienceList){
    return Scaffold(
      body: ListView.builder(
          itemCount:  workExperienceList.length+2,
          itemBuilder: (context,index){
            if(index == 0){
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        HeritagedatePicker(
                          onDateSelection: (dd){
                            widget.personFormVM.selectedWEFromDate = dd;
                          },
                          rowORColumn: 0,
                          result: widget.personFormVM.selectedWEFromDate,
                          dateFormat: context.resources.strings.monthyearDateFormat,
                          labelText: context.resources.strings.fromMMYYYY,
                        ),
                        HeritagedatePicker(
                          onDateSelection: (dd){
                            widget.personFormVM.selectedWEToDate = dd;
                          },
                          rowORColumn: 0,
                          result: widget.personFormVM.selectedWEToDate,
                          dateFormat: context.resources.strings.monthyearDateFormat,
                          labelText: context.resources.strings.toMMYYYY,
                        ),
                      ],
                    ),
                    Divider(),
                    HeritageTextFeild(
                      keyboardType: TextInputType.text,
                      controller: widget.personFormVM.selectedWorkTitle,
                      hintText: "Manager",
                      labelText: "Position",
                    ),
                    HeritageTextFeild(
                      keyboardType: TextInputType.text,
                      controller: widget.personFormVM.selectedCompany,
                      hintText: "Heritage, Google",
                      labelText: "Company Name",
                    ),
                    HeritageTextFeild(
                      keyboardType: TextInputType.text,
                      controller: widget.personFormVM.selectedIndustries,
                      hintText: "Immigration, IT",
                      labelText: "Industry Type",
                    ),
                    HeritageTextFeild(
                      keyboardType: TextInputType.text,
                      controller: widget.personFormVM.selectedWorkLocation,
                      hintText: "Chandigarh, Ludhiana",
                      labelText: "Work Location",
                    ),
                    addWorkExperienceToListButton(),
                  ],
                ),
              );
            }
            if(index == workExperienceList.length+1){
              if(workExperienceList.length>0){
                return button1();
              }else{
                return Container();
              }
            }

            Map<String, dynamic> workExperienceDetail = workExperienceList[index-1];
            return WEItem(workExperienceDetail);
          }),
    );
  }

  Widget WEItem(Map<String,dynamic> workExperienceDetail){
    return Column(
      children: [
        SizedBox(
          height: kIsWeb ? 16 : 12,
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Text("Position")),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 6,
                          child: Text(workExperienceDetail[FirestoreConstants.immi_work_title],textAlign: TextAlign.end,)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Text("Company Name")),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 6,
                          child: Text(workExperienceDetail[FirestoreConstants.immi_work_company_name],textAlign: TextAlign.end,)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Text("Industry Type")),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 6,
                          child: Text(workExperienceDetail[FirestoreConstants.immi_work_industry_type],textAlign: TextAlign.end,)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Text("Industry Location")),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 6,
                          child: Text(workExperienceDetail[FirestoreConstants.immi_work_industry_location],textAlign: TextAlign.end,)),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text("From"),
                              Text(DateFormat(context.resources.strings.monthyearDateFormat).format(DateTime.fromMicrosecondsSinceEpoch(workExperienceDetail[FirestoreConstants.immi_work_from_date]))),
                            ],
                          )),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text("To"),
                              Text(DateFormat(context.resources.strings.monthyearDateFormat).format(DateTime.fromMicrosecondsSinceEpoch(workExperienceDetail[FirestoreConstants.immi_work_to_date]))),

                            ],
                          )),
                    ],
                  ),
                ),

              ],
            ),
          ),

        ),
        SizedBox(
          height: 20,
        ),],
    );
  }
  Widget button1() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Button(
            isEnabled: true,
            onPressed: () async {
              widget.personFormVM.checkTheData(3);
            },
            labelText:context.resources.strings.update,
          )),
    );
  }

  Widget addWorkExperienceToListButton() {
    return SizedBox(
        height: 50,
        width: 200,
        child: Button(
          isEnabled: true,
          onPressed: () async {
            widget.personFormVM.addWorkExperienceInList();
          },
          labelText:context.resources.strings.add,
        ));
  }
}
