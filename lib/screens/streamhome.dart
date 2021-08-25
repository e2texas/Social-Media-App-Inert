import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inert/screens/discover.dart';
import 'package:inert/screens/post.dart';
import 'package:line_icons/line_icons.dart';

class StreamHome extends StatefulWidget {
  @override
  _StreamHomeState createState() => _StreamHomeState();
}

class _StreamHomeState extends State<StreamHome> {
  final user = FirebaseAuth.instance.currentUser;
  String name;
  getData() async {
    List<Discover> postList = [];
    Query product = FirebaseFirestore.instance.collectionGroup('posts');
    QuerySnapshot snapshot = await product.get();
    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      Discover discover = Discover.fromMap(documentSnapshot.data());
      postList.add(discover);
    }
    return postList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return customWidget(snapshot.data);
          } else {
            return Center(
              child: new CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget customWidget(List<Discover> postList) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 70, left: 10, right: 10),
      physics: ScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              Text(
                "Discover",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
              ),
              IconButton(
                  icon: Icon(LineIcons.alternateSignOut),
                  iconSize: 40,
                  color: Colors.black,
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      if (FirebaseAuth.instance.currentUser == null) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      }
                    } on Exception catch (e) {
                      print(e);
                    }
                  }),
            ],
          ),
        ),
        ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                child: Column(children: [
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Post(
                                      image: postList[index].image,
                                      pf: postList[index].profilePic,
                                      name: postList[index].name,
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(postList[index].image),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          child: ClipOval(
                              child: postList[index].profilePic != ""
                                  ? Image(
                                      image: NetworkImage(
                                          postList[index].profilePic))
                                  : Icon(Icons.person)),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          postList[index].name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            })
      ]),
    );
  }
}
