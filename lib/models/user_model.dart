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
  String? _firebaseToken;

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
  String? get firebaseToken => _firebaseToken;
  set firebaseToken(String? firebaseToken) => _firebaseToken = firebaseToken;

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
        String? firebaseToken = "",
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
    if (firebaseToken != null) {this._firebaseToken = firebaseToken;}
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    if(json.containsKey("name")){
      _name = encrydecry().decryptMsg(json["name"]);
    }
    if(json.containsKey("user_type")){
      _user_type = json['user_type'];
    }
    if(json.containsKey("studentFormPercent")){
      _studentFormPercent = json['studentFormPercent'];
    }
    if(json.containsKey("studentFormCaseID")){
      _studentFormCaseID = json['studentFormCaseID'];
    }
    if(json.containsKey("uid")){
      _uid = json['uid'];
    }
    if(json.containsKey("first_name")){
      _first_name = encrydecry().decryptMsg(json["first_name"]);
    }
    if(json.containsKey("last_name")){
      _last_name = encrydecry().decryptMsg(json["last_name"]);
    }
    if(json.containsKey("phone_number")){
      _phone_number = encrydecry().decryptMsg(json["phone_number"]);
    }
    if(json.containsKey("email")){
      _email = encrydecry().decryptMsg(json["email"]);
    }
    if(json.containsKey("dob")){
      if(json.containsKey("dob") is String){
        _dob = encrydecry().decryptMsg(json["dob"]);
      }else{
        _dob = "empty";
      }
    }
    if(json.containsKey("pincode")){
      _pincode = encrydecry().decryptMsg(json["pincode"]);
    }
    if(json.containsKey("firebaseToken")){
      _firebaseToken = json["firebaseToken"];
    }
  }

}