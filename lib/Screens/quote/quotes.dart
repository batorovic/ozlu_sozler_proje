import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/constants.dart';
import 'package:ozlu_sozler/service/auth.dart';

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
    AuthService _authService = AuthService();
    final Stream<QuerySnapshot> quotes =
        FirebaseFirestore.instance.collection('söz').snapshots();
    final Stream<QuerySnapshot> kategori =
        FirebaseFirestore.instance.collection('kategori').snapshots();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            margin: EdgeInsets.all(30),
            child: StreamBuilder<QuerySnapshot>(
                stream: quotes,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('loading.');
                  }

                  final data = snapshot.requireData;

                  return StreamBuilder(
                      stream: kategori,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot2) {
                        if (snapshot2.hasError) {
                          return Text('Error');
                        }
                        if (snapshot2.connectionState ==
                            ConnectionState.waiting) {
                          return Text('loading.');
                        }
                        final ss2 = snapshot2.requireData;

                        return ListView.builder(
                            itemCount: data.size,
                            itemBuilder: (context, index) {
                              return Text(data.docs[index]['söz'] +
                                  ' ' +
                                  ss2.docs[index]['Kategori']);
                            });
                      });
                }),
          )
        ],
      ),
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
