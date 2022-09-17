
import 'dart:html';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';

import '../colors/appColors.dart';

  class CommanWidgets{

 Widget get loadingWidget => Container(
   color: Colors.black.withOpacity(0.5),
   child: Center(
     child:  const CircularProgressIndicator(),
   ),
 );

 bool? isImage(String path) {
   final mimeType = lookupMimeType(path);

   return mimeType?.startsWith('image/');
 }

 bool isPLAYING(PlayerState  state) {
  return state == PlayerState.playing;
 }

 bool? isDocument(String path) {
   final mimeType = lookupMimeType(path);

   return mimeType == 'application/msword';
 }
 static void showToast(String? text) {
   if (text != null && text.isNotEmpty) {
     Fluttertoast.cancel();
     Fluttertoast.showToast(
         msg: text,
         backgroundColor: AppColor().colorPrimary,
         textColor: Colors.white,
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         fontSize: 13.0);
   }
 }

  static void askWebMicrophonePermission() {
    window.navigator.getUserMedia(audio: true);
  }
}

class Comman extends StatelessWidget {
  const Comman({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}