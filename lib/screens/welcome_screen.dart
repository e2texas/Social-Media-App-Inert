import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/back.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/mainlogo.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                Container(
                  color: Colors.black,
                  height: 110,
                  width: 3,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                AutoSizeText(
                  'inert',
                  style: TextStyle(
                    fontSize: 70.0,
                    fontFamily: 'Comforta',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: 25,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Material(
                    elevation: 4.0,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/third');
                      },
                      minWidth: MediaQuery.of(context).size.width * 0.4,
                      height: 54.0,
                      child: Text(
                        'Log In',
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
                      onPressed: () {
                        Navigator.pushNamed(context, '/second');
                      },
                      minWidth: MediaQuery.of(context).size.width * 0.4,
                      height: 54.0,
                      child: Text(
                        'Register',
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
    );
  }
}
