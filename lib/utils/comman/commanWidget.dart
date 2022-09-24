import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';

import '../colors/appColors.dart';

class CommanWidgets {
  Widget get loadingWidget => Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: const CircularProgressIndicator(),
        ),
      );

  static String getNextAdmin(String userType){
    switch (userType) {
      case "1":
        {
          return "FINANCE";
        }
      case "2":
        {
          return "LEGAL";

        }
      case "3":
        {
          return "ADMIN1";

        }
      case "4":
        {
          return "ADMIN2";

        }
      default:
        {
          return "superadmin";
        }
    }
  }

  static String getNextAdminCode(String userType){
    switch (userType) {
      case "1":
        {
          return "2";
        }
      case "2":
        {
          return "3";

        }
      case "3":
        {
          return "4";

        }
      case "4":
        {
          return "5";

        }
      default:
        {
          return "1";
        }
    }
  }

  static String getAdmin(dynamic assignedAdmin){
    String userType = assignedAdmin[0];
    switch (userType) {
      case "1":
        {
          return "FRONT OFFICE";
        }
      case "2":
        {
          return "FINANCE";

        }
      case "3":
        {
          return "LEGAL";

        }
      case "4":
        {
          return "ADMIN1";

        }
      default:
        {
          return "FRONT OFFICE";
        }
    }
  }

  static List<String> getAdminList(String userType) {
    List<String> list = [
      "FRONT OFFICE",
      "FINANCE",
      "LEGAL",
      "ADMIN1",
      "ADMIN2",
    ];
    switch (userType) {
      case "1":
        {
          list.removeWhere((element) => element.toString() == "FRONT OFFICE");
          break;
        }
      case "2":
        {
          list.removeWhere((element) => element.toString() == "FINANCE");
          break;
        }
      case "3":
        {
          list.removeWhere((element) => element.toString() == "LEGAL");
          break;
        }
      case "4":
        {
          list.removeWhere((element) => element.toString() == "ADMIN1");
          break;
        }
      case "5":
        {
          list.removeWhere((element) => element.toString() == "ADMIN2");
          break;
        }
    }
    return list;
  }

  bool? isImage(String path) {
    final mimeType = lookupMimeType(path);

    return mimeType?.startsWith('image/');
  }

  bool isPLAYING(PlayerState state) {
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
