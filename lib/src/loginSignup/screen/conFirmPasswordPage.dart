import 'package:flutter/material.dart';

import '../../../constants/FormWidgetTextField.dart';
import '../../../global/global.dart';
import '../../../utils/app_style/app_Style.dart';
import '../../../utils/extension.dart';
import '../LoginSignUpViewModel.dart';

class ConfirmPasswordScreen extends StatelessWidget {
  final LoginSignUpViewModel model;
  const ConfirmPasswordScreen({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Container(
            width: model.width* 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getDeviceType() != "phone" ?Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset("assets/images/email_page_img.png",height: 200,),
                ):Container(),
                Text(
                  context.resources.strings.setPassword,
                  style: TextStyle(fontSize: 26, color: context.resources.color.colorPrimary,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "assets/images/heritage_logo_2.jpeg",
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(model.pageOneEmailController.text,style: AppStyle.mobileTextStyle1,),
                HeritageTextFeild(labelText: model.forgotpassword ? context.resources.strings.enterNewPassword :context.resources.strings.enterPassword, controller: model.registerPasswordController,errorText:  model.registerPasswordText,isObsecure: true,),
                HeritageTextFeild(labelText: context.resources.strings.enterConfirmPassword, controller: model.confirmPasswordController,errorText:  model.confirmPasswordText,isObsecure: true,),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Button(isEnabled: model.confirmPasswordText == null ? true : false,onPressed: () =>  model.confirmPasswordText == null ? model.registerUser() : null,labelText: context.resources.strings.submit,)
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
