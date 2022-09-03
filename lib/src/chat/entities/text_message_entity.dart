import 'package:cloud_firestore/cloud_firestore.dart';

class TextMessageEntity/* extends Equatable*/ {
  String? _recipientId;
   String? _senderId;
   String? _senderName;
   String? _type;
   Timestamp? _time;
   String? _content;
   String? _receiverName;
   String? _messageId;

  String? get recipientId => _recipientId;

  String? get senderId => _senderId;

  String? get senderName => _senderName;

  String? get type => _type;

  Timestamp? get time => _time;

  String? get content => _content;

  String? get receiverName => _receiverName;

  String? get messageId => _messageId;

  set recipientId(String? recipientId) => _recipientId = recipientId;
  set senderId(String? senderId) => _senderId = senderId;
  set senderName(String? senderName) => _senderName = senderName;
  set type(String? type) => _type = type;
  set time(Timestamp? time) => _time = time;
  set content(String? content) => _content = content;
  set receiverName(String? receiverName) => _receiverName = receiverName;
  set messageId(String? recmessageIdipientId) => _messageId = messageId;


  UserModel(
      {String? recipientId = "",
        String? senderId = "",
        String? senderName = "",
        String? type = "",
        Timestamp? time,
        String? content = "",
        String? receiverName = "",
        String? messageId = "",
      }) {
    if (recipientId != null) {this._recipientId = recipientId;}
    if (senderId != null) {this._senderId = senderId;}
    if (senderName != null) {this._senderName = senderName;}
    if (type != null) {this._type = type;}
    if (time != null) {this._time = time;}
    if (content != null) {this._content = content;}
    if (receiverName != null) {this._receiverName = receiverName;}
    if (messageId != null) {this._messageId = messageId;}
  }



  TextMessageEntity.fromJson(Map<String, dynamic> json) {
    _recipientId = json["recipientId"];
    _senderId = json["senderId"];
    _senderName =  json['senderName'];
    _type =  json['type'];
    _time =  json['time'];
    _content =  json['content'];
    _receiverName =  json['receiverName'];
    _messageId =  json['messageId'];
  }

  Map<String, dynamic> toDocument() {
    return {
      "recipientId": recipientId,
      "senderId": senderId,
      "senderName": senderName,
      "type": type,
      "time": time,
      "content": content,
      "receiverName": receiverName,
      "messageId": messageId,
    };
  }
/*  @override
  // TODO: implement props
  List<Object> get props => [
    recipientId!,
    senderId!,
    senderName!,
    type!,
    time!,
    content!,
    receiverName!,
    messageId!,
  ];*/
}