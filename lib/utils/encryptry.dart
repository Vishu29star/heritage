import 'dart:core';

import 'package:encrypt/encrypt.dart';

class encrydecry {
  //private static final String TAG = "ENCRYPT DECRYPT";
  //debuglogs d = new debuglogs();

  encrydecry() {
  }


  String encryptMsg(String message)   {
    /* Encrypt the message. */
    var encrypted = null;

    final key = Key.fromUtf8('ThisIsASecretKey');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key,mode: AESMode.cbc));
    final encryptedr= encrypter.encrypt(message, iv: iv);
    final decrypted = encrypter.decrypt(encryptedr, iv: iv);
    return encryptedr.base64;
  }

  String decryptMsg(cipherText)
  {
/* Decrypt the message, given derived encContentValues and initialization vector. */


    final key = Key.fromUtf8('ThisIsASecretKey');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key,mode: AESMode.cbc));
    final encryptedr= encrypter.encrypt(cipherText, iv: iv);
    final decrypted = encrypter.decrypt64(cipherText, iv: iv);
    return decrypted;
  }
}
