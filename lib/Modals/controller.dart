import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyController {
  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  void setEmailController(String txt) {
    email.text = txt;
  }

  void setUserNameController(String txt) {
    userName.text = txt;
  }

  void setPasswordController(String txt) {
    password.text = txt;
  }

  TextEditingController getEmailController() {
    return email;
  }

  String getPasswordController(String txt) {
    return password.text;
  }

  String getUserNAmeController(String txt) {
    return userName.text;
  }

  void test(TextEditingController ccc) {
    ccc = TextEditingController(text: 'aaaaa');
  }

  void resetAll() {
    userName.text = '';
    password.text = '';
    email.text = '';
  }
}
