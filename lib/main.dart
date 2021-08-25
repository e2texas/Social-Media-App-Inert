import 'package:firebase_auth/firebase_auth.dart';
import 'package:inert/screens/Liked.dart';
import 'package:inert/screens/home.dart';
import 'package:inert/screens/homepage.dart';
import 'package:inert/screens/post.dart';
import 'package:inert/screens/profileNew.dart';
import 'package:inert/screens/registration_username.dart';
import 'package:flutter/material.dart';
import 'package:inert/screens/upload.dart';
import 'package:inert/screens/welcome_screen.dart';
import 'package:inert/screens/login_screen.dart';
import 'package:inert/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Inert());}

class Inert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/' : '/fifth',
      routes: {
        '/' : (context) => WelcomeScreen(),
        '/second' : (context) => RegistrationScreen(),
        '/third' : (context) => LoginScreen(),
        '/forth' : (context) => RegistrationUsername(),
        '/fifth' : (context) => HomePage(),
        '/sixth' : (context) => Post(),
        '/seven' : (context) => Home(),
        'eight' : (context) => Upload(),
        'ninth' : (context) => Liked(),
        'tenth' : (context) => ProfileNew(),
      },
    );
  }
}
