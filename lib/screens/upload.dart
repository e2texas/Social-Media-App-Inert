import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inert/screens/uploadConfirm.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  File image;

  @override
  void initState() {
    super.initState();
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

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 18),
                  child: Text(
                    "Select",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 100,left: 8),
                  child: Container(
                    child: new Wrap(
                      children: <Widget>[
                        new ListTile(
                            leading: new Icon(
                              Icons.photo_library,
                              color: Colors.black,
                              size: 30,
                            ),
                            title: new Text(
                              'Photo Library',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                            onTap: () async {
                              await _imageFromGallery();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UploadConfirm(image: image)));
                            }),
                        new ListTile(
                          leading: new Icon(
                            Icons.photo_camera,
                            color: Colors.black,
                            size: 30,
                          ),
                          title: new Text(
                            'Camera',
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                          onTap: () async {
                            await _imgFromCamera();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UploadConfirm(image: image)));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
