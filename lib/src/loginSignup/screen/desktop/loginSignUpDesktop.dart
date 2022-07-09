import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../../utils/app_style/app_Style.dart';
import '../../../../utils/extension.dart';

import '../../../../constants/FormWidgetTextField.dart';
import '../../LoginSignUpViewModel.dart';
import '../conFirmPasswordPage.dart';
import '../passwordVerificationScreen.dart';
import '../phoneNumberPage.dart';
import '../setProfile.dart';

class LoginSignUpDesktop extends StatelessWidget {
  final LoginSignUpViewModel model;

  LoginSignUpDesktop(this.model, {Key? key}) : super(key: key);
  late BuildContext context;
  var width;
  var height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: model.forgotpassword,
        //leading: model.forgotpassword ?InkWell(onTap :(){model.forgotPasswordBackClick();},child: Icon(Icons.arrow_back_ios_outlined,size: 25,)):Container(),
        title: Text(
          context.resources.strings.appName,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: context.resources.color.colorPrimary),
        ),
      ),
      body: Center(
        child: Container(
          height: height*0.9,
          width: width*0.45,
          padding: EdgeInsets.all(16),
          decoration: AppStyle.neumorphismDecoration,
          child: Center(
              child: PageView(
                controller: model.pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  PhoneNumberPage(model: model,),
                  PasswordVerificationScreen(model: model,),
                  ConfirmPasswordScreen(model: model,),
                  SetProfilePage(model: model,),
                ],
              ),),
        ),
      ),
    );
  }
}
