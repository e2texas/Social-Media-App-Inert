import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inert/screens/profilePost.dart';

class ProfileNew extends StatefulWidget {
  @override
  _ProfileNewState createState() => _ProfileNewState();
}

class _ProfileNewState extends State<ProfileNew> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('data')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            var document = snapshot.data;
            if (document != null) {
              return CustomWidget(
                  document['name'], document['email'], document);
            } else {
              return new CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  var image;

  void setBackgroundImage(File image) async {
    Reference ref = storage.ref().child("background/${image.path}");
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => print("success"));

    if (taskSnapshot.state == TaskState.success) {
      String url = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('data').doc(user.uid).update({
        'background': url,
      });
    } else {
      CircularProgressIndicator();
    }
  }

  _imageFromGallery() async {
    File ig = File(await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((value) => value.path));
    setBackgroundImage(ig);
  }

  _imgFromCamera() async {
    File ig = File(await ImagePicker()
        .getImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.front,
            imageQuality: 50)
        .then((value) => value.path));
    setBackgroundImage(ig);
  }

  bool flag = true;

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
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('data')
                          .doc(user.uid)
                          .update({
                        'background': "",
                      });
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  void _Picker(context) {
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
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('data')
                          .doc(user.uid)
                          .update({
                        'profilepic': "",
                      });
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget CustomWidget(String name, String email, DocumentSnapshot snapshot) {
    List images = snapshot["images"];
    String pf = snapshot["profilepic"];
    String backgroundPic = snapshot["background"];
    print(backgroundPic);
    int itemCount = images.length;
    return Column(children: [
      Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.45,
          ),
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () async {
                _showPicker(context);
              },
              child: Opacity(
                opacity: 0.8,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.37,
                    child: backgroundPic == ""
                        ? Image.asset('images/background.jpg', fit: BoxFit.cover,)
                        : Image.network(
                            backgroundPic,
                            fit: BoxFit.cover,
                          )),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
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
              child: GestureDetector(
                onTap: () async {
                  _Picker(context);
                },
                child: CircleAvatar(
                  child: ClipOval(
                      child: pf != ""
                          ? Image(image: NetworkImage(pf))
                          : Icon(Icons.person)),
                  maxRadius: 68,
                ),
              ),
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          /*SizedBox(
            height: 10,
          ),
          Text(
            email,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),*/
        ],
      ),
      images.isNotEmpty
          ? ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 12,
                );
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10),
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePost(
                                      image: images[index],
                                      pf: pf,
                                      name: name,
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                                image: NetworkImage(images[index]),
                                fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ]),
                      ),
                    ),
                  ),
                );
              },
              itemCount: itemCount,
            )
          : Text(""),
    ]);
  }
}
