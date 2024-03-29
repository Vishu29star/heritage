import 'dart:io';

import 'package:Heritage/models/user_model.dart';
import 'package:Heritage/utils/dateUtilsFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/firestore_constants.dart';
import '../../data/remote/mainService.dart';
import '../../route/myNavigator.dart';
import '../../route/routes.dart';
import '../../src/home/home.dart';
import '../../src/loginSignup/LoginSignUpService.dart';
import '../../src/mainViewModel.dart';
import '../../utils/encryptry.dart';
import '../../utils/extension.dart';

class LoginSignUpViewModel extends ChangeNotifier{
  LoginSignUpViewModel(this.loginSignUpService,this.mainModel);
  final MainViewMoel? mainModel;
  final LoginSignUpService? loginSignUpService;

  BuildContext? context;
  var width;
  var height;
  int firstInit = 0;
  int pagePosition = 0;
  bool forgotpassword = false;

  late var uid;
  late User user;

  initPage(BuildContext context){
    this.context = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    setListener();
  }

  PageController pageController = PageController(initialPage: 0,);

  FocusNode pageOneEmailFocusNode = FocusNode();
  bool pageOneEmailHasFocus = false;
/*110055435372*/
  //textfeildController
  final pageOneEmailController = TextEditingController();
  final pageTwopasswordController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final pinCodeController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var emailErrorText = null;
  var passwordErrorText = null;
  var firstnameErrorText = null;
  var lastnameErrorText = null;
  var phoneNumberErrorText = null;
  var dateBirthErrorText = null;
  var pincodeErrorText = null;
  var nameText = '';
  var registerPasswordText = null;
  var confirmPasswordText = null;
  bool showLoading  = false;


  //listener
  void onPageOneEmailFocusChnage(){
    if(pageOneEmailFocusNode.hasFocus){
      pageOneEmailHasFocus = true;
    }else{
      pageOneEmailHasFocus = false;;
    }
    print("pageOneEmailHasFocus");
    print(pageOneEmailHasFocus);
    notifyListeners();
  }

  void onPageOneEmailChange(){
    final text = pageOneEmailController.value.text;
    if (text.isEmpty) {
      emailErrorText =  context?.resources.strings.cantBeEmpty;
    }else if (text.length < 4) {
      emailErrorText =  context?.resources.strings.tooShort;
    }else if(!isEmail(text)){
      emailErrorText =  context?.resources.strings.notValidEmail;
    }else{
      emailErrorText = null;
    }
    notifyListeners();
  }

  void onLoginPasswordListener(){
    String text = loginPasswordController.text.trim();
    if(text.length<8){
      passwordErrorText = context?.resources.strings.minimum8Charcter;
    }if(text.isEmpty){
      passwordErrorText =  context?.resources.strings.minimum8Charcter;
    }else{
      passwordErrorText = null;
    }
    notifyListeners();
  }

  void onRegisterPasswordListener(){
    String text = registerPasswordController.text.trim();
    if(text.length<8){
      registerPasswordText = context?.resources.strings.minimum8Charcter;
    }else if(text.isEmpty){
      registerPasswordText =  context?.resources.strings.minimum8Charcter;
    }else{
      registerPasswordText = null;
    }
    notifyListeners();
  }

  void onConfirmPasswordListener(){
    String password = registerPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if(password!= confirmPassword || confirmPassword.isEmpty){
      confirmPasswordText = context?.resources.strings.passwordNotMatch;
    }else{
      confirmPasswordText = null;
    }
    notifyListeners();
  }

  void onPagetwoPasswordComplete(String text){
    final text = pageTwopasswordController.value.text;
   
    if(text.length<8){
      passwordErrorText = context?.resources.strings.minimum8Charcter;
    }else{
      passwordErrorText = null;
    }
    Future.delayed(const Duration(milliseconds: 2000), () {
      bool isPinValid = true;
      if(isPinValid){
        pagePosition = 3;
        pageController.jumpToPage(3);
        passwordErrorText = null;
      }
      notifyListeners();
    });

  }

  void onPagethreeNameChnage(){
    final text = firstNameController.value.text;
    if (text.isEmpty) {
      firstnameErrorText =  context?.resources.strings.cantBeEmpty;;
    }else if (text.length < 2) {
      firstnameErrorText =  context?.resources.strings.tooShort;;
    }else{
      firstnameErrorText = null;
    }
    notifyListeners();

  }

  void onPagethreeLastNameChnage(){
    final text = lastNameController.value.text;
    if (text.isEmpty) {
      lastnameErrorText =  context?.resources.strings.cantBeEmpty;
    }else if (text.length < 2) {
      lastnameErrorText =  context?.resources.strings.tooShort;;
    }else{
      lastnameErrorText = null;
    }
    notifyListeners();

  }

  void onPagethreephoneNumberChnage(){
    final text = phoneNumberController.value.text;
    if (text.isEmpty) {
      phoneNumberErrorText =  context?.resources.strings.cantBeEmpty;
    }
    if (text.length < 10) {
      phoneNumberErrorText =  context?.resources.strings.enterValidPhoneNumber;
    }else{
      phoneNumberErrorText = null;
    }
    notifyListeners();
  }

  void onPagethreeDateOfBirthChnage(){
    var value = dateOfBirthController.value.text;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy');
    final String formatted = formatter.format(now);
    String str1 = value;
    List<String> str2 = str1.split('/');
    String day = str2.isNotEmpty ? str2[0] : '0';
    String month = str2.length > 1 ? str2[1] : '0';
    String year = str2.length > 2 ? str2[2] : '0';
    if (value.isEmpty) {
      dateBirthErrorText =  context?.resources.strings.birthDateisEmpty;
    } else if (int.parse(month) > 12) {
      dateBirthErrorText =  context?.resources.strings.monthIsinvalid;
    } else if (int.parse(day) > 31) {
      dateBirthErrorText =  context?.resources.strings.dayIsinvalid;
    } else if ((int.parse(year) > int.parse(formatted))) {
      dateBirthErrorText =  context?.resources.strings.yearIsinvalid;
    } else if((int.parse(year) < 1950)){
      dateBirthErrorText =  context?.resources.strings.yearIsinvalid;
    }else{
      dateBirthErrorText = null;
    }
    notifyListeners();
  }

  void pincodeValidation(){
    var value = pinCodeController.value.text;
    if(value.length<6){
      pincodeErrorText = context?.resources.strings.pleaseEnterValidPincode;
    }else{
      pincodeErrorText = null;
    }
    notifyListeners();
  }

  //validations

  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  isRegisterPasswordOk(){
    if(registerPasswordController.text.trim().length<8){
      return false;
    }else if(confirmPasswordController.text.trim() != registerPasswordController.text){
      return false;
    }else{
      return true;
    }
  }

  bool isProfileDataisOK(){
    if(firstNameController.text.isEmpty){
      return false;
    }
    if(lastNameController.text.isEmpty){
      return false;
    }
    if(phoneNumberController.text.isEmpty){
      return false;
    }if(dateOfBirthController.text.isEmpty){
      return false;
    }
    if(pinCodeController.text.isEmpty){
      return false;
    }
    return true;
  }
  setListener(){
    pageOneEmailController.addListener(onPageOneEmailChange);
    loginPasswordController.addListener(onLoginPasswordListener);
    registerPasswordController.addListener(onRegisterPasswordListener);
    confirmPasswordController.addListener(onConfirmPasswordListener);
    firstNameController.addListener(onPagethreeNameChnage);
    lastNameController.addListener(onPagethreeLastNameChnage);
    phoneNumberController.addListener(onPagethreephoneNumberChnage);
    dateOfBirthController.addListener(onPagethreeDateOfBirthChnage);
    pinCodeController.addListener(pincodeValidation);
  }

  disposeListener(){
    pageOneEmailController.dispose();
    loginPasswordController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    pinCodeController.dispose();
  }



  forgotPasswordClick() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: pageOneEmailController.text.trim());
    mainModel?.showTopInfoMessage(context!, context?.resources.strings.resetPasswordEmail);
    pagePosition = 1;
    pageController.jumpToPage(1);
    //forgotpassword= true;
    notifyListeners();
  }

  forgotPasswordBackClick(){
    pagePosition = 2;
    pageController.jumpToPage(2);
    forgotpassword= false;
    notifyListeners();
  }


  Future checkforEnableAndDisable() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try{

    if(emailErrorText==null){
      context?.loaderOverlay.show();
      bool? result = await loginSignUpService?.checkIsUserPresentOrNot(encrydecry().encryptMsg(pageOneEmailController.text.trim()));
      print("result");
      print(result);
      if(result!=null){
        if(result){
          pagePosition = 1;
          pageController.jumpToPage(1);
          //mainModel?.showTopInfoMessage(context!, context!.resources.strings.newUser);
        }else{
          mainModel?.showTopInfoMessage(context!, context!.resources.strings.newUser);
          pagePosition = 2;
          pageController.jumpToPage(2);
        }
      }else{
        pagePosition = 2;
        pageController.jumpToPage(2);
      }
      context?.loaderOverlay.hide();
    }else{
      return context?.resources.strings.notValidEmail;
    }
    }catch(e){
      mainModel?.showhideprogress(false, context!);
      mainModel?.showTopErrorMessage(context!, e.toString());
    }
    notifyListeners();
  }

  Future<void> loginUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final text = loginPasswordController.text.trim();
    if(text.length<8){
      mainModel?.showTopErrorMessage(context!, context?.resources.strings.minimum8Charcter);
      return;
    }
    context!.loaderOverlay.show();
    try{
      UserCredential userCredential =  await MainService.auth.signInWithEmailAndPassword(email: pageOneEmailController.text.trim(), password: text);
      if(userCredential!=null){
        uid  = userCredential.user?.uid;
        user  = userCredential.user!;
        await user.updateEmail(pageOneEmailController.text.trim());

        mainModel?.showTopSuccessMessage(context!, context?.resources.strings.loginSuccessfully);
        if(user.displayName!=null){
          String? device_id = await mainModel?.getDeviceId();
          String? appVersion = await mainModel?.getAppVersionId();
          String? firebaseToken;
          if(!kIsWeb){
           firebaseToken = await mainModel?.getMobileFirebaseToken();
          }

          Map<String,dynamic> uploadData ={
            FirestoreConstants.device_id:device_id,
            FirestoreConstants.app_version:appVersion,
          };
          if(kIsWeb){
            uploadData.addAll({FirestoreConstants.device_type:"web"});
          }else{
            if(Platform.isIOS){
              uploadData.addAll({FirestoreConstants.iOS_firebase_token:firebaseToken,FirestoreConstants.device_type:"ios"});
            }else if(Platform.isAndroid){
              uploadData.addAll({FirestoreConstants.android_firebase_token:firebaseToken,FirestoreConstants.device_type:"android"});
            }
          }
          await loginSignUpService!.userRefrence.doc(uid).update(uploadData);
          var response = await loginSignUpService!.userRefrence.doc(uid).get();
          Map<String, dynamic> data = response.data() as Map<String, dynamic>;
          UserModel userModel = UserModel.fromJson(data);
          await updateLocalLoginData(user.displayName!,user.email!,uid,userModel.user_type??"customer");
          if(!user.emailVerified){
            user.sendEmailVerification();
            Future.delayed(Duration(seconds: 4),(){
              mainModel?.showTopInfoMessage(context!, context?.resources.strings.verificationEmailSent);
            });
          }
          context!.loaderOverlay.hide();
          myNavigator.pushNamed(context!, Routes.home, /*arguments: {"mobile": mobile.text.toString()}*/);
          askWebNotificationPermission(uid);
        }else{
          context!.loaderOverlay.hide();
          pagePosition = 4;
          pageController.jumpToPage(4);
        }
      }
    }on FirebaseAuthException catch (e) {
      context!.loaderOverlay.hide();
      print(e.message);
      mainModel?.showTopErrorMessage(context!, e.message);
    }
  }

  askWebNotificationPermission(uid) async {
    String? firebaseToken = await mainModel?.getWebFirebaseToken();
    if(firebaseToken != null){
      Map<String,dynamic> uploadData ={FirestoreConstants.web_firebase_token:firebaseToken,FirestoreConstants.device_type:"web"};
      await loginSignUpService!.userRefrence.doc(uid).update(uploadData);
    }
  }
  Future<void> updatePassword() async {

  /*  if(!isRegisterPasswordOk()){
      mainModel?.showTopErrorMessage(context!, context?.resources.strings.pleaseEnterAllDetail);
      return ;
    }
    context!.loaderOverlay.show();
    try{
      UserCredential? userCredential =   await loginSignUpService?.registerUserWithPassword(pageOneEmailController.text.trim(),confirmPasswordController.text.trim());
      if(userCredential != null){
        uid  = userCredential.user?.uid;
        print(encrydecry().encryptMsg(pageOneEmailController.text.trim()));
        Map<String,dynamic> data = {
          FirestoreConstnats.email:encrydecry().encryptMsg(pageOneEmailController.text.trim()) ,
          FirestoreConstnats.uid:uid ,
        };
        await loginSignUpService?.updateUserData(data);
    mainModel?.showTopSuccessMessage(context!, context!.resources.strings.registerSuccessfully);
    context!.loaderOverlay.hide();
    pagePosition = 4;
    pageController.jumpToPage(4);
    }
    }catch(e){
    print("error "+ e.toString());
    mainModel?.showTopErrorMessage(context!, e.toString());
    mainModel?.showhideprogress(false, context!);
    }
    notifyListeners();
*/
  }

  Future registerUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(!isRegisterPasswordOk()){
      mainModel?.showTopErrorMessage(context!, context?.resources.strings.pleaseEnterAllDetail);
      return ;
    }
    context!.loaderOverlay.show();
    try{
      UserCredential? userCredential = await loginSignUpService?.registerUserWithPassword(pageOneEmailController.text.trim(),confirmPasswordController.text.trim());
      if(userCredential!=null){
        uid  = userCredential.user?.uid;
        user  = userCredential.user!;
        await user.updateEmail(pageOneEmailController.text.trim());
        //user.sendEmailVerification();
        String userType = "customer";
        Map<String,dynamic> data = {
          FirestoreConstants.email:encrydecry().encryptMsg(pageOneEmailController.text.trim()) ,
          FirestoreConstants.createdAt:FieldValue.serverTimestamp(),
          FirestoreConstants.updatedAt:FieldValue.serverTimestamp(),
          FirestoreConstants.uid:uid ,
          FirestoreConstants.user_type:userType ,
        };

        await loginSignUpService?.setUserData(data);
        mainModel?.showTopSuccessMessage(context!, context!.resources.strings.registerSuccessfully+"\n"+context!.resources.strings.verificationEmailSent);
        context!.loaderOverlay.hide();
        pagePosition = 4;
        pageController.jumpToPage(4);
      }
    }catch(e){
      print("error "+ e.toString());
      mainModel?.showTopErrorMessage(context!, e.toString());
      mainModel?.showhideprogress(false, context!);
    }
    notifyListeners();

  }

  bool isProfileValidate(){
    if(firstnameErrorText==null && lastnameErrorText == null && phoneNumberErrorText == null && dateBirthErrorText == null &&
        isProfileDataisOK()){
      return true;
    }else{
      return false;
    }
  }

  Future updateData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try{
      if(isProfileValidate()){
        mainModel?.showhideprogress(true, context!);
        DateTime birthDate = DateTimeUtils.formatToDate(dateOfBirthController.text.trim());
        Timestamp dateOfBirthTimeStamp = Timestamp.fromDate(birthDate);
        String? device_id = await mainModel?.getDeviceId();
        String? appVersion = await mainModel?.getAppVersionId();
        String? firebaseToken;
        if(!kIsWeb){
          firebaseToken = await mainModel?.getMobileFirebaseToken();
        }

        Map<String,dynamic> data = {
          FirestoreConstants.first_name: encrydecry().encryptMsg(firstNameController.text.trim()),
          FirestoreConstants.last_name: encrydecry().encryptMsg(lastNameController.text.trim()) ,
          FirestoreConstants.name: encrydecry().encryptMsg("${firstNameController.text.trim()} ${lastNameController.text.trim()}") ,
          FirestoreConstants.phone_number:encrydecry().encryptMsg(phoneNumberController.text.trim()) ,
          FirestoreConstants.dob:encrydecry().encryptMsg(dateOfBirthController.text.trim()) ,
          FirestoreConstants.pincode:encrydecry().encryptMsg(pinCodeController.text.trim()) ,
          FirestoreConstants.uid:uid ,
          FirestoreConstants.device_id:device_id,
          FirestoreConstants.app_version:appVersion,
        };
        if(kIsWeb){
          data.addAll({FirestoreConstants.device_type:"web"});
        }else{
          if(Platform.isIOS){
            data.addAll({FirestoreConstants.iOS_firebase_token:firebaseToken,FirestoreConstants.device_type:"ios"});
          }else if(Platform.isAndroid){
            data.addAll({FirestoreConstants.android_firebase_token:firebaseToken,FirestoreConstants.device_type:"android"});
          }
        }

        await user.updateDisplayName(firstNameController.text.trim()+ " " +lastNameController.text.trim());

        await loginSignUpService?.updateUserData(data);
        await updateLocalData(data);
        mainModel?.showTopSuccessMessage(context!, context!.resources.strings.profileUpdated);
        mainModel?.showhideprogress(false, context!);
        myNavigator.pushNamed(context!, Routes.home, /*arguments: {"mobile": mobile.text.toString()}*/);
        askWebNotificationPermission(uid);
      }else{
        mainModel?.showTopErrorMessage(context!, context!.resources.strings.pleaseEnterAllDetail);
      }
    }catch(e){
      print(e);
      mainModel?.showTopErrorMessage(context!, e.toString());
    }
  }

  Future<void> updateLocalData(Map<String, dynamic> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await preferences.setString(FirestoreConstants.name, encrydecry().decryptMsg(data[FirestoreConstants.first_name]) + " " + encrydecry().decryptMsg(data[FirestoreConstants.last_name]));
   // await preferences.setString(FirestoreConstnats.phone_number, encrydecry().decryptMsg(data[FirestoreConstnats.phone_number]));
    await preferences.setString(FirestoreConstants.email, pageOneEmailController.text);
    await preferences.setString(FirestoreConstants.uid, data[FirestoreConstants.uid]);
  }
  Future<void> updateLocalLoginData(String name  ,String email, String uid, String user_type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await preferences.setString(FirestoreConstants.name, name);
    await preferences.setString(FirestoreConstants.email, email);
    await preferences.setString(FirestoreConstants.uid, uid);
    await preferences.setString(FirestoreConstants.user_type, user_type);
    //await preferences.setString(FirestoreConstants.user_type, uid);
  }


}