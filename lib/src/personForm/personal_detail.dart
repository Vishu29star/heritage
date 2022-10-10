import 'package:Heritage/constants/heritage_dropDown.dart';
import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/FormWidgetTextField.dart';
import '../../constants/HeritageYesNoWidget.dart';
import '../../constants/HeritagedatePicker.dart';
import '../../data/firestore_constants.dart';

class PersonalDetailWidget extends StatefulWidget {
  final PersonFormVM personFormVM;
  const PersonalDetailWidget(this.personFormVM ,{Key? key}) : super(key: key);

  @override
  State<PersonalDetailWidget> createState() => _PersonalDetailWidgetState();
}

class _PersonalDetailWidgetState extends State<PersonalDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),

      child: widget.personFormVM.studentData.containsKey(FirestoreConstants.immi_personal_detail) ? addedPersonalDetail(widget.personFormVM.studentData[FirestoreConstants.immi_personal_detail]) : personalFormFeild(),
    );
  }

  Widget addedPersonalDetail(Map<String,dynamic> personalDeatil){
    DateTime birthday = DateTime.fromMillisecondsSinceEpoch(personalDeatil[FirestoreConstants.immi_dob]);
    DateTime currentTime = DateTime.now();
    var diffrenceDays = currentTime.difference(birthday).inDays;
    var diffrenceYear = (diffrenceDays/365).round();
    return Column(
      children: [

        SizedBox(
          height: kIsWeb ? 16 : 12,
        ),
        Card(
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
                          child: Text("Principal applicant Name")),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 6,
                          child: Text(personalDeatil[FirestoreConstants.immi_name],textAlign: TextAlign.end,)),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text("Contact Number")),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 6,
                          child: Text(personalDeatil[FirestoreConstants.immi_contact],textAlign: TextAlign.end)),
                    ],
                  ),
                ),
                Divider(),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                          left: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                          bottom: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                          right: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 4,),
                                Text("AGE",style: TextStyle(color: context.resources.color.colorPrimary,fontWeight: FontWeight.w600,fontSize: 14),),
                                Divider(color: context.resources.color.colorPrimary,thickness: 1,),
                                Text(diffrenceYear.toString(),style: TextStyle(fontSize: 13),),
                                SizedBox(height: 4,),
                              ],
                            ),
                          ),
                          Container(width: 1,color: context.resources.color.colorPrimary,height: 60,),
                          // Divider(color: context.resources.color.colorPrimary,thickness: 10,height: 10,),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 4,),
                                Text("Best time to call",maxLines:1,overflow: TextOverflow.ellipsis,style: TextStyle(color: context.resources.color.colorPrimary,fontWeight: FontWeight.w600,fontSize: 14),),
                                Divider(color: context.resources.color.colorPrimary,thickness: 1,),
                                Text(personalDeatil[FirestoreConstants.immi_best_time_to_call],maxLines:1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13),),
                                SizedBox(height: 4,),
                              ],
                            ),
                          ),
                          Container(width: 1,color: context.resources.color.colorPrimary,height: 60,),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 4,),
                                Text("Married",style: TextStyle(color: context.resources.color.colorPrimary,fontWeight: FontWeight.w600,fontSize: 14),),
                                Divider(color: context.resources.color.colorPrimary,thickness: 1,),
                                Text(personalDeatil[FirestoreConstants.immi_married],style: TextStyle(fontSize: 13),),
                                SizedBox(height: 4,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

        ),
        SizedBox(
          height: 20,
        ),],
    );
  }

  Widget personalFormFeild(){
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeritageTextFeild(
                  errorText: widget.personFormVM.nameErrorText,
                  controller: widget.personFormVM.nameController,
                  hintText: context.resources.strings.hintName,
                  labelText: "Principal applicant Name",
                ),
                HeritageTextFeild(
                  errorText: widget.personFormVM.studentContactError,
                  controller: widget.personFormVM.studentContactController,
                  hintText: context.resources.strings.hintphoneNumber,
                  labelText: "Contact Number",
                  keyboardType: TextInputType.number,
                ),

                HeritageTextFeild(
                  errorText: widget.personFormVM.studentemailError,
                  controller: widget.personFormVM.emailStudentController,
                  hintText: context.resources.strings.emailHint,
                  labelText: context.resources.strings.enterEmail,
                  keyboardType: TextInputType.emailAddress,
                ),

                HeritageTextFeild(
                  controller: widget.personFormVM.refferdByController,
                  hintText: context.resources.strings.hintName,
                  labelText: context.resources.strings.refferedby,
                ),

                HeritageDropDown(selectedCallTime: widget.personFormVM.selectedCallTime, label: "Best time to call", dropdownItems: dropdownItems, onvalueSelection: (newValue){
                  widget.personFormVM.selectedCallTime = newValue;
                }),

                HeritagedatePicker(
                  isDOB:true,
                  onDateSelection: (dd){
                    widget.personFormVM.DOBDate = dd;
                  },
                  rowORColumn: 1,
                  result: widget.personFormVM.DOBDate,
                  dateFormat: context.resources.strings.DDMMYYYY,
                  labelText: context.resources.strings.dateOfBirth,
                ),
                Divider(),
                YesNoWidget(labelText: context.resources.strings.married, selected: widget.personFormVM.married,onSelection: (result){
                  widget.personFormVM.married = result;
                  setState(() {

                  });
                },),
                if(widget.personFormVM.married.toLowerCase() == "yes")...[
                  HeritagedatePicker(
                    onDateSelection: (dd){
                      widget.personFormVM.marriageDate = dd;
                    },
                    rowORColumn: 1,
                    result: widget.personFormVM.marriageDate,
                    dateFormat: context.resources.strings.DDMMYYYY,
                    labelText: "Date of marriage",
                  ),
                  Divider(),
                  HeritageTextFeild(
                    controller: widget.personFormVM.noOfChildren,
                    hintText: context.resources.strings.zero,
                    labelText: context.resources.strings.numberOfChildren,
                    keyboardType: TextInputType.number,
                    maxlenth: 1,
                  ),
                ],
                YesNoWidget(labelText: "Any previous marriage", selected: widget.personFormVM.previousMarriage,onSelection: (result){
                  widget.personFormVM.previousMarriage = result;
                  setState(() {

                  });
                },),
                if(widget.personFormVM.previousMarriage == "yes")...[
                  HeritageTextFeild(
                    controller: widget.personFormVM.TypeOfPreviousMarriageRelation,
                    hintText: "Bad",
                    labelText: "Type of relationship",
                  ),

                  HeritageTextFeild(
                    controller: widget.personFormVM.reasonOfPreviousMarriageEnding,
                    hintText: context.resources.strings.zero,
                    labelText: "Reason of Relationship ended",

                  ),
                  HeritageTextFeild(
                    controller: widget.personFormVM.noOfChildrenPreviousMarriage,
                    hintText: context.resources.strings.zero,
                    labelText: "No. of children from previous marriage",
                    keyboardType: TextInputType.number,
                    maxlenth: 1,
                  ),
                ]
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
  }

  Widget button1() {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child: Button(
          isEnabled: true,
          onPressed: () async {
            widget.personFormVM.checkTheData(1);
          },
          labelText:context.resources.strings.next,
        ));
  }
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("10:00 AM - 11:59 AM"),value: "10:00 AM - 11:59 AM"),
      DropdownMenuItem(child: Text("12:00 PM - 02:00 PM"),value: "12:00 PM - 02:00 PM"),
      DropdownMenuItem(child: Text("02:00 PM - 04:00 PM"),value: "02:00 PM - 04:00 PM"),
      DropdownMenuItem(child: Text("04:00 PM - 06:00 PM"),value: "04:00 PM - 06:00 PM"),
    ];
    return menuItems;
  }
}
