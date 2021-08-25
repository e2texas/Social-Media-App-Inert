import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inert/screens/post.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String _email;
  var result;
  @override
  int itemCount = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePic();
  }

  final List<String> imagePath = [
    'images/1st.png',
    'images/2nd.png',
    'images/2nd.jpg',
    'images/3rd.jpg',
    'images/4th.jpg',
  ];

  void getProfilePic() async {
    try {

    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                  ),
                  Opacity(
                    opacity: 0.80,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 280,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/3rd.jpg'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    left: MediaQuery.of(context).size.width * 0.32,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/pf3.png'),
                        maxRadius: 70,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* Text(
                    _email,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),*/
                  /*Text(
                    loggedInUser.email.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),*/
                ],
              ),

            ],
          ),
        ));
  }
}
