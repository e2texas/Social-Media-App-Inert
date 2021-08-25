import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inert/database/database.dart';
import 'package:line_icons/line_icons.dart';

class ProfilePost extends StatefulWidget {
  @override
  _ProfilePostState createState() => _ProfilePostState();
  final String image;
  final String pf;
  final String name;

  ProfilePost({Key key, this.image, this.pf, this.name}) : super(key: key);
}

class _ProfilePostState extends State<ProfilePost> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
                      onDoubleTap: () {},
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
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: GestureDetector(
            onTap: () async {
              FirebaseFirestore.instance.collection('data')
                ..doc(user.uid).update({
                  'images': FieldValue.arrayRemove([widget.image]),
                });
              Navigator.of(context).pop();
              Database(uid: user.uid).deletePost(widget.image);
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.delete_solid,
                size: 30,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
