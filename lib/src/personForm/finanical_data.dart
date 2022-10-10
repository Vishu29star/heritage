import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Financials extends StatefulWidget {
  final PersonFormVM personFormVM;
  const Financials(this.personFormVM ,{Key? key}) : super(key: key);

  @override
  State<Financials> createState() => _FinancialsState();
}

class _FinancialsState extends State<Financials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("working on it..."),
      ),
    );
  }
}
