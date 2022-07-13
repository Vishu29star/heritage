import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';

import '../utils/dimension/AppDimension.dart';
import '../utils/dimension/Dimensions.dart';
import '../utils/dimension/dimension_tablet.dart';
import '../utils/dimension/dimension_web.dart';
import '../utils/strings/englishString.dart';
import '../utils/strings/strings.dart';
import 'colors/appColors.dart';

class Resources {
  BuildContext _context;

  Resources(this._context);

  Strings get strings {
    // It could be from the user preferences or even from the current locale
    Locale locale = Localizations.localeOf(_context);
    switch (locale.languageCode) {
      case 'fr':
        return EngLishStrings();
      default:
        return EngLishStrings();
    }
  }

  AppColor get color {
    return AppColor();
  }

  Dimensions get dimensionMobile {
    switch (Platform){

    }
    return AppDimensionMobile();
  }

  Dimensions get dimensionTablet {
    return AppDimensionTablet();
  }
  Dimensions get dimensionWeb {
    return AppDimensionWeb();
  }
  static Resources of(BuildContext context){
    return Resources(context);
  }
}