import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:flutter/material.dart';

class JobOffer extends StatefulWidget {
  final PersonFormVM personFormVM;
  const JobOffer(this.personFormVM ,{Key? key}) : super(key: key);

  @override
  State<JobOffer> createState() => _JobOfferState();
}

class _JobOfferState extends State<JobOffer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("working on it..."),
      ),
    );
  }
}
