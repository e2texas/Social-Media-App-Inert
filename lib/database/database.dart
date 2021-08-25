import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String uid;

  final CollectionReference currentCollection =
      FirebaseFirestore.instance.collection('data');
  final CollectionReference test =
      FirebaseFirestore.instance.collection('post');

  Database({this.uid});

  Future updateData(String email, int likes) async {
    return await currentCollection.doc(uid).set({
      'email': email,
      'likes': 0,
    });
  }

  Future deletePost(String image) async {
    var doc = await FirebaseFirestore.instance
        .collection('post')
        .doc(uid)
        .collection('posts')
        .where('image', isEqualTo: image)
        .get();
    for (DocumentSnapshot documentSnapshot in doc.docs) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.delete(documentSnapshot.reference);
      });
    }
  }

  Future uploadPost(String image, String pf, String name) async {
    return await test.doc(uid).collection('posts').add({
      'image': image,
      'profilepic': pf,
      'name': name,
      'createdAt' : Timestamp.now(),
    });
  }

  Future updateName(String name) async {
    return await currentCollection.doc(uid).update({
      'profilepic': "",
      'name': name,
      'background': "",
      'images': FieldValue.arrayUnion([]),
    });
  }

  Future updateOtherData(String name, String pf) async {
    return await currentCollection.doc(uid).update({
      'profilepic': pf,
      'name': name,
      'background': "",
      'images': FieldValue.arrayUnion([]),
    });
  }

  Future addLikedImages() async {
    return await currentCollection.doc(uid).update({
      'likedImages': FieldValue.arrayUnion([]),
    });
  }

  Future<DocumentSnapshot> getDocument() async {
    return await FirebaseFirestore.instance.collection('data').doc(uid).get();
  }
}
