import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozlu_sozler/components/rounded_button.dart';
import 'package:ozlu_sozler/components/rounded_input.dart';
import 'package:ozlu_sozler/components/rounded_password_input.dart';
import 'package:ozlu_sozler/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // klavye acildi mi yoksa acilmadi mi kontrol
    double viewInset = MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    return Scaffold(
      body: Stack(
        children: [
          // Login Formu
          Align(
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 40),
                    SvgPicture.asset(
                      'assets/images/login.svg',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 40),
                    const RoundedInput(icon: Icons.mail, hint: 'Username'),
                    const RoundedPasswordInput(hint: 'Password'),
                    const RoundedButton(title: 'LOGIN'),
                  ],
                ),
              ),
            ),
          ),

          // Register Formu
        ],
      ),
    );
  }
}
