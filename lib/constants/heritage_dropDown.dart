import 'package:flutter/material.dart';

class HeritageDropDown extends StatefulWidget {
  final int rowORColumn;
  String label;
  String selectedCallTime;
  List<DropdownMenuItem<String>> dropdownItems;
  Function? onvalueSelection;

  HeritageDropDown({Key? key, this.rowORColumn = 1,required this.selectedCallTime,required this.label,required this.dropdownItems,required this.onvalueSelection}) : super(key: key);

  @override
  _HeritageDropDownState createState() => _HeritageDropDownState();
}

class _HeritageDropDownState extends State<HeritageDropDown> {
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
            Text(widget.label,style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700),),
            SizedBox(width: 20,),
            Expanded(
              child: DropdownButtonFormField(
                /*decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.blueAccent,
                        ),
                        dropdownColor: Colors.blueAccent,*/
                  value: widget.selectedCallTime,
                  onChanged: (String? newValue) {
                    widget.selectedCallTime = newValue!;
                    widget.onvalueSelection!(widget.selectedCallTime);
                    setState(() {
                    });
                  },
                  items: widget.dropdownItems
              ),
            ),
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
            Text(widget.label,style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700),),
            SizedBox(height: 8*multiply,),
            DropdownButtonFormField(
              /*decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.blueAccent,
                      ),
                      dropdownColor: Colors.blueAccent,*/
                value: widget.selectedCallTime,
                onChanged: (String? newValue) {
                  widget.selectedCallTime = newValue!;
                  widget.onvalueSelection!(widget.selectedCallTime);
                  setState(() {
                  });
                },
                items: widget.dropdownItems
            ),
          ],
        ),
      );
    }
  }


}

