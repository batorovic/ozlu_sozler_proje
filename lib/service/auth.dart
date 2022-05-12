import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/Screens/UserQuotes/UpdateStatus.dart';
import 'package:ozlu_sozler/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // login
  // Future<User?> signIn(String email, String password) async {
  //   var user = await _auth.signInWithEmailAndPassword(
  //       email: email, password: password);
  //   return user.user;
  // }

  CollectionReference favorites =
      FirebaseFirestore.instance.collection('favoriler');
  CollectionReference userSoz =
      FirebaseFirestore.instance.collection('user-soz');

  addUserQuote(String soz, context, Status status) {
    // FirebaseFirestore.instance
    //     .collection("user-soz")
    //     .add({
    //       'uid': _auth.currentUser?.uid,
    //       'soz': soz,
    //     })
    //     .then((value) => {
    //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //               content: Text("Eklendi"),
    //               duration: Duration(milliseconds: 1250),
    //               backgroundColor: kPrimaryColor,
    //               behavior: SnackBarBehavior.floating))
    //         })
    //     .catchError((error) => print(error));

    bool durum = false;
    String id = "";
    FirebaseFirestore.instance
        .collection("user-soz")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['soz'] == soz) {
          id = doc.id;
          durum = true;
          return;
        }
      });
    }).then((value) => {
              if (durum)
                {
                  // userSoz.doc(id).update({'soz': soz}),
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Onceden yazdıginiz soz"),
                      duration: Duration(milliseconds: 1250),
                      backgroundColor: kPrimaryColor,
                      behavior: SnackBarBehavior.floating))
                }
              else
                {
                  if (status.getSelectedId() == "")
                    {
                      userSoz.add({'uid': _auth.currentUser?.uid, 'soz': soz}),
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Eklendi"),
                          duration: Duration(milliseconds: 1250),
                          backgroundColor: kPrimaryColor,
                          behavior: SnackBarBehavior.floating))
                    }
                  else
                    {
                      userSoz.doc(status.getSelectedId()).update({'soz': soz}),
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Guncellendi"),
                          duration: Duration(milliseconds: 1250),
                          backgroundColor: kPrimaryColor,
                          behavior: SnackBarBehavior.floating)),
                      status.setSelectedId(""),
                    }
                }
            });
  }

  addToFavorite(String sozId, context) {
    bool durum = false;
    FirebaseFirestore.instance.collection('favoriler').get().then(
        (QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['uid'] == _auth.currentUser?.uid.toString() &&
            sozId == doc["sozid"]) {
          durum = true;
          return;
        }
      });
    }).then((value) => {
          if (durum)
            {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Zaten favorilerde mevcut ! "),
                  duration: Duration(milliseconds: 1250),
                  backgroundColor: kPrimaryColor,
                  behavior: SnackBarBehavior.floating))
            }
          else
            {
              favorites
                  .add({
                    'uid': _auth.currentUser?.uid.toString(),
                    'sozid': sozId
                  })
                  .then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Favorilere eklendi ! "),
                        duration: Duration(milliseconds: 1250),
                        backgroundColor: kPrimaryColor,
                        behavior: SnackBarBehavior.floating,
                      )))
                  .catchError((error) =>
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("error"),
                        duration: Duration(milliseconds: 1250),
                        backgroundColor: kPrimaryColor,
                        behavior: SnackBarBehavior.floating,
                      )))
            }
        });
    // var collection = FirebaseFirestore.instance.collection('favoriler');
    // collection
    //     .doc('doc_id')
    //     .set({
    //       'uid': _auth.currentUser?.uid.toString(),
    //       'sozid': sozId,
    //     }, SetOptions(merge: true))
    //     .then((value) =>
    //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //           content: Text("Favorilere eklendi ! "),
    //           duration: Duration(milliseconds: 1250),
    //           backgroundColor: kPrimaryColor,
    //           behavior: SnackBarBehavior.floating,
    //         )))
    //     .catchError((error) =>
    //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //           content: Text("error"),
    //           duration: Duration(milliseconds: 1250),
    //           backgroundColor: kPrimaryColor,
    //           behavior: SnackBarBehavior.floating,
    //         )));
  }

  Future<String> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //exit
  // signOut() async {
  //   return await _auth.signOut();
  // }

  //signup
  Future<String> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _fireStore.collection('user').doc(user.user!.uid).set({
        'userName': userName,
        'E-mail': email,
        'sifre': password,
      });
      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //resetpassword
  Future resetPassword(TextEditingController mail) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: mail.text.trim());
  }

  //signout
  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return "Signed out";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  User? getUser() {
    try {
      return _auth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }

  //read data kategori
  readKategori(QuerySnapshot snapData) async {
    var _instance = FirebaseFirestore.instance;
    var listem = [];
    CollectionReference kategori = _instance.collection('kategori');

    for (var i = 0; i < snapData.size; i++) {
      DocumentSnapshot data =
          await kategori.doc(snapData.docs[i]['Kategori']).get();
      listem.add(data['Kategori']);
    }

    print(listem);

    return listem;
  }

  readSomething(/*String docId, String collection*/) async {
    // return FirebaseFirestore.instance
    //     .collection(collection)
    //     .doc(docId)
    //     .snapshots();

    var kategoriList = [];

    FirebaseFirestore.instance
        .collection('kategori')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        kategoriList.add(doc["Kategori"]);
      });
    });

    return kategoriList;
  }
}
