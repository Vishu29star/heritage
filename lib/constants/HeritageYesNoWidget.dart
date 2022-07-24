import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class YesNoWidget extends StatefulWidget {
  String labelText;
  String selected;
  String value1;
  String value2;
  Function? onSelection;
  YesNoWidget({Key? key,required this.labelText, required this.selected,this.onSelection,this.value1 = "yes",this.value2 = "no"}) : super(key: key);

  @override
  _YesNoWidgetState createState() => _YesNoWidgetState();
}

class _YesNoWidgetState extends State<YesNoWidget> {
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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.labelText,style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700),),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    widget.selected = widget.value1;
                    widget.onSelection!(widget.selected);
                  });
                },
                child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft,
                      color: widget.selected==widget.value1?Theme.of(context).primaryColor:Colors.white
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(child: Text(widget.value1.toUpperCase(),style: TextStyle(color: widget.selected==widget.value1?Colors.white:Colors.black/*,fontSize: edittext_textsize*textmultiply*/,fontWeight: FontWeight.w700))),
                ),
              ),
              SizedBox(width: 20,),
              InkWell(
                onTap: (){
                  setState(() {
                    widget.selected = widget.value2;
                    widget.onSelection!(widget.selected);
                  });
                },
                child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft,
                      color: widget.selected==widget.value2?Theme.of(context).primaryColor:Colors.white
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(child: Text(widget.value2.toUpperCase(),style: TextStyle(color: widget.selected==widget.value2?Colors.white:Colors.black/*,fontSize: edittext_textsize*textmultiply*/,fontWeight: FontWeight.w700))),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
