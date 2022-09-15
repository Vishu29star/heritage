import 'dart:typed_data';

import 'package:Heritage/models/user_model.dart';
import 'package:Heritage/src/chat/chatVM.dart';
import 'package:Heritage/src/chat/messageScreen.dart';
import 'package:Heritage/src/cisForm/cis_form_widget.dart';
import 'package:Heritage/src/home/homeVM.dart';
import 'package:Heritage/src/home/userWidget/UserDetail.dart';
import 'package:Heritage/src/notifications/notifications_screen.dart';
import 'package:Heritage/utils/audioPlayer/audio_example.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants/pdfPreview.dart';
import '../src/chat/chat_screen.dart';
import '../src/home/home.dart';
import '../src/loginSignup/LoginSignUpService.dart';
import '../src/loginSignup/LoginSignUpViewModel.dart';
import '../src/loginSignup/screen/loginSignupMainScreen.dart';
import '../src/mainViewModel.dart';
import '../src/splash/splashScreen.dart';
import '../src/studenntForm/student_form_widget.dart';
import 'package:pdf/widgets.dart' as pw;

class Routes {
  static const String home = "home";
  static const String splash = "splash";
  static const String login = "login";
  static const String studentForm = "studentForm";
  static const String cisForm = "cisForm";
  static const String userDetail = "userDetail";
  static const String pdfPreview = "pdfPreview";
  static const String chatScreen = "chatScreen";
  static const String notifications = "notifications";
  static const String messageScreen = "messageScreen";
  static const String setting = "setting";
  static const String demo = "demo";

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
      case demo :
        return CupertinoPageRoute(
          builder: (_) => Demo(),
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


      case userDetail:
        if (args is Map<String, dynamic>){
          HomeVM model = args["model"] as HomeVM;
          return CupertinoPageRoute(
            builder: (_) => UserDetail(model),
          );
        }
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text("Error!! Route"),
            ),
          );
        });


      case home:
        return CupertinoPageRoute(
          builder: (_) => Home(),
        );
      case studentForm:
        String userid = args as String;
        return MaterialPageRoute(
          builder: (_) => StudenFormWidegt(userId: userid,),
        );
      case cisForm:
        return MaterialPageRoute(
          builder: (_) => CISFormWidget(),
        );
      case pdfPreview:
        Uint8List pdf = args as Uint8List;
        return MaterialPageRoute(
          builder: (_) => PdfPreviewPage( pdf,),
        );
      case chatScreen:
        Map<String,dynamic> map = {};
        if(args!=null){
        map = args as  Map<String,dynamic>;
        }
        return CupertinoPageRoute(
          builder: (_) => ChatScreen(map),
        );
      case notifications:
        UserModel map;
        if(args!=null){
          map = args as  UserModel;
          return CupertinoPageRoute(
            builder: (_) => NotiFicationScreen(map),
          );
        }
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text("Error!! Route"),
            ),
          );
        });
      case setting:
        UserModel map;
        if(args!=null){
          map = args as  UserModel;
          return CupertinoPageRoute(
            builder: (_) => NotiFicationScreen(map),
          );
        }
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text("Error!! Route"),
            ),
          );
        });

      case messageScreen:
        if (args is Map<String, dynamic>){
          ChatVM model = args["model"] as ChatVM;
          return CupertinoPageRoute(
            builder: (_) => SingleChatPage(model: model),
          );
        }
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text("Error!! Route"),
            ),
          );
        });
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