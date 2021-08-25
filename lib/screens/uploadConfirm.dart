import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:inert/database/database.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UploadConfirm extends StatefulWidget {
  @override
  _UploadConfirmState createState() => _UploadConfirmState();
  File image;

  UploadConfirm({this.image});
}

class _UploadConfirmState extends State<UploadConfirm> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser;
  int selectedIndex;
  String name;
  String pf;
  bool showSpinner = false;

  _uploadPost() async {
    DocumentSnapshot docs =
        await FirebaseFirestore.instance.collection('data').doc(user.uid).get();
    name = docs.data()['name'];
    pf = docs.data()['profilepic'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 18),
                  child: Text(
                    "Upload",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ClipRRect(
                      child: Image.file(
                        widget.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          elevation: 4.0,
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            minWidth: 220.0,
                            height: 60.0,
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Material(
                          elevation: 4.0,
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                          child: MaterialButton(
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              Reference ref = storage
                                  .ref()
                                  .child("images/${widget.image.path}");
                              UploadTask uploadTask = ref.putFile(widget.image);
                              TaskSnapshot taskSnapshot = await uploadTask
                                  .whenComplete(() => print("success"));

                              if (taskSnapshot.state == TaskState.success) {
                                String url =
                                    await taskSnapshot.ref.getDownloadURL();
                                await FirebaseFirestore.instance
                                    .collection('data')
                                    .doc(user.uid)
                                    .update({
                                  'images': FieldValue.arrayUnion([url]),
                                });
                                await _uploadPost();
                                await Database(uid: user.uid)
                                    .uploadPost(url, pf, name);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/fifth', (route) => false);
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            },
                            minWidth: 220.0,
                            height: 60.0,
                            child: Text(
                              'CONFIRM',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
