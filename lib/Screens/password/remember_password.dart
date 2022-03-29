import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozlu_sozler/components/rounded_button.dart';
import 'package:ozlu_sozler/components/rounded_input.dart';
import 'package:ozlu_sozler/constants.dart';

class RememberPassword extends StatelessWidget {
  const RememberPassword({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remember Password'),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/forgot_password.svg',
            width: 125,
            height: 125,
          ),
          const SizedBox(height: 25),
          Container(
              width: size.width,
              height: size.height * 0.2,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedInput(
                    icon: Icons.email_outlined,
                    hint: 'Mailiniz',
                    controller: controller,
                  ),
                  const RoundedButton(title: 'Şifremi Hatırlat'),
                ],
              ))
        ],
      ),
    );
  }
}
