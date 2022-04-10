import 'package:cloud_firestore/cloud_firestore.dart';
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
    final Stream<QuerySnapshot> quotes =
        FirebaseFirestore.instance.collection('söz').snapshots();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: Container(
            width: size.width,
            height: size.height,
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
                    // return Text(data.docs[index]['söz'] +
                    //     ' ' +
                    //     ss2.docs[index]['Kategori']);
                  },
                );
              },
            ),
          ),
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
