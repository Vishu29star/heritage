import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FamilyInformation extends StatefulWidget {
  final PersonFormVM personFormVM;
  const FamilyInformation(this.personFormVM ,{Key? key}) : super(key: key);
  @override
  State<FamilyInformation> createState() => _FamilyInformationState();
}

class _FamilyInformationState extends State<FamilyInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("working on it..."),
      ),
    );
  }
}
