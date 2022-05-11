import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/Screens/UserQuotes/UserQuotes.dart';
import 'package:ozlu_sozler/Screens/favorites/favorites.dart';
import 'package:ozlu_sozler/constants.dart';
import 'package:ozlu_sozler/service/auth.dart';

class Quotes extends StatefulWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  final User? user = FirebaseAuth.instance.currentUser;

  AuthService _authService = AuthService();
  int _selectedIndex = 0;
  List<DropdownMenuItem<String>> menuItems = [];

  String _selectedValue = 'Hepsi';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // if (index == 1) {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => const Favorites()));
      // }
    });
  }

  futureKategori() {
    return Future.value(FirebaseFirestore.instance
        .collection('kategori')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        menuItems.add(DropdownMenuItem(
            child: Text(doc["Kategori"]), value: doc["Kategori"]));
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> quotes =
        FirebaseFirestore.instance.collection('söz').snapshots();
    final Stream<QuerySnapshot> kategori =
        FirebaseFirestore.instance.collection('kategori').snapshots();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _selectedIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  FutureBuilder(
                      future: (menuItems.isEmpty ? futureKategori() : null),
                      builder: (BuildContext context, AsyncSnapshot snapshot2) {
                        if (snapshot2.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: Text('loading...'));
                        } else {
                          if (snapshot2.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot2.error}'));
                          } else {
                            return DropdownButton(
                                hint: const Text('Favorites'),
                                value: _selectedValue,
                                items: menuItems,
                                onChanged: (String? _value) {
                                  setState(() {
                                    _selectedValue = _value!;
                                  });
                                });
                          }
                        }
                      }),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: quotes,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: kBackGroundColor,
                              color: kPrimaryColor,
                            ),
                          );
                        }

                        final data = snapshot.requireData;

                        return ListView.builder(
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            if (_selectedValue ==
                                data.docs[index]['Kategori']) {
                              return cardData(data, index);
                            } else if (_selectedValue == 'Hepsi') {
                              return cardData(data, index);
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          // : const Favorites(),
          : _selectedIndex == 1
              ? const Favorites()
              : const UserQuotes(),
      bottomNavigationBar: btmNavBar(),
    );
  }

  Center cardData(QuerySnapshot<Object?> data, int index) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(data.docs[index]['Söz'],
                    style: const TextStyle(fontSize: 18)),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        _authService.addToFavorite(
                            data.docs[index].id, context);
                      },
                      child: const Text("Favorilere Ekle",
                          style:
                              TextStyle(color: kPrimaryColor, fontSize: 15.5)),
                    ),
                    Text(
                      '- ' + data.docs[index]['Yazar'],
                      style: const TextStyle(fontSize: 15.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
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
            label: 'Favoriler'),
        BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2 ? Icons.draw : Icons.draw_outlined),
            label: 'Yaz'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: kPrimaryColor,
      onTap: _onItemTapped,
      backgroundColor: kBackGroundColor,
      iconSize: 25,
    );
  }
}
