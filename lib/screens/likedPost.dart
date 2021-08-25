import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inert/screens/discover.dart';

class LikedPost extends StatefulWidget {
  final String image;

  const LikedPost({Key key, this.image}) : super(key: key);

  @override
  _LikedPostState createState() => _LikedPostState();
}

class _LikedPostState extends State<LikedPost> {

  getData() async {
   Query product = FirebaseFirestore.instance
        .collectionGroup('posts');
    QuerySnapshot snapshot = await product.get();
    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      if(documentSnapshot.data()['image'] == widget.image) {
        Discover discover = Discover.fromMap(documentSnapshot.data());
        return discover;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return customWidget(snapshot.data);
          } else {
            return Center(child: new CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget customWidget(Discover post) {
    return Stack(children: [
      Opacity(
        opacity: 0.4,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(post.image),
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
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.42,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(post.image),
                        fit: BoxFit.cover,
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
                                  child: post.profilePic != ""
                                      ? Image(
                                          image:
                                              NetworkImage(post.profilePic))
                                      : Icon(Icons.person)),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              post.name,
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
          ))
    ]);
  }
}
