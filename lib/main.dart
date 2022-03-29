import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ozlu_sozler/Screens/login/login.dart';
import 'package:ozlu_sozler/constants.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  //firebase baslatma
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      home: const LoginScreen(),
      //home: const MyHomePage(title: 'merhaba'),
    );
  }
}
