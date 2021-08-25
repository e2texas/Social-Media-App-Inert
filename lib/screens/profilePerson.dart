import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inert/screens/post.dart';

class profilePerson extends StatefulWidget {
  @override
  final String names;
  final String profilePic;
  profilePerson({Key key ,this.names,this.profilePic}):super(key: key);
  _profilePersonState createState() => _profilePersonState();
}

class _profilePersonState extends State<profilePerson> {
  int itemCount = 5;
  final List<String> imagePath = [
    'images/1st.png',
    'images/2nd.jpg',
    'images/2nd.png',
    'images/3rd.jpg',
    'images/4th.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                  ),
                  Opacity(
                    opacity: 0.80,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 280,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/3rd.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    left: MediaQuery.of(context).size.width * 0.32,
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
                      child: CircleAvatar(
                        backgroundImage: AssetImage(widget.profilePic),
                        maxRadius: 70,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.names,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                 /* Text(
                     widget.
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),*/
                ],
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 12,
                  );
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left:10.0,right: 10.0,bottom: 10),
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      elevation: 8,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Post(
                                    image: imagePath[index],
                                    pf: widget.profilePic,
                                    name: widget.names,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 210,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: AssetImage(imagePath[index]),
                                  fit: BoxFit.fill),
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
            ],
          ),
        ));
  }
}
