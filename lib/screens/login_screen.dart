import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    var _usernameController = TextEditingController();
    var _passwordController = TextEditingController();
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
                  "Log in",
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
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                              showSpinner=true;
                            });
                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _email, password: _password);
                              if( user != null){
                                Navigator.pushNamed(context, '/fifth');
                              }
                              setState(() {
                                showSpinner=false;
                              });
                            } on Exception catch (e) {
                              print(e);
                            }
                          },
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          height: 42.0,
                          child: Text(
                            "LOG IN",
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
