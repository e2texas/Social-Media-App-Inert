import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:inert/screens/likedPost.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Liked extends StatefulWidget {
  @override
  _LikedState createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  final user = FirebaseAuth.instance.currentUser;
  int like;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('data')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          var document = snapshot.data;
          if (document != null) {
            return customWidget(document['likes'], document);
          } else {
            return new CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget customWidget(int likes, DocumentSnapshot doc) {
    List images = doc['likedImages'];
    int _present = likes;
    double size = _present * 1.0;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 18),
              child: Text(
                "Likes",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              child: images.isNotEmpty
                  ? CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 1.0,
                        height: 400,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                      ),
                      items: images
                          .map((item) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LikedPost(
                                                image: item.toString(),
                                              )));
                                },
                                child: Material(
                                  elevation: 5,
                                  child: Container(
                                    width: 400,
                                    child: Image(
                                      image: NetworkImage(item),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.25,
                          left: MediaQuery.of(context).size.width * 0.09),
                      child: Text(
                        "You have no liked images",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Comforta',
                          color: Colors.black,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.33, top: 100),
              child: images.isNotEmpty
                  ? SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                          infoProperties: InfoProperties(
                            bottomLabelText: "Likes",
                            mainLabelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            bottomLabelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Comforta',
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          size: 140,
                          customColors: CustomSliderColors(
                            hideShadow: true,
                            trackColor: Colors.grey[400],
                            progressBarColor: Colors.black,
                          ),
                          customWidths:
                              CustomSliderWidths(progressBarWidth: 10)),
                      min: 0.0,
                      max: 10.0,
                      initialValue: size,
                    )
                  : Text(""),
            ),
          ],
        ),
      ),
    );
  }
}
