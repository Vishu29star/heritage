
import 'package:flutter/material.dart';


class CommanWidgets{

 Widget get loadingWidget => Container(
   color: Colors.black.withOpacity(0.5),
   child: Center(
     child:  const CircularProgressIndicator(),
   ),
 );

}

class Comman extends StatelessWidget {
  const Comman({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

