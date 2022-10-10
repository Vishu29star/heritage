import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IeltsData extends StatefulWidget {
  final PersonFormVM personFormVM;
  const IeltsData(this.personFormVM ,{Key? key}) : super(key: key);

  @override
  State<IeltsData> createState() => _IeltsDataState();
}

class _IeltsDataState extends State<IeltsData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("working on it..."),
      ),
    );
  }
}
