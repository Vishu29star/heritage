import 'package:flutter/material.dart';

class HeritageProgressBar extends StatelessWidget {
  const HeritageProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 20,),
        Text("Loading")
      ],
    ),),);
  }
}
