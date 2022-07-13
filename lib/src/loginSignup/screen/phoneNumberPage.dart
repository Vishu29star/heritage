import 'package:flutter/material.dart';

import '../../../constants/FormWidgetTextField.dart';
import '../../../global/global.dart';
import '../../../src/loginSignup/LoginSignUpViewModel.dart';
import '../../../utils/extension.dart';

class PhoneNumberPage extends StatelessWidget {
  final LoginSignUpViewModel model;
  const PhoneNumberPage({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
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
                    context.resources.strings.welcome,
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
                  height: 20,
                ),
                HeritageTextFeild(labelText: context.resources.strings.enterEmail, controller: model.pageOneEmailController,errorText:  model.emailErrorText,keyboardType: TextInputType.emailAddress,),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Button(isEnabled: model.emailErrorText == null ? true : false,onPressed: () => model.emailErrorText == null ? model.checkforEnableAndDisable() : null,labelText: context.resources.strings.submit,)
                ),

                SizedBox(
                  height: 30,
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
