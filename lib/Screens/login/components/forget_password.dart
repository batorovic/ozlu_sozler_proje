import 'package:flutter/material.dart';
import 'package:ozlu_sozler/Screens/password/remember_password.dart';
import 'package:ozlu_sozler/constants.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RememberPassword(
                      controller: controller,
                    )));
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
          width: size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: kPrimaryColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          )),
    );
  }
}
