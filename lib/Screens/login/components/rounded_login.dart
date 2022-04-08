import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/Screens/quote/quotes.dart';
import 'package:ozlu_sozler/constants.dart';
import 'package:ozlu_sozler/service/auth.dart';

class RoundedLogin extends StatelessWidget {
  const RoundedLogin({
    Key? key,
    required this.title,
    required this.mail,
    required this.password,
  }) : super(key: key);

  final String title;
  final TextEditingController mail;
  final TextEditingController password;

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

    Size size = MediaQuery.of(context).size;
    return InkWell(
      // giriş yap
      onTap: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: kBackGroundColor,
                    color: kPrimaryColor,
                  ),
                ));

        _authService
            .signIn(mail.text.trim(), password.text.trim())
            .then((String value) =>
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(value),
                  duration: const Duration(milliseconds: 1500),
                  backgroundColor: kPrimaryColor,
                  behavior: SnackBarBehavior.floating,
                  onVisible: () {
                    if (value == 'Signed in') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Quotes()));
                    }
                  },
                )))
            .then((value) => Navigator.of(context).pop());
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
