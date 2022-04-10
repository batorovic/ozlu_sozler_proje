import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  String soz = '';
  String yazarId = '';
  String kategoriID = '';

  Quote.fromMap(Map<String, dynamic> data) {
    soz = data['söz'];
    yazarId = data['Yazar'];
    kategoriID = data['Kategori'];
  }
}
