import 'package:flutter/material.dart';

class HeritageErrorWidget extends StatelessWidget {
  const HeritageErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Column(
        children: [
          Icon(Icons.error,color: Colors.red,),
          SizedBox(height: 20,),
          Text('Something went wrong'),
        ],
      ),),
    );
  }
}
