import 'package:Heritage/constants/heritage_dropDown.dart';
import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/FormWidgetTextField.dart';
import '../../constants/HeritageYesNoWidget.dart';
import '../../constants/HeritagedatePicker.dart';
import '../../constants/uploadDocumentWidget.dart';
import '../../data/firestore_constants.dart';
import '../../utils/Utils.dart';

class EducationDetail extends StatefulWidget {
  final PersonFormVM personFormVM;
  const EducationDetail(this.personFormVM ,{Key? key}) : super(key: key);


  @override
  State<EducationDetail> createState() => _EducationDetailState();
}

class _EducationDetailState extends State<EducationDetail> {
  @override
  Widget build(BuildContext context) {
    if(widget.personFormVM.studentData.containsKey(FirestoreConstants.immi_education)){
      return ListView.builder(itemBuilder: (context,index){

        return educationItem(widget.personFormVM.educationDetailsArray[index]);
      });
    }else{
      return educationFromFeild(widget.personFormVM.educationDetailsArray);
    }
  }


  Widget educationFromFeild(List<Map<String, dynamic>> educationList){
    return Scaffold(
      body: ListView.builder(
        itemCount:  educationList.length+2,
        itemBuilder: (context,index){
          if(index == 0){
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  HeritageDropDown(selectedCallTime: widget.personFormVM.selectedEducationLevel, label: "Education Level", dropdownItems: dropdownItems, onvalueSelection: (newValue){
                    widget.personFormVM.selectedEducationLevel = newValue;
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      HeritagedatePicker(
                        onDateSelection: (dd){
                          widget.personFormVM.selectedFromDate = dd;
                        },
                        rowORColumn: 0,
                        result: widget.personFormVM.selectedFromDate,
                        dateFormat: context.resources.strings.monthyearDateFormat,
                        labelText: context.resources.strings.fromMMYYYY,
                      ),
                      HeritagedatePicker(
                        onDateSelection: (dd){
                          widget.personFormVM.selectedToDate = dd;
                        },
                        rowORColumn: 0,
                        result: widget.personFormVM.selectedToDate,
                        dateFormat: context.resources.strings.monthyearDateFormat,
                        labelText: context.resources.strings.toMMYYYY,
                      ),
                    ],
                  ),
                  Divider(),
                  YesNoWidget(labelText: context.resources.strings.regularCorrespondance, selected: widget.personFormVM.regularCorrespondance,value1: 'Regular',value2: "Correspondance",onSelection: (result){
                    widget.personFormVM.regularCorrespondance = result;
                    setState(() {

                    });
                  },),

                  Row(
                    children: [
                      Expanded(
                          child: HeritageTextFeild(
                            keyboardType: TextInputType.text,
                            controller: widget.personFormVM.selectedStream,
                            hintText: context.resources.strings.scienceHistory,
                            labelText: context.resources.strings.stream,
                          )),
                      verticleDivider,
                      Expanded(
                          child: HeritageTextFeild(
                            keyboardType: TextInputType.text,
                            controller: widget.personFormVM.selectedUniversity,
                            hintText: context.resources.strings.CBSE,
                            labelText: context.resources.strings.boardUniversityCollege,
                          )),
                    ],
                  ),
                  YesNoWidget(labelText: context.resources.strings.credentialAwarded, selected: widget.personFormVM.credentialAwarded,onSelection: (result){
                    widget.personFormVM.credentialAwarded = result;
                    setState(() {

                    });
                  },),
                  SizedBox(
                    height: 16,
                  ),
                  YesNoWidget(labelText: context.resources.strings.markSheetAvailable, selected: widget.personFormVM.markSheetAvailable,onSelection: (result){
                    widget.personFormVM.markSheetAvailable = result;
                    setState(() {

                    });
                  },),
                  widget.personFormVM.markSheetAvailable.toLowerCase() == "yes" ?  HeritageDoumentUpload(imageError: widget.personFormVM.MSError,image: widget.personFormVM.markSheetImage,labelText: "10th MarkSheet",onImageSelection: (image){
                    widget.personFormVM.markSheetImage = image;
                  },) : Container(),

                  SizedBox(
                    height: 16,
                  ),
                  addEducationToListButton(),
                ],
              ),
            );
          }
          if(index == educationList.length+1){
            if(educationList.length>0){
              return button1();
            }else{
              return Container();
            }
          }

          Map<String, dynamic> educationDetail = educationList[index-1];
          return educationItem(educationDetail);
        }),
    );
  }

  Widget educationItem(Map<String,dynamic> educationDetail){
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
                          child: Text("Education level")),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 6,
                          child: Text(educationDetail[FirestoreConstants.immi_education_level],textAlign: TextAlign.end,)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Text("Stream")),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 6,
                          child: Text(educationDetail[FirestoreConstants.immi_education_stream],textAlign: TextAlign.end,)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Text("University")),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 6,
                          child: Text(educationDetail[FirestoreConstants.immi_education_university],textAlign: TextAlign.end,)),
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
                              Text(DateFormat(context.resources.strings.monthyearDateFormat).format(DateTime.fromMicrosecondsSinceEpoch(educationDetail[FirestoreConstants.immi_education_from_date]))),
                            ],
                          )),
                      SizedBox(width: 12,),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text("To"),
                              Text(DateFormat(context.resources.strings.monthyearDateFormat).format(DateTime.fromMicrosecondsSinceEpoch(educationDetail[FirestoreConstants.immi_education_to_date]))),

                            ],
                          )),
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
                                Text("Credential\nAwareded",style: TextStyle(color: context.resources.color.colorPrimary,fontWeight: FontWeight.w600,fontSize: 12),),
                                Divider(color: context.resources.color.colorPrimary,thickness: 1,),
                                Text(educationDetail[FirestoreConstants.immi_education_credential_awarded],style: TextStyle(fontSize: 11),),
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
                                Text("Marksheet\nAvailable",maxLines:2,overflow: TextOverflow.ellipsis,style: TextStyle(color: context.resources.color.colorPrimary,fontWeight: FontWeight.w600,fontSize: 12),),
                                Divider(color: context.resources.color.colorPrimary,thickness: 1,),
                                Text(educationDetail[FirestoreConstants.immi_education_marksheet_available],maxLines:1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11),),
                                SizedBox(height: 4,),
                              ],
                            ),
                          ),
                          Container(width: 1,color: context.resources.color.colorPrimary,height: 60,),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 4,),
                                Text("Regular\nCorrespondace",style: TextStyle(color: context.resources.color.colorPrimary,fontWeight: FontWeight.w600,fontSize: 12),),
                                Divider(color: context.resources.color.colorPrimary,thickness: 1,),
                                Text(educationDetail[FirestoreConstants.immi_education_regular_correspondance],style: TextStyle(fontSize: 11),),
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
  Widget button1() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Button(
            isEnabled: true,
            onPressed: () async {
              widget.personFormVM.checkTheData(2);
            },
            labelText:context.resources.strings.update,
          )),
    );
  }

  Widget addEducationToListButton() {
    return SizedBox(
        height: 50,
        width: 200,
        child: Button(
          isEnabled: true,
          onPressed: () async {
            widget.personFormVM.addEducationInList();
          },
          labelText:context.resources.strings.add,
        ));
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    print("widget.personFormVM.listEducationLevel");
    print(widget.personFormVM.listEducationLevel.length);

    return widget.personFormVM.listEducationLevel.map((e) => DropdownMenuItem(child: Text(e),value: e)).toList();
  }
}
