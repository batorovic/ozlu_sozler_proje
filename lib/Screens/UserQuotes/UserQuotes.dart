import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/Screens/UserQuotes/UpdateStatus.dart';
import 'package:ozlu_sozler/Screens/UserQuotes/components/SaveQuote.dart';
import 'package:ozlu_sozler/components/input_container.dart';
import 'package:ozlu_sozler/constants.dart';

class UserQuotes extends StatefulWidget {
  const UserQuotes({Key? key}) : super(key: key);

  @override
  State<UserQuotes> createState() => _UserQuotesState();
}

final TextEditingController userQuote = TextEditingController();
bool updateStatus = false;
Status durum = Status();

class _UserQuotesState extends State<UserQuotes> {
  final quoteSozStream = FirebaseFirestore.instance
      .collection('user-soz')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
              labelColor: kBackGroundColor,
              indicatorColor: kBackGroundColor,
              tabs: [
                Tab(icon: Icon(Icons.add)),
                Tab(icon: Icon(Icons.notes)),
              ]),
        ),
        body: TabBarView(children: [
          //yaz
          addQuote(updateStatus),
          //goruntule
          viewQuote(),
        ]),
      ),
    );
  }

  viewQuote() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user-soz')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return quoteCard(data, index, context);
                },
              );
            }
            if (snapshot.hasError) {
              return Text("Error =${snapshot.error}");
            }
            return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor));
          }),
    );
  }

  quoteCard(QuerySnapshot<Object?> dataQuotes, int i, context) {
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
                  dataQuotes.docs[i]['soz'],
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          DefaultTabController.of(context)?.animateTo(0);
                          userQuote.text = dataQuotes.docs[i]['soz'];
                          durum.setSelectedId(dataQuotes.docs[i].id);

                          setState(() {
                            updateStatus = !updateStatus;
                            durum.setDurum(true);
                          });
                        },
                        child: const Text("Düzenle",
                            style: TextStyle(
                                color: kPrimaryColor, fontSize: 15.5))),
                    TextButton(
                        onPressed: () async {
                          var collection =
                              FirebaseFirestore.instance.collection('user-soz');
                          await collection.doc(dataQuotes.docs[i].id).delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Sözlerden çıkarıldı ! "),
                                  duration: Duration(milliseconds: 1250),
                                  backgroundColor: kPrimaryColor,
                                  behavior: SnackBarBehavior.floating));
                        },
                        child: const Text(
                          "Sil",
                          style:
                              TextStyle(color: kPrimaryColor, fontSize: 15.5),
                        ))
                  ],
                ),
              ],
            ),
          )),
    );
  }

  SingleChildScrollView addQuote(updateStatus) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(children: [
          InputContainer(
            child: TextField(
              maxLines: 9,
              minLines: 9,
              controller: userQuote,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Sözünü yazınız.",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 50),
          SaveQuote(
            userQuote: userQuote,
            status: durum,
          ),
        ]),
      ),
    );
  }
}
