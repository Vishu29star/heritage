
import 'package:flutter/material.dart';


class CommanWidgets{
 Widget get loadingWidget => Container(
   color: Colors.black.withOpacity(0.5),
   child: Center(
     child:  const CircularProgressIndicator(),
   ),
 );

}