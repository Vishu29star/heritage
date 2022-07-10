import 'package:Heritage/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

import '../utils/monthYearPicker/dialogs.dart';


class HeritagedatePicker extends StatefulWidget {
  final int rowORColumn;
  DateTime result;
  String dateFormat;
  String labelText;
  HeritagedatePicker({Key? key,required this.rowORColumn,required this.result,required this.dateFormat,required this.labelText}) : super(key: key);

  @override
  _HeritagedatePickerState createState() => _HeritagedatePickerState();
}

class _HeritagedatePickerState extends State<HeritagedatePicker> {
  double heading_textsize = 13;
  double edittext_textsize = 12;
  bool showLoading  = false;
  var multiply = 1.0;
  var textmultiply = 1.0;
  var width_multiply = 1.0;
  double width = 0;
  double height = 0;
  String whichPLatform = "";
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width < 600.0) {
      whichPLatform = "mobile";
      multiply = 1.0;
      textmultiply = 1.0;
      width_multiply = 1.0;
    }
    else if (width < 1000.0) {
      whichPLatform = "tablet";
      multiply = 1.3;
      textmultiply = 1.2;
      width_multiply = 0.9;
    }
    else {
      whichPLatform = "web";
      width_multiply = 0.6;
      multiply = 1.6;
      textmultiply = 1.4;
    }
    if(widget.rowORColumn==1){
      return Container(
        margin: EdgeInsets.symmetric(vertical:10*multiply),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.labelText,style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700),),
            InkWell(
              onTap: (){
                openDatePicker();
              },
              child: Neumorphic(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 8,
                    lightSource: LightSource.topLeft,
                    color: Colors.white
                ),
                padding: EdgeInsets.all(12),
                child: Center(child: Text(widget.result!=null?DateFormat(widget.dateFormat).format(widget.result):context.resources.strings.selectDate,style: TextStyle(color: Colors.black,fontSize: edittext_textsize*textmultiply))),
              ),
            )
          ],
        ),
      );
    }else{
      return Container(
        margin: EdgeInsets.symmetric(vertical:10*multiply),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start  ,
          children: [
            Text(widget.labelText,style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700),),
            SizedBox(height: 8*multiply,),
            InkWell(
              onTap: (){
                openDatePicker();
              },
              child: Neumorphic(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 8,
                    lightSource: LightSource.topLeft,
                    color: Colors.white
                ),
                padding: EdgeInsets.all(12),
                child: Center(child: Text(widget.result!=null?DateFormat(widget.dateFormat).format(widget.result):context.resources.strings.selectDate,style: TextStyle(color: Colors.black,fontSize: edittext_textsize*textmultiply))),
              ),
            )
          ],
        ),
      );
    }

  }

  Future<void> openDatePicker() async {
    if(widget.rowORColumn==2){
      widget.result = (await showMonthYearPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1960),
        lastDate: DateTime(2030),
      ))!;
    }else{
      widget.result = (await showDatePicker(

          context: context, //context of current state
          initialDate: DateTime.now(),
          firstDate: DateTime(1950), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2030)
      ))!;
    }
    setState(() {

    });
  }

}
