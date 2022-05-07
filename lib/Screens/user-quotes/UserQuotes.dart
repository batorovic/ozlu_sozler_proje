import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ozlu_sozler/constants.dart';

class UserQuotes extends StatefulWidget {
  const UserQuotes({Key? key}) : super(key: key);

  @override
  State<UserQuotes> createState() => _UserQuotesState();
}

class _UserQuotesState extends State<UserQuotes> {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("1")],
          ),

          //goruntule
          const Text("2"),
        ]),
      ),
    );
  }
}
