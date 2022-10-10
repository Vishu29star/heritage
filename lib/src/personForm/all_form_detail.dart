import 'package:Heritage/data/firestore_constants.dart';
import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/FormWidgetTextField.dart';

class AllFormDetailWidget extends StatefulWidget {
  final PersonFormVM personFormVM;
  const AllFormDetailWidget(this.personFormVM ,{Key? key}) : super(key: key);

  @override
  State<AllFormDetailWidget> createState() => _AllFormDetailWidgetState();
}

class _AllFormDetailWidgetState extends State<AllFormDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
             children: [
               widget.personFormVM.studentData.containsKey(FirestoreConstants.immi_personal_detail) ? addPersonalDetail(widget.personFormVM.studentData[FirestoreConstants.immi_personal_detail]) : Container(),
               Row(
                 children: [
                   Text(
                     "Education Detail",
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   TextButton(onPressed: (){ }, child: Text("more",style: TextStyle(fontWeight: FontWeight.w600),))
                 ],
               ),
               SizedBox(
                 height: 16,
               ),
               Card(
                 elevation: 4,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(15.0),
                 ),
                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: 12),
                   child: Column(
                     children: [
                       Container(
                         padding: EdgeInsets.symmetric(vertical: 12),
                         child: Row(
                           children: [
                             Expanded(
                                 flex: 3,
                                 child: Text("Principal applicant Name")),
                             SizedBox(width: 12,),
                             Expanded(
                                 flex: 6,
                                 child: Text("Ram verma")),
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
                                 child: Text("963676744")),
                           ],
                         ),
                       ),
                       Divider(),
                       Column(
                         children: [
                           Row(
                             children: [
                               Expanded(
                                 child: Column(
                                   children: [
                                     Container(
                                       decoration: BoxDecoration(
                                         border: Border(
                                           top: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                           left: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                           bottom: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                         ),
                                       ),
                                       child: Text("AGE",style: TextStyle(color: context.resources.color.colorPrimary,fontWeight: FontWeight.w600,fontSize: 14),),
                                     ),
                                     Container(
                                       decoration: BoxDecoration(
                                         border: Border(
                                           left: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                           bottom: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                         ),
                                       ),
                                       child: Text("28",style: TextStyle(fontSize: 13),),
                                     )
                                   ],
                                 ),
                               ),
                               Expanded(
                                 child: Column(
                                   children: [
                                     Container(
                                       decoration: BoxDecoration(
                                         border: Border(
                                           top: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                           left: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                           bottom: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                         ),
                                       ),
                                       child: Text("Best time to call",maxLines:2,overflow: TextOverflow.ellipsis,style: TextStyle(color: context.resources.color.colorPrimary,fontWeight: FontWeight.w600,fontSize: 14),),
                                     ),
                                     Container(
                                       decoration: BoxDecoration(
                                         border: Border(
                                           left: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                           bottom: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                         ),
                                       ),
                                       child: Text("02:00 Pm: 04:Pm",maxLines:2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13),),
                                     )
                                   ],
                                 ),
                               ),
                               Expanded(
                                 child: Column(
                                   children: [
                                     Container(
                                       decoration: BoxDecoration(
                                         border: Border(
                                           top: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                           left: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                           bottom: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                         ),
                                       ),
                                       child: Text("Married",style: TextStyle(color: context.resources.color.colorPrimary,fontWeight: FontWeight.w600,fontSize: 14),),
                                     ),
                                     Container(
                                       decoration: BoxDecoration(
                                         border: Border(
                                           left: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                           bottom: BorderSide(width: 1.0, color: context.resources.color.colorPrimary),
                                         ),
                                       ),
                                       child: Text("yes",style: TextStyle(fontSize: 13),),
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           )
                         ],
                       )
                     ],
                   ),
                 ),

               ),
             ],
          ),
        ),
      ),
    );
  }

  Widget addPersonalDetail(Map<String,dynamic> personalDeatil){
    DateTime birthday = DateTime.fromMillisecondsSinceEpoch(personalDeatil[FirestoreConstants.immi_dob]);
    DateTime currentTime = DateTime.now();
    var diffrenceDays = currentTime.difference(birthday).inDays;
    var diffrenceYear = (diffrenceDays/365).round();
    return Column(
      children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Personal Detail",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(onTap: (){
            widget.personFormVM.chnageTabPosition(1);
          },child: Text("more",style: TextStyle(fontWeight: FontWeight.w600),))
        ],
      ),
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
}
