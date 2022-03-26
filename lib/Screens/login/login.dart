import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozlu_sozler/Screens/login/components/cancel_button.dart';
import 'package:ozlu_sozler/Screens/login/components/login_form.dart';
import 'package:ozlu_sozler/Screens/login/components/register_form.dart';
import 'package:ozlu_sozler/components/rounded_button.dart';
import 'package:ozlu_sozler/components/rounded_input.dart';
import 'package:ozlu_sozler/components/rounded_password_input.dart';
import 'package:ozlu_sozler/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late AnimationController animationController;
  late Animation<double> containerSize;
  Duration animationDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // klavye acildi mi yoksa acilmadi mi kontrol
    double viewInset = MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize = Tween<double>(
            begin: size.height * 0.1, end: defaultRegisterSize)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    return Scaffold(
      body: Stack(
        children: [
          //daireler
          Positioned(
            top: 100,
            right: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kPrimaryColor),
            ),
          ),

          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: kPrimaryColor),
            ),
          ),

          // Cancel Button
          CancelButton(
              isLogin: isLogin,
              animationDuration: animationDuration,
              size: size,
              tapEvent: isLogin
                  ? null
                  : () {
                      animationController.reverse();
                      setState(() {
                        isLogin = !isLogin;
                      });
                    }),
          // Login Formu
          LoginForm(
              isLogin: isLogin,
              animationDuration: animationDuration,
              size: size,
              defaultLoginSize: defaultLoginSize),

          // Register Container
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              if (viewInset == 0 && isLogin) {
                return buildRegisterContainer();
              } else if (!isLogin) {
                return buildRegisterContainer();
              }
              //widgeti saklama.
              return Container();
            },
          ),
          // Register Formu
          RegisterForm(
              isLogin: isLogin,
              animationDuration: animationDuration,
              size: size,
              defaultLoginSize: defaultLoginSize),
        ],
      ),
    );
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: kBackGroundColor),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController.forward();
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
          child: isLogin
              ? const Text(
                  'Üye değilseniz hemen Üye olun',
                  style: TextStyle(color: kPrimaryColor, fontSize: 18),
                )
              : null, // null dondurduk butonu disable etmek icin.
        ),
      ),
    );
  }
}
