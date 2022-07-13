import 'dart:ui';

import 'package:flutter/material.dart';

import '../../utils/colors/base_color.dart';

class AppColor implements BaseColors{
  static Map<int, Color> _primary =
  {
    50:Color.fromRGBO(127,56,65, 0.1),
    100:Color.fromRGBO(127,56,65, 0.2),
    200:Color.fromRGBO(127,56,65, 0.3),
    300:Color.fromRGBO(127,56,65, 0.4),
    400:Color.fromRGBO(127,56,65, 0.5),
    500:Color.fromRGBO(127,56,65, 0.6),
    600:Color.fromRGBO(127,56,65, 0.7),
    700:Color.fromRGBO(127,56,65, 0.8),
    800:Color.fromRGBO(127,56,65, 0.9),
    900:Color.fromRGBO(127,56,65, 1.0),
  };


  MaterialColor get colorPrimary =>  MaterialColor(0xff7f3841,_primary);

  Color get colorRed => Colors.red;

  @override
  // TODO: implement castChipColor
  Color get castChipColor => throw UnimplementedError();

  @override
  // TODO: implement catChipColor
  Color get catChipColor => throw UnimplementedError();

  @override
  // TODO: implement colorAccent
  MaterialColor get colorAccent => throw UnimplementedError();

  @override
  // TODO: implement colorBlack
  Color get colorBlack => throw UnimplementedError();

  @override
  // TODO: implement colorPrimaryText
  Color get colorPrimaryText => throw UnimplementedError();

  @override
  // TODO: implement colorSecondaryText
  Color get colorSecondaryText => throw UnimplementedError();

  @override
  // TODO: implement colorWhite
  Color get colorWhite => throw UnimplementedError();

}