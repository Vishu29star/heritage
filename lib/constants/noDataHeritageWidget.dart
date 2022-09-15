
import 'package:flutter/material.dart';

class HeritageNoDataWidget extends StatelessWidget {
  const HeritageNoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty_outlined,color: Colors.grey,),
          SizedBox(height: 20,),
          Text('No data'),
        ],
      ),),
    );
  }
}
