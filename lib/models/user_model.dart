import 'package:Heritage/utils/encryptry.dart';

class UserModel{
  String? _first_name;
  String? _last_name;
  String? _uid;
  String? _studentFormCaseID;
  num? _studentFormPercent;
  String? _user_type;
  String? _name;
  String? _phone_number;
  String? _email;
  String? _dob;
  String? _pincode;
  String? _device_id;
  String? _device_type;
  String? _app_version;
  String? _android_firebase_token;
  String? _iOS_firebase_token;
  String? _web_firebase_token;
  String? _adminSuggestion;
  dynamic? _assign_admins;
  Map<String,dynamic>? _passportImageObj;
  int? _passportExpiryDate;
  bool _isPaymentDone = false;
  bool _isLastAdminReached = false;


  String? get first_name => _first_name;
  set first_name(String? first_name) => _first_name = first_name;

  String? get last_name => _last_name;
  set last_name(String? last_name) => _last_name = last_name;
  String? get uid => _uid;
  set uid(String? uid) => _uid = uid;
  String? get studentFormCaseID => _studentFormCaseID;
  set studentFormCaseID(String? studentFormCaseID) => _studentFormCaseID = studentFormCaseID;
  num? get studentFormPercent => _studentFormPercent;
  set studentFormPercent(num? studentFormPercent) => _studentFormPercent = studentFormPercent;
  String? get user_type => _user_type;
  set user_type(String? user_type) => _user_type = user_type;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get phone_number => _phone_number;
  set phone_number(String? phone_number) => _phone_number = phone_number;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get dob => _dob;
  set dob(String? dob) => _dob = dob;
  String? get pincode => _pincode;
  set pincode(String? pincode) => _pincode = pincode;

  String? get device_id => _device_id;
  set device_id(String? device_id) => _device_id = device_id;
  String? get device_type => _device_type;
  set device_type(String? device_type) => _device_type = device_type;
  String? get app_version => _app_version;
  set app_version(String? app_version) => _app_version = app_version;
  String? get android_firebase_token => _android_firebase_token;
  set android_firebase_token(String? android_firebase_token) => _android_firebase_token = android_firebase_token;
  String? get web_firebase_token => _web_firebase_token;
  set web_firebase_token(String? web_firebase_token) => _web_firebase_token = web_firebase_token;
  String? get iOS_firebase_token => _iOS_firebase_token;
  set iOS_firebase_token(String? iOS_firebase_token) => _iOS_firebase_token = iOS_firebase_token;

  int? get passportExpiryDate=> _passportExpiryDate;
  set passportExpiryDate(int? passportExpiryDate) => _passportExpiryDate = passportExpiryDate;
  Map<String,dynamic>? get passportImageObj => _passportImageObj;
  set passportImageObj(Map<String,dynamic>? passportImageObj) => _passportImageObj = passportImageObj;
  bool get isPaymentDone => _isPaymentDone;
  set isPaymentDone(bool isPaymentDone) => _isPaymentDone = isPaymentDone;
  bool get isLastAdminReached => _isLastAdminReached;
  set isLastAdminReached(bool isLastAdminReached) => _isLastAdminReached = isLastAdminReached;
  dynamic? get assign_admins => _assign_admins;
  set assign_admins(dynamic? assign_admins) => _assign_admins = assign_admins;
  String? get adminSuggestion => _adminSuggestion;
  set adminSuggestion(String? adminSuggestion) => _adminSuggestion = adminSuggestion;


  UserModel(
      {String? first_name = "",
        String? last_name = "",
        String? uid = "",
        String? studentFormCaseID = "",
        num? studentFormPercent = 0.0,
        String? user_type = "",
        String? name = "",
        String? phone_number = "",
        String? email = "",
        String? dob = "",
        String? pincode = "",
        String? device_id = "",
        String? device_type = "",
        String? app_version = "",
        String? android_firebase_token = "",
        String? web_firebase_token = "",
        String? iOS_firebase_token = "",
        String? adminSuggestion = "",
        Map<String,dynamic>? passportImageObj,
        int? passportExpiryDate ,
        bool? isLastAdminReached ,
        bool? isPaymentDone ,
        dynamic? assign_admins ,
     }) {
    if (first_name != null) {this._first_name = first_name;}
    if (last_name != null) {this._last_name = last_name;}
    if (uid != null) {this._uid = uid;}
    if (studentFormCaseID != null) {this._studentFormCaseID = studentFormCaseID;}
    if (studentFormPercent != null) {this._studentFormPercent = studentFormPercent;}
    if (user_type != null) {this._user_type = user_type;}
    if (name != null) {this._name = name;}
    if (phone_number != null) {this._phone_number = phone_number;}
    if (email != null) {this._email = email;}
    if (dob != null) {this._dob = dob;}
    if (pincode != null) {this._pincode = pincode;}
    this._device_id = device_id;
    this._device_type = device_type;
    this._app_version = app_version;
    this._android_firebase_token = android_firebase_token;
    this._web_firebase_token = web_firebase_token;
    this._iOS_firebase_token = iOS_firebase_token;
    this._passportImageObj = passportImageObj;
    this._passportExpiryDate = passportExpiryDate;
    this._isLastAdminReached = isLastAdminReached ?? false;
    this._assign_admins = assign_admins ?? [""];
    this._passportExpiryDate = passportExpiryDate;
    this._adminSuggestion = adminSuggestion;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    if(json.containsKey("uid")){
      _uid = json['uid'];
    }
    if(json.containsKey("name")){
      try{
        _name = encrydecry().decryptMsg(json["name"]);
      }catch(e){
        _name =  json["name"];
      }

    }
    if(json.containsKey("user_type")){
      _user_type = json['user_type'].toString();
    }
    if(json.containsKey("studentFormPercent")){
      _studentFormPercent = json['studentFormPercent'];
    }
    if(json.containsKey("studentFormCaseID")){
      _studentFormCaseID = json['studentFormCaseID'];
    }
    if(json.containsKey("first_name")){
      try{
        _first_name = encrydecry().decryptMsg(json["first_name"]);
      }catch(e){
        _first_name = json["first_name"];
      }
    }
    if(json.containsKey("last_name")){
      try{
        _last_name = encrydecry().decryptMsg(json["last_name"]);
      }catch(e){
        _last_name = json["last_name"];
      }
    }
    if(json.containsKey("phone_number")){
      try{
        _phone_number = encrydecry().decryptMsg(json["phone_number"]);
      }catch(e){
        _phone_number = json["phone_number"];
      }

    }
    if(json.containsKey("email")){
      try{
        email = encrydecry().decryptMsg(json["email"]);
      }catch(e){
        _email = json["email"];
      }

    }
    if(json.containsKey("dob")){
      if(json.containsKey("dob") is String){
        _dob = encrydecry().decryptMsg(json["dob"]);
      }else{
        _dob = "empty";
      }
    }
    if(json.containsKey("pincode")){
      try{
        _pincode = encrydecry().decryptMsg(json["pincode"]);
      }catch(e){
        _pincode = json["pincode"];
      }
    }
    if(json.containsKey("device_id")){
      _device_id = json['device_id'];
    }
    if(json.containsKey("device_type")){
      _device_type = json['device_type'];
    }
    if(json.containsKey("app_version")){
      _app_version = json['app_version'];
    }
    if(json.containsKey("android_firebase_token")){
      _android_firebase_token = json['android_firebase_token'];
    }
    if(json.containsKey("web_firebase_token")){
      _web_firebase_token = json['web_firebase_token'];
    }
    if(json.containsKey("iOS_firebase_token")){
      _iOS_firebase_token = json['iOS_firebase_token'];
    }
    if(json.containsKey("passport_expiry_date")){
      _passportExpiryDate = json['passport_expiry_date'];
    }
    if(json.containsKey("passport_image")){
      _passportImageObj = json['passport_image'];
    }
    if(json.containsKey("isLastAdminReached")){
      _isLastAdminReached = json['isLastAdminReached'];
    }
    if(json.containsKey("is_payment_done")){
      if(json['is_payment_done'] is String){
        if(json['is_payment_done'].toString().toLowerCase() == "yes"){
          isPaymentDone = true;
        }else{
          isPaymentDone = false;
        }
      }else{
        isPaymentDone = json['is_payment_done'];
      }

    }
    if(json.containsKey("assign_admins")){
      _assign_admins = json['assign_admins'];
    }
    if(json.containsKey("adminSuggestion")){
      _adminSuggestion = json['adminSuggestion'];
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this._uid;
    data['name'] = this._name;
    data['user_type'] = this._user_type;
    data['studentFormPercent'] = this._studentFormPercent;
    data['studentFormCaseID'] = this._studentFormCaseID;
    data['first_name'] = this._first_name;
    data['last_name'] = this._last_name;
    data['phone_number'] = this._phone_number;
    /* data['profilePic'] = this._profilePic;*/
    data['email'] = this._email;
    data['dob'] = this._dob;
    data['pincode'] = this._pincode;
    data['device_id'] = this._device_id;
    data['device_type'] = this._device_type;
    data['app_version'] = this._app_version;
    data['android_firebase_token'] = this._android_firebase_token;
    data['web_firebase_token'] = this._web_firebase_token;
    data['iOS_firebase_token'] = this._iOS_firebase_token;
    data['passport_expiry_date'] = this._passportExpiryDate;
    data['passport_image'] = this._passportImageObj;
    data['is_payment_done'] = this.isPaymentDone;
    data['isLastAdminReached'] = this.isLastAdminReached;
    data['assign_admins'] = this.assign_admins;
    data['adminSuggestion'] = this._adminSuggestion;
    return data;
  }
}