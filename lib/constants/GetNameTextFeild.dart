import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:flutter/material.dart';

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