import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/constants.dart';

class Quotes extends StatefulWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Card(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text('a'),
                onPressed: () {},
              )
            ],
          )
        ],
      )),
      bottomNavigationBar: btmNavBar(),
    );
  }

  BottomNavigationBar btmNavBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? Icons.favorite
                : Icons.favorite_border_outlined),
            label: 'Test'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: kPrimaryColor,
      onTap: _onItemTapped,
      backgroundColor: kBackGroundColor,
      iconSize: 25,
    );
  }
}
