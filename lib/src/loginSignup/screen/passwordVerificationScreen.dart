import 'package:flutter/material.dart';
import '../../../utils/extension.dart';
import '../../../constants/FormWidgetTextField.dart';
import '../../../global/global.dart';
import '../../../utils/app_style/app_Style.dart';
import '../LoginSignUpViewModel.dart';

class PasswordVerificationScreen extends StatelessWidget {
  final LoginSignUpViewModel model;
  const PasswordVerificationScreen({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Container(
            width: model.width*0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getDeviceType() != "phone" ?Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset("assets/images/email_page_img.png",height: 200,),
                ):Container(),
                Text(
                  context.resources.strings.login.capitalize(),
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

                HeritageTextFeild(labelText: context.resources.strings.enterPassword, controller: model.loginPasswordController,errorText:  model.passwordErrorText,isObsecure: true,),

                 Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: (){ model.forgotPasswordClick();},
                    child: Text(
                      context.resources.strings.forgotPassword,
                      style: TextStyle(fontSize: 13, color: context.resources.color.colorPrimary,decoration: TextDecoration.underline,),
                    ),
                  ),
                ],
              ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Button(isEnabled: model.passwordErrorText == null ? true : false,onPressed: () =>  model.passwordErrorText == null ? model.loginUser() : null,labelText: context.resources.strings.login,)
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // TODO: implement callback
                    onPressed: () => model.passwordErrorText == null ? model.loginUser() : null,
                    child: Text(
                      context.resources.strings.login,
                      style: TextStyle(color: Colors.white,fontSize: 18),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                              (Set<MaterialState> states) {
                            return EdgeInsets.all(16);
                          },
                        ),
                        shadowColor: MaterialStateProperty.all<Color>(model.emailErrorText == null ? Theme.of(context).primaryColor:
                        Colors.grey),
                        backgroundColor:
                        MaterialStateProperty.all(model.emailErrorText == null ? Theme.of(context).primaryColor:
                        Colors.grey),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
