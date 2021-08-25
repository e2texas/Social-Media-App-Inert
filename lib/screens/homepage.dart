import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inert/screens/home.dart';
import 'package:inert/screens/profileNew.dart';
import 'package:inert/screens/upload.dart';
import 'package:line_icons/line_icons.dart';

import 'Liked.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int selectedIndex = 0;
  final _pageOptions = [
    Home(),
    Upload(),
    Liked(),
    ProfileNew(),
  ];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Likes',
      style: optionStyle,
    ),
    Text(
      'Upload',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  Future<bool> _onWillPop() {
    return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              elevation: 4.0,
                  backgroundColor: Colors.white,
                  title: Text(
                    "Are you sure?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  content: Text(
                    "Do you want to exit the app",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    new MaterialButton(
                      color: Colors.black,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("No"),
                    ),
                    new MaterialButton(
                      color: Colors.black,
                      onPressed: () => exit(0),
                      child: Text("Yes"),
                    ),
                  ],
                )) ??
        false;
  }

  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _pageOptions[selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  rippleColor: Colors.grey[300],
                  hoverColor: Colors.grey[100],
                  gap: 8,
                  activeColor: Colors.white,
                  color: Colors.black,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.black,
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: LineIcons.upload,
                      text: 'Upload',
                    ),
                    GButton(
                      icon: LineIcons.heart,
                      text: 'Likes',
                    ),
                    GButton(
                      icon: LineIcons.user,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

/* */
