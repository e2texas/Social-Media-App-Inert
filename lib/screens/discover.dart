import 'package:cloud_firestore/cloud_firestore.dart';

class Discover {
  String name;
  String profilePic;
  String image;

  Discover.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    profilePic = data['profilepic'];
    image = data['image'];
  }
}
