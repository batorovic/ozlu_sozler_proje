import 'package:flutter/material.dart';
import 'package:ozlu_sozler/constants.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 250,
          height: 330,
          color: Colors.red,
        ),
      ),
    );
  }
}
