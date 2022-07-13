import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/FormWidgetTextField.dart';
import '../../../utils/date_of_bith_formattor.dart';
import '../../../utils/extension.dart';
import '../LoginSignUpViewModel.dart';

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
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Expanded(child: HeritageTextFeild(labelText: context.resources.strings.firstName, controller: model.firstNameController,errorText:  model.firstnameErrorText,keyboardType: TextInputType.name,),),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: HeritageTextFeild(labelText: context.resources.strings.lastName, controller: model.lastNameController,errorText:  model.lastnameErrorText,keyboardType: TextInputType.name,),),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                HeritageTextFeild(labelText: context.resources.strings.phonenumber, controller: model.phoneNumberController,errorText:  model.phoneNumberErrorText,keyboardType: TextInputType.phone,prefixText: context.resources.strings.phoneNumberPrefix,inputformator: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter(10),],),

                SizedBox(
                  height: 20,
                ),

                HeritageTextFeild(labelText: context.resources.strings.email, controller: model.pageOneEmailController,errorText:  model.lastnameErrorText,keyboardType: TextInputType.emailAddress,isEnable: false,),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: HeritageTextFeild(hintText:context.resources.strings.DDMMYYYY,labelText: context.resources.strings.dateOfBirth, controller: model.dateOfBirthController,errorText:  model.dateBirthErrorText,keyboardType: TextInputType.number,inputformator: [  LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.singleLineFormatter, BirthTextInputFormatter(),],),),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: HeritageTextFeild(labelText: context.resources.strings.pincode, controller: model.pinCodeController,errorText:  model.pincodeErrorText,keyboardType: TextInputType.phone,inputformator: [ LengthLimitingTextInputFormatter(6),],),),
                  ],
                ),

                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Button(isEnabled: model.isProfileValidate(),onPressed: () => model.updateData(),labelText: context.resources.strings.save,)
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
