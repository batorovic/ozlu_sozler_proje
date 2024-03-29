import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozlu_sozler/Screens/login/components/rounded_register.dart';
import 'package:ozlu_sozler/components/rounded_button.dart';
import 'package:ozlu_sozler/components/rounded_input.dart';
import 'package:ozlu_sozler/Screens/login/components/rounded_password_input.dart';
import 'package:ozlu_sozler/Modals/controller.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
    required this.controllerMail,
    required this.controllerUserName,
    required this.controllerPassword,

    // required this.controllerPassword,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;
  final TextEditingController controllerMail;
  final TextEditingController controllerUserName;
  final TextEditingController controllerPassword;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLogin ? 0.0 : 1.0,
      duration: animationDuration * 4,
      child: Visibility(
        visible: !isLogin,
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            //containerdı sized yaptim
            child: SizedBox(
              width: size.width,
              height: defaultLoginSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Let's get started",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 40),
                  SvgPicture.asset(
                    'assets/images/login.svg',
                    width: 125,
                    height: 125,
                  ),
                  const SizedBox(height: 40),
                  RoundedInput(
                    icon: Icons.mail,
                    hint: 'E-mail',
                    controller: controllerMail, //bunlar degisecek
                  ),
                  RoundedInput(
                    icon: Icons.face_rounded,
                    hint: 'Username',
                    controller: controllerUserName, // bunlar degisecek
                  ),
                  RoundedPasswordInput(
                      hint: 'Password', controllerPassword: controllerPassword),
                  const SizedBox(height: 10),
                  //signup
                  RoundedRegister(
                    title: 'Register',
                    mail: controllerMail,
                    username: controllerUserName,
                    password: controllerPassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
