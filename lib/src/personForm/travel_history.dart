import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TravelHistory extends StatefulWidget {
  final PersonFormVM personFormVM;
  const TravelHistory(this.personFormVM ,{Key? key}) : super(key: key);
  @override
  State<TravelHistory> createState() => _TravelHistoryState();
}

class _TravelHistoryState extends State<TravelHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("working on it..."),
      ),
    );
  }
}
