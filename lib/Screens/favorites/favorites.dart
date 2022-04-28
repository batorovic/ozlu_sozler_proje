import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/constants.dart';
import 'package:ozlu_sozler/service/auth.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

bool durum = false;

class _FavoritesState extends State<Favorites> {
  AuthService _authService = AuthService();
  List favQuotes = [];
  List favUserId = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('favoriler');

  final Stream<QuerySnapshot> favoriler =
      FirebaseFirestore.instance.collection('favoriler').snapshots();
  final Stream<QuerySnapshot> quotes =
      FirebaseFirestore.instance.collection('söz').snapshots();

  final favoriStream = FirebaseFirestore.instance
      .collection('favoriler')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: favoriStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final dataFav = snapshot.requireData;
              return StreamBuilder<QuerySnapshot>(
                  stream: quotes,
                  builder: (context, sp2) {
                    if (sp2.hasData) {
                      final dataQuotes = sp2.requireData;

                      return ListView.builder(
                          itemCount: dataFav.size,
                          itemBuilder: (context, index) {
                            int i = 0;
                            for (var valQuote in dataQuotes.docs) {
                              if (valQuote.reference.id.toString() ==
                                  dataFav.docs[index]['sozid'].toString()) {
                                return cardFav(dataQuotes, index, dataFav, i);
                              }
                              i += 1;
                            }

                            return const SizedBox();
                          });
                    } else {
                      return const SizedBox(); //circular vardi
                    }
                  });
            }

            if (snapshot.hasError) return Text('Error = ${snapshot.error}');

            return const Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          },
        ),
      ),
    );
  }

  Container cardFav(
      QuerySnapshot<Object?> dataQuotes, int index, dataFav, int i) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(dataQuotes.docs[i]['Söz'],
                    style: const TextStyle(fontSize: 18)),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () async {
                          var collection = FirebaseFirestore.instance
                              .collection('favoriler');
                          await collection.doc(dataFav.docs[index].id).delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Favorilerden cikarildi ! "),
                                  duration: Duration(milliseconds: 1250),
                                  backgroundColor: kPrimaryColor,
                                  behavior: SnackBarBehavior.floating));
                        },
                        child: const Text("Favorilerden cikar",
                            style: TextStyle(
                                color: kPrimaryColor, fontSize: 15.5))),
                    Text(
                      '- ' + dataQuotes.docs[i]['Yazar'],
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

  void testci() {}
  veriAl() async {
    var listem = [];
    var sozler = [];

    var collectionFavoriler =
        FirebaseFirestore.instance.collection('favoriler');
    var collectionSozler = FirebaseFirestore.instance.collection('söz');

    var querySnapshotFavoriler = await collectionFavoriler.get();
    var querySnapshotQuotes = await collectionFavoriler.get();

    for (var doc in querySnapshotFavoriler.docs) {
      Map<String, dynamic> data = doc.data();
      if (_authService.getUser()?.uid.toString() == data['uid']) {
        listem.add(data['sozid']);
      }
    }

    return listem;
  }
}
