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

  var dropDownData;
  var setDefaultData = true;
  int testSelect = 0;

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
    // final Stream<QuerySnapshot> kategori =
    //     FirebaseFirestore.instance.collection('kategori').snapshots();
    final screens = [sozler(quotes), const Favorites(), const UserQuotes()];

    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: screens[testSelect],
      bottomNavigationBar: testNav(),
    );
  }

  sozler(Stream<QuerySnapshot<Object?>> quotes) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('kategori').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot2) {
                if (!snapshot2.hasData) return Container();

                if (setDefaultData) {
                  dropDownData = "Hepsi";
                }
                return DropdownButton(
                  dropdownColor: Colors.white,
                  elevation: 3,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500),
                  isExpanded: false,
                  value: dropDownData,
                  items: snapshot2.data?.docs.map((value) {
                    return DropdownMenuItem(
                      value: value.get('Kategori'),
                      child: Text('${value.get('Kategori')}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(
                      () {
                        dropDownData = value;
                        _selectedValue = value.toString();
                        setDefaultData = false;
                      },
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: quotes,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: kBackGroundColor,
                      color: kPrimaryColor,
                    ),
                  );
                }

                final data = snapshot.requireData;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    if (_selectedValue == data.docs[index]['Kategori']) {
                      return (cardData(data, index));
                    } else if (_selectedValue == 'Hepsi') {
                      return cardData(data, index);
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  cardData(QuerySnapshot<Object?> data, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 3,
        shadowColor: kPrimaryColor,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: kPrimaryColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.docs[index]['Söz'],
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        _authService.addToFavorite(
                            data.docs[index].id, context);
                      },
                      child: const Text("Favorilere Ekle",
                          style:
                              TextStyle(color: kPrimaryColor, fontSize: 14.5)),
                    ),
                    Text(
                      '- ' + data.docs[index]['Yazar'],
                      style: const TextStyle(fontSize: 14.5),
                    ),
                  ],
                ),
              ],
            )
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //     ListTile(
            //       title: Text(data.docs[index]['Söz'],
            //           style: const TextStyle(fontSize: 18)),
            //       subtitle: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           TextButton(
            //             onPressed: () async {
            //               _authService.addToFavorite(
            //                   data.docs[index].id, context);
            //             },
            //             child: const Text("Favorilere Ekle",
            //                 style:
            //                     TextStyle(color: kPrimaryColor, fontSize: 15.5)),
            //           ),
            //           Text(
            //             '- ' + data.docs[index]['Yazar'],
            //             style: const TextStyle(fontSize: 15.5),
            //           ),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(height: 4),
            //   ],
            // ),

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

  NavigationBarTheme testNav() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: kPrimaryColor,
        iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: kPrimaryColor)),
        indicatorColor: Colors.blue.shade100,
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: kPrimaryColor)),
      ),
      child: NavigationBar(
          animationDuration: const Duration(milliseconds: 800),
          backgroundColor: const Color(0xFFf1f5fb),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: testSelect,
          onDestinationSelected: (index) => setState(() => testSelect = index),
          height: 60,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.favorite_outline),
                selectedIcon: Icon(
                  Icons.favorite,
                ),
                label: "Favoriler"),
            NavigationDestination(
                icon: Icon(Icons.draw_outlined),
                selectedIcon: Icon(Icons.draw),
                label: "Yaz"),
          ]),
    );
  }
}
