import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/Screens/quote/quotes.dart';
import 'package:ozlu_sozler/constants.dart';
import 'package:ozlu_sozler/service/auth.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RoundedRegister extends StatelessWidget {
  const RoundedRegister({
    Key? key,
    required this.title,
    required this.mail,
    required this.password,
    required this.username,
  }) : super(key: key);

  final String title;
  final TextEditingController mail;
  final TextEditingController password;
  final TextEditingController username;

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    ProgressDialog pd = ProgressDialog(context: context);
    Size size = MediaQuery.of(context).size;
    return InkWell(
      // signup yap
      onTap: () {
        pd.show(
          max: 100,
          msg: 'Loading',
          backgroundColor: kBackGroundColor,
          msgColor: kPrimaryColor,
          progressBgColor: kPrimaryColor,
          msgFontSize: 22,
          msqFontWeight: FontWeight.bold,
          borderRadius: 30,
        );
        _authService
            .signUp(
                userName: username.text,
                email: mail.text,
                password: password.text)
            .then((String value) =>
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(value),
                  duration: const Duration(milliseconds: 1500),
                  backgroundColor: kPrimaryColor,
                  behavior: SnackBarBehavior.floating,
                  // onVisible: () {
                  //   if (value == 'Signed in') {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const Quotes()));
                  //   }
                  // },
                )))
            .then((value) => pd.close());
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
