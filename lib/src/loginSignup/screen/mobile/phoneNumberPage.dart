import 'package:flutter/material.dart';

import '../../../../constants/FormWidgetTextField.dart';
import '../../../../src/loginSignup/LoginSignUpViewModel.dart';
import '../../../../utils/extension.dart';

class PhoneNumberPage extends StatelessWidget {
  final LoginSignUpViewModel model;
  const PhoneNumberPage({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Container(
          width: model.width* 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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

              /*Container(
                        height: 50,
                        decoration: AppStyle.buttonDecoration,
                        width: width*0.3,
                        child: Center(child: Text(context.resources.strings.submit,style: AppStyle.buttonTextStyle,),),
                      ),*/
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // TODO: implement callback
                  onPressed: () => model.emailErrorText == null ? model.checkforEnableAndDisable() : null,
                  child: Text(
                    context.resources.strings.submit,
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
    );
  }
}
