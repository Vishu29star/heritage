import 'package:Heritage/src/cisForm/cis_form_widget.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../src/mainViewModel.dart';
import '../src/loginSignup/LoginSignUpService.dart';
import '../src/loginSignup/LoginSignUpViewModel.dart';
import '../src/loginSignup/screen/loginSignupMainScreen.dart';
import '../src/splash/splashScreen.dart';
import '../src/studenntForm/student_form_widget.dart';

import '../src/home/home.dart';

class Routes {
  static const String home = "home";
  static const String splash = "splash";
  static const String login = "login";
  static const String studentForm = "studentForm";
  static const String cisForm = "cisForm";

  static Route<T> fadeThrough<T>(RouteSettings settings, WidgetBuilder page,
      {int duration = 300}) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (context, animation, secondaryAnimation) => page(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeScaleTransition(animation: animation, child: child);
      },
    );
  }
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //getting arguments
    final args = settings.arguments;
    final mainVMVar = MainViewMoel();
    switch(settings.name){
      case splash :
        return CupertinoPageRoute(
          builder: (_) => SplashScreen(),
        );
      case login:
        if (args is Map<String, dynamic>) {
          LoginSignUpViewModel loginViewModel = LoginSignUpViewModel(LoginSignUpService(),mainVMVar,);
          // loginViewModel.selectedCountryCode = args["selectedCountryCode"] as String;
          return CupertinoPageRoute(
            builder: (_) => LoginSignUpMainScreen(loginViewModel),
          );
        } else {
          LoginSignUpViewModel loginViewModel = LoginSignUpViewModel(LoginSignUpService(), mainVMVar,);
          return CupertinoPageRoute(
            builder: (_) => LoginSignUpMainScreen(loginViewModel),
          );
        }

      case home:
        return CupertinoPageRoute(
          builder: (_) => Home(),
        );
      case studentForm:
        return MaterialPageRoute(
          builder: (_) => StudenFormWidegt(),
        );
      case cisForm:
        return MaterialPageRoute(
          builder: (_) => CISFormWidget(),
        );
      default:
         return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text("Error!! Route"),
            ),
          );
        });
    }
  }
}