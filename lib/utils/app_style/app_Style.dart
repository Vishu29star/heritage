import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/colors/appColors.dart';

class AppStyle {
  static final Decoration neumorphismDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        const BoxShadow(
          color: Color(0xFFBEBEBE),
          offset: Offset(10, 10),
          blurRadius: 30,
          spreadRadius: 1,
        ),
         const BoxShadow(
          color: Colors.white,
          offset: Offset(-10, -10),
          blurRadius: 30,
          spreadRadius: 1,
        ),
      ]
  );

  static final Decoration neumorphismCircleDecoration = BoxDecoration(
    shape: BoxShape.circle,
      color: Colors.grey[300],
      boxShadow: [
        const BoxShadow(
          color: Color(0xFFBEBEBE),
          offset: Offset(10, 10),
          blurRadius: 30,
          spreadRadius: 1,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(-10, -10),
          blurRadius: 30,
          spreadRadius: 1,
        ),
      ]
  );

  static final Decoration buttonDecoration =BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xffF2C17D),
          AppColor().colorPrimary,
        ],
      ),
      boxShadow: [
        const BoxShadow(
          color: Color(0xFFBEBEBE),
          offset: Offset(10, 10),
          blurRadius: 30,
          spreadRadius: 1,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(-10, -10),
          blurRadius: 30,
          spreadRadius: 1,
        ),
      ]
  );

  static final TextStyle buttonTextStyle = TextStyle(fontSize: 20,color: Colors.white);

  static final TextStyle mobileTextStyle1 = TextStyle(fontSize: 12,color: AppColor().colorPrimary);
}