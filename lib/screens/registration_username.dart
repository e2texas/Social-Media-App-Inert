import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inert/database/database.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationUsername extends StatefulWidget {
  @override
  _RegistrationUsernameState createState() => _RegistrationUsernameState();
}

class _RegistrationUsernameState extends State<RegistrationUsername> {
  String _userName;
  bool showSpinner = false;
  File image;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, left: 24),
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1,
                    left: 24,
                    right: 24),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
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
                            child: image != null
                                ? CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.grey[100],
                                    child: ClipOval(
                                      child: Image.file(
                                        image,
                                        width: 135,
                                        height: 135,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    maxRadius: 70,
                                    backgroundColor: Colors.grey[200],
                                    child: ClipOval(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  )),
                      ),
                    ),
                    SizedBox(
                      height: 42.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        _userName = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your display name',
                        hintStyle: TextStyle(color: Colors.black),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                if (image != null) {
                                  Reference ref = storage
                                      .ref()
                                      .child("profilePic/${image.path}");
                                  UploadTask uploadTask = ref.putFile(image);
                                  TaskSnapshot taskSnapshot = await uploadTask
                                      .whenComplete(() => print("success"));
                                  String url;
                                  if (taskSnapshot.state == TaskState.success) {
                                    url =
                                        await taskSnapshot.ref.getDownloadURL();
                                  } else {
                                    CircularProgressIndicator();
                                  }
                                  await Database(uid: user.uid)
                                      .updateOtherData(_userName, url);
                                } else {
                                  await Database(uid: user.uid)
                                      .updateName(_userName);
                                }
                                await Database(uid: user.uid).addLikedImages();
                                Navigator.pushNamed(context, '/fifth');
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          height: 42.0,
                          child: Text(
                            'REGISTER',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _imageFromGallery() async {
    File ig = File(await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((value) => value.path));
    setState(() {
      image = ig;
    });
  }

  _imgFromCamera() async {
    File ig = File(await ImagePicker()
        .getImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.front,
            imageQuality: 50)
        .then((value) => value.path));
    setState(() {
      image = ig;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.delete_forever_rounded),
                    title: new Text("Remove"),
                    onTap: () {
                      setState(() {
                        image = null;
                      });
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
