import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../global/global.dart';
import '../utils/extension.dart';
import '../utils/onHover.dart';
import '../utils/responsive/responsive.dart';


class HeritageTextFeild extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool? isObsecure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxlenth;
  final String? prefixText;
  final List<TextInputFormatter>? inputformator;
  final bool? isEnable;
  HeritageTextFeild({Key? key,this.hintText = "", required this.labelText,this.errorText = null, required this.controller, this.isObsecure = false, this.keyboardType = TextInputType.text,this.maxlenth = null,this.prefixText = "",this.inputformator = null,this.isEnable = true}) : super(key: key);

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

    if(Responsive.isDesktop(context)){
      return Container(
        margin: EdgeInsets.symmetric(vertical:10*multiply),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText!,style: TextStyle(
                color: errorText == null ? Theme.of(context).primaryColor : context.resources.color.colorPrimary,
                fontSize: 16,fontWeight: FontWeight.w500
            )),
            SizedBox(height: 10,),
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
                depth: -48,
                //intensity: 10,
                surfaceIntensity: 0.1,
                lightSource: LightSource.bottomRight,
                color: Colors.white,
                oppositeShadowLightSource: true,
              ),

              drawSurfaceAboveChild: false,
              padding: EdgeInsets.symmetric(horizontal: 8*multiply,vertical: 4*multiply  ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: isObsecure!,
                maxLength: maxlenth,
                inputFormatters: inputformator,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabled: isEnable!,
                  hintText: hintText != "" ? hintText : labelText,
                  hintStyle: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      fontSize: 16,fontWeight: FontWeight.w600
                  ),
                  prefixText: prefixText == "" ? null : prefixText,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(height: 10,),
            errorText != null
                ?Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(errorText!,style: TextStyle(color:context.resources.color.colorRed,fontWeight: FontWeight.w400)),
            ):Container(),

          ],
        ),
      );
    }else{
      return Container(
        margin: EdgeInsets.symmetric(vertical:10*multiply),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isObsecure!,
          maxLength: maxlenth,
          inputFormatters: inputformator,
          decoration: InputDecoration(
            enabled: isEnable!,
            hintText: hintText != "" ? hintText : labelText,
            hintStyle: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                fontSize: 20,fontWeight: FontWeight.w600
            ),
            prefixText: prefixText == "" ? null : prefixText,
            labelText: labelText,
            labelStyle: TextStyle(
                color: errorText == null ? Theme.of(context).primaryColor : context.resources.color.colorPrimary,
                fontSize: 16,fontWeight: FontWeight.w500
            ),
            errorText: errorText,
            floatingLabelBehavior:FloatingLabelBehavior.always,
            errorStyle: TextStyle(
                color: context.resources.color.colorRed,
                fontSize: 16,fontWeight: FontWeight.w400
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: context.resources.color.colorRed,style: BorderStyle.solid),
            ),
          ),
        ),
      );
    }
  }
}

class RoundHeritageTextFeild extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool? isObsecure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxlenth;
  final String? prefixText;
  final List<TextInputFormatter>? inputformator;
  final bool? isEnable;
  const RoundHeritageTextFeild({Key? key,this.hintText = "", required this.labelText,this.errorText = null, required this.controller, this.isObsecure = false, this.keyboardType = TextInputType.text,this.maxlenth = null,this.prefixText = "",this.inputformator = null,this.isEnable = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObsecure!,
      maxLength: maxlenth,
      inputFormatters: inputformator,
      decoration: InputDecoration(
        enabled: isEnable!,
        hintText: hintText != "" ? hintText : labelText,
        hintStyle: TextStyle(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            fontSize: 20,fontWeight: FontWeight.w600
        ),
        prefixText: prefixText == "" ? null : prefixText,
        labelText: labelText,
        labelStyle: TextStyle(
            color: errorText == null ? Theme.of(context).primaryColor : context.resources.color.colorPrimary,
            fontSize: 16,fontWeight: FontWeight.w500
        ),
        errorText: errorText,
        floatingLabelBehavior:FloatingLabelBehavior.always,
        errorStyle: TextStyle(
            color: context.resources.color.colorRed,
            fontSize: 16,fontWeight: FontWeight.w400
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: context.resources.color.colorRed,style: BorderStyle.solid),
        ),
      ),
    );
  }
}
class Button extends StatelessWidget {
  final String labelText;
  final bool isEnabled;
  final VoidCallback? onPressed;
  const Button(
      {Key? key,
        required this.labelText,
        required this.onPressed,
        this.isEnabled = true,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(getDeviceType()!="phone"){
      return OnHover(builder: ((isHovered) {
        var enableDecoration = BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xffB5651D),
                Color(0xff654420),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? context.resources.color.colorPrimary.withOpacity(0.5)
                    : Colors.white
                    .withOpacity(0.5), //color of shadow
                spreadRadius: 5, //spread radius
                blurRadius: 7, // blur radius
                offset: Offset(0, 2), // changes position of shadow
                //first paramerter of offset is left-right
                //second parameter is top to down
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(30.0)));
        var diableDecoration = BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.grey,
                Colors.white,
              ],
            ),
            boxShadow: [
              /*  BoxShadow(
            color: isHovered
                ? context.resources.color.colorPrimary.withOpacity(0.5)
                : Colors.white
                .withOpacity(0.5), //color of shadow
            spreadRadius: 5, //spread radius
            blurRadius: 7, // blur radius
            offset: Offset(0, 0), // changes position of shadow
            //first paramerter of offset is left-right
            //second parameter is top to down
          ),*/
            ],
            borderRadius: BorderRadius.all(Radius.circular(30.0)));

        return Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            elevation: isHovered ? 4 : 0,
            child: InkWell(
              onTap: onPressed,
              child: Container(
                decoration: isEnabled ? enableDecoration : diableDecoration,
                child: Center(
                  child: Text(
                    labelText,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ));

      } ));
    }else{
      var enableDecoration = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xffB5651D),
              Color(0xff654420),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30.0)));
      var diableDecoration = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.grey,
              Colors.white,
            ],
          ),

          borderRadius: BorderRadius.all(Radius.circular(30.0)));
      return Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
          elevation:0,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              decoration: isEnabled ? enableDecoration : diableDecoration,
              child: Center(
                child: Text(
                  labelText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ));
    }

  }
}

