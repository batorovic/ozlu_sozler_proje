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
  List<DropdownMenuItem<String>> menuItems = [];

  String _selectedValue = 'Hepsi';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            // DropdownButton(items: menuItems, onChanged: (val) {}),

            FutureBuilder(
                future: (menuItems.isEmpty ? futureKategori() : null),
                builder: (BuildContext context, AsyncSnapshot snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('loading...'));
                  } else {
                    if (snapshot2.hasError) {
                      return Center(child: Text('Error: ${snapshot2.error}'));
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return Text('loading.');
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
                      if (_selectedValue == data.docs[index]['Kategori']) {
                        return Center(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(data.docs[index]['söz']),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text('- ' + data.docs[index]['Yazar']),
                                      const SizedBox(width: 8),
                                      // const SizedBox(width: 8),
                                      // TextButton(
                                      //   child: const Text('LISTEN'),
                                      //   onPressed: () {/* ... */},
                                      // ),
                                      // const SizedBox(width: 8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (_selectedValue == 'Hepsi') {
                        return Center(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(data.docs[index]['söz']),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text('- ' + data.docs[index]['Yazar']),
                                      const SizedBox(width: 8),
                                      // const SizedBox(width: 8),
                                      // TextButton(
                                      //   child: const Text('LISTEN'),
                                      //   onPressed: () {/* ... */},
                                      // ),
                                      // const SizedBox(width: 8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                      // return Text(data.docs[index]['söz'] +
                      //     ' ' +
                      //     ss2.docs[index]['Kategori']);
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
            label: 'Favoriler'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: kPrimaryColor,
      onTap: _onItemTapped,
      backgroundColor: kBackGroundColor,
      iconSize: 25,
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    // DropdownMenuItem(child: Text("USA"),value: "USA"),
    // DropdownMenuItem(child: Text("),value: "USA"),
  ];
  FirebaseFirestore.instance
      .collection('kategori')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      menuItems.add(DropdownMenuItem(
        child: doc["Kategori"],
        value: doc["Kategori"],
      ));
    });
  });

  return menuItems;
}
