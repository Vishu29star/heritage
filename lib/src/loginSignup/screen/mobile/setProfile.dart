import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/FormWidgetTextField.dart';
import '../../../../utils/date_of_bith_formattor.dart';
import '../../../../utils/extension.dart';
import '../../LoginSignUpViewModel.dart';

class SetProfilePage extends StatelessWidget {
  final LoginSignUpViewModel model;
  const SetProfilePage({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: 16),
            width: model.width*0.8,
            //width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "assets/images/heritage_logo_2.jpeg",
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 20,
                ),
                HeritageTextFeild(labelText: context.resources.strings.firstName, controller: model.firstNameController,errorText:  model.firstnameErrorText,keyboardType: TextInputType.name,),

                SizedBox(
                  height: 20,
                ),
                HeritageTextFeild(labelText: context.resources.strings.lastName, controller: model.lastNameController,errorText:  model.lastnameErrorText,keyboardType: TextInputType.name,),
                SizedBox(
                  height: 20,
                ),
                HeritageTextFeild(labelText: context.resources.strings.phonenumber, controller: model.phoneNumberController,errorText:  model.phoneNumberErrorText,keyboardType: TextInputType.phone,maxlenth: 10,prefixText: context.resources.strings.phoneNumberPrefix,inputformator: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),],),

                SizedBox(
                  height: 20,
                ),

                HeritageTextFeild(hintText:context.resources.strings.DDMMYYYY,labelText: context.resources.strings.dateOfBirth, controller: model.dateOfBirthController,errorText:  model.dateBirthErrorText,keyboardType: TextInputType.number,maxlenth: 10,inputformator: [  LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.singleLineFormatter, BirthTextInputFormatter(),],),
                SizedBox(
                  height: 20,
                ),
                HeritageTextFeild(labelText: context.resources.strings.email, controller: model.pageOneEmailController,errorText:  model.lastnameErrorText,keyboardType: TextInputType.emailAddress,isEnable: false,),

                SizedBox(
                  height: 20,
                ),
                HeritageTextFeild(labelText: context.resources.strings.pincode, controller: model.pinCodeController,errorText:  model.pincodeErrorText,keyboardType: TextInputType.phone,maxlenth: 6,inputformator: [ LengthLimitingTextInputFormatter(6),],),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // TODO: implement callback
                    style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                              (Set<MaterialState> states) {
                            return EdgeInsets.all(16);
                          },
                        ),
                        shadowColor: MaterialStateProperty.all<Color>( Theme.of(context).primaryColor
                        ),
                        backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).primaryColor),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),))),
                    onPressed: () async {
                      model.updateData();
                    },
                    child: Text(
                      context.resources.strings.save,
                      style: TextStyle(color: Colors.white,fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
