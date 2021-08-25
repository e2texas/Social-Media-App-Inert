import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inert/database/database.dart';
import 'package:like_button/like_button.dart';
import 'package:line_icons/line_icons.dart';

class Post extends StatefulWidget {
  @override
  final String image;
  final String pf;
  final String name;

  Post({Key key, this.image, this.pf, this.name}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  DocumentSnapshot docs;
  final user = FirebaseAuth.instance.currentUser;
  bool isLiked = false;
  List list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> getLiked() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('data').doc(user.uid).get();
    list.addAll(doc.data()['likedImages']);
    for (int i = 0; i < list.length; i++) {
      if (list[i] == widget.image) {
        return true;
      }
    }
    return false;
  }

  Icon likedStatus(bool isLiked) {
    return Icon(
      LineIcons.heartAlt,
      color: isLiked ? Colors.red : Colors.grey.shade200,
      size: 32,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Opacity(
          opacity: 0.4,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.image),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Material(
                    elevation: 20,
                    child: GestureDetector(
                      onDoubleTap: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        docs = await FirebaseFirestore.instance
                            .collection('data')
                            .doc(user.uid)
                            .get();
                        int like = docs.data()['likes'];
                        like++;
                        await FirebaseFirestore.instance
                            .collection('data')
                            .doc(user.uid)
                            .update({
                          'likes': like,
                        });
                        await FirebaseFirestore.instance
                            .collection('data')
                            .doc(user.uid)
                            .update({
                          'likedImages': FieldValue.arrayUnion([widget.image]),
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.42,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20.0,
                                child: ClipOval(
                                    child: widget.pf != ""
                                        ? Image(image: NetworkImage(widget.pf))
                                        : Icon(Icons.person)),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: getLiked(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              bool status = snapshot.data;
                              return LikeButton(
                                  size: 32,
                                  circleColor: CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor: Color(0xff33b5e5),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (status) {
                                    return Icon(
                                      LineIcons.heartAlt,
                                      color: isLiked
                                          ? Colors.red
                                          : Colors.grey.shade200,
                                      size: 32,
                                    );
                                  });
                            } else {
                              return Text("You fucked up");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
      ]),
    );
  }
}
