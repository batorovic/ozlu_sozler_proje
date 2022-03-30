import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozlu_sozler/Screens/login/components/forget_password.dart';
import 'package:ozlu_sozler/components/rounded_button.dart';
import 'package:ozlu_sozler/components/rounded_input.dart';
import 'package:ozlu_sozler/Screens/login/components/rounded_login.dart';
import 'package:ozlu_sozler/Screens/login/components/rounded_password_input.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
    required this.controller,
    required this.controllerPassword,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;
  final TextEditingController controller;
  final TextEditingController controllerPassword;
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLogin ? 1.0 : 0.0,
      duration: animationDuration * 4,
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
                  'Hoşgeldiniz',
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
                  hint: 'E-Mail',
                  controller: controller,
                ),
                RoundedPasswordInput(
                    hint: 'Password', controllerPassword: controllerPassword),
                const SizedBox(height: 10),
                RoundedLogin(
                  title: 'Giriş Yap',
                  mail: controller,
                  password: controllerPassword,
                ),
                const SizedBox(height: 10),
                ForgotPassword(
                  title: 'Şifremi Unuttum',
                  controller: controller,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
