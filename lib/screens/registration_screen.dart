import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inert/database/database.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _email;
  String _password;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
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
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1,
                    left: 24,
                    right: 24),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/mainlogo.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 42.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        _email = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
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
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
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
                          borderRadius: BorderRadius.all(Radius.circular(8)),
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
                              final newUser = await _auth
                                  .createUserWithEmailAndPassword(email: _email, password: _password);
                              if(newUser != null){
                                await Database(uid: newUser.user.uid).updateData(newUser.user.email,0);
                                Navigator.pushNamed(context, '/forth');
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          minWidth: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          height: 42.0,
                          child: Text(
                            'NEXT',
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
}
