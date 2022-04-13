import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // login
  // Future<User?> signIn(String email, String password) async {
  //   var user = await _auth.signInWithEmailAndPassword(
  //       email: email, password: password);
  //   return user.user;
  // }

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
