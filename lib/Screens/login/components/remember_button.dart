import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/constants.dart';

class RememberButton extends StatelessWidget {
  const RememberButton({
    Key? key,
    required this.title,
    required this.mail,
  }) : super(key: key);

  final String title;
  final TextEditingController mail;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
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

        try {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: mail.text.trim());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Password reset mail sent'),
                duration: Duration(milliseconds: 1500),
                backgroundColor: kPrimaryColor,
                behavior: SnackBarBehavior.floating),
          );
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(e.message.toString()),
                duration: const Duration(milliseconds: 1500),
                backgroundColor: kPrimaryColor,
                behavior: SnackBarBehavior.floating),
          );
        }
        Navigator.of(context).pop();
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
