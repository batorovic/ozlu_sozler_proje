import 'package:flutter/material.dart';
import 'package:ozlu_sozler/Screens/UserQuotes/UpdateStatus.dart';
import 'package:ozlu_sozler/constants.dart';
import 'package:ozlu_sozler/service/auth.dart';

class SaveQuote extends StatelessWidget {
  /*const*/ SaveQuote({
    Key? key,
    required this.userQuote,
    required this.status,
  }) : super(key: key);
  final TextEditingController userQuote;
  Status status;

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        if (userQuote.text != "") {
          await _auth.addUserQuote(userQuote.text.trim(), context, status);
          DefaultTabController.of(context)?.animateTo(1);

          userQuote.text = "";
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Boş bırakmayınız !"),
              duration: Duration(milliseconds: 1250),
              backgroundColor: kPrimaryColor,
              behavior: SnackBarBehavior.floating));
        }
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
          child: const Text("Kaydet",
              style: TextStyle(color: kBackGroundColor, fontSize: 18))),
    );
  }
}
