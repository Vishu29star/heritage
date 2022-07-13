import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../src/loginSignup/LoginSignUpViewModel.dart';
import '../../../../src/loginSignup/screen/passwordVerificationScreen.dart';
import '../../../../src/loginSignup/screen/phoneNumberPage.dart';
import '../../../../src/loginSignup/screen/setProfile.dart';
import '../../../../utils/extension.dart';
import '../conFirmPasswordPage.dart';

class LoginSignUpMobile extends StatelessWidget {

  final LoginSignUpViewModel model;
  LoginSignUpMobile(this.model ,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: model.forgotpassword,
        //leading: model.forgotpassword ?InkWell(onTap :(){model.forgotPasswordBackClick();},child: Icon(Icons.arrow_back_ios_outlined,size: 25,)):Container(),
        title: Text(context.resources.strings.appName, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: context.resources.color.colorPrimary),),
      ),
      body: PageView(
        controller: model.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          PhoneNumberPage(model: model,),
          PasswordVerificationScreen(model: model,),
          ConfirmPasswordScreen(model: model,),
          SetProfilePage(model: model,),
        ],
      ),
    );
  }
}
