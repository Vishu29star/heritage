import 'package:Heritage/utils/comman/commanWidget.dart';
import 'package:flutter/material.dart';

Future<String?> showTextInputDialog(BuildContext context) async {
  final _textFieldController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Chat Name'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Name"),
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
                  CommanWidgets.showToast("Please enter atleast charcter.");
                }else{
                  Navigator.pop(context, _textFieldController.text);
                }

              },
            ),
          ],
        );
      });
}