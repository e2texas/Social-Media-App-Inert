import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inert/screens/discover.dart';

class HomeTest extends StatefulWidget {
  @override
  _HomeTestState createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {

  getData() async {
    List<Discover> postList = [];
    var re = FirebaseFirestore.instance
        .collectionGroup('posts')
        .orderBy('createdAt', descending: true);
    QuerySnapshot snapshot = await re.get();
    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      Discover discover = Discover.fromMap(documentSnapshot.data());
      postList.add(discover);
    }
    return postList;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return customWidget(snapshot.data);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget customWidget(List<Discover> data) {
    return Center(
      child: Text(
        data[0].name,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
