import 'package:Heritage/data/firestore_constants.dart';
import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'HeritageYesNoWidget.dart';

Future<String?> showTextInputDialog(BuildContext context,{String title = "Add Chat Name",String hint_Value = "Name",String initalValue = ""}) async {
  final _textFieldController = initalValue == "" ? TextEditingController():TextEditingController(text: initalValue);
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text(title),
          content: TextField(
            controller: _textFieldController,
            decoration:   InputDecoration(hintText: hint_Value),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                if(initalValue==""){
                  if(_textFieldController.text.trim().length<3){
                    CommanWidgets.showToast("Please enter atleast charcter.");
                  }else{
                    Navigator.pop(context, _textFieldController.text);
                  }
                }else{
                  if(_textFieldController.text.trim().isEmpty){
                    CommanWidgets.showToast("Please enter Chat delete Time.");
                  }else{
                    Navigator.pop(context, _textFieldController.text.trim());
                  }
                }


              },
            ),
          ],
        );
      });
}

Future<String?> showTextInputDialogNumber(BuildContext context,{String title = "Add Chat Name",String hint_Value = "Name",String initalValue = ""}) async {
  final _textFieldController = initalValue == "" ? TextEditingController():TextEditingController(text: initalValue);
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text(title),
          content: TextField(
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter(3),],
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            controller: _textFieldController,
            decoration:   InputDecoration(hintText: hint_Value),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                if(title == "Update Passport notification Time"){
                  if(_textFieldController.text.trim().isEmpty){
                    CommanWidgets.showToast("Please enter Chat delete Time.");
                  }else{
                    Navigator.pop(context, _textFieldController.text.trim());
                  }
                }else{
                  if(_textFieldController.text.trim().isEmpty){
                    CommanWidgets.showToast("Please enter passport notification Time.");
                  }else{
                    Navigator.pop(context, _textFieldController.text.trim());
                  }
                }



              },
            ),
          ],
        );
      });
}

Future<Map<String,dynamic>?> userAssignToAdminDialog(BuildContext context,{bool isPaymentOption = false}) async {
  final _textFieldController =  TextEditingController();
  String paymentReceived = "no";
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text("Confirm Assigning"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textFieldController,
                decoration:   InputDecoration(hintText: "Any Suggestion "),
              ),
              isPaymentOption ? Container(padding: EdgeInsets.symmetric(vertical: 16),
              child: YesNoWidget(labelText: context.resources.strings.paymentReceived, selected: paymentReceived,onSelection: (result){
                paymentReceived = result;
              },),) : Container()
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                if(_textFieldController.text.trim().length<3){
                  CommanWidgets.showToast("Please enter suggestions for admin.");
                }else{
                  Map<String,dynamic> assignAdminData = {FirestoreConstants.adminSuggestion:_textFieldController.text.trim()};
                  if(isPaymentOption){
                    if(paymentReceived .toLowerCase()=="yes"){
                      assignAdminData.addAll({FirestoreConstants.is_payment_done:true});
                    }else{
                      assignAdminData.addAll({FirestoreConstants.is_payment_done:false});
                    }

                  }
                  Navigator.pop(context, assignAdminData);
                }
              },
            ),
          ],
        );
      });
}
