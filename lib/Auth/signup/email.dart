import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/Auth/signin/phone.dart';
import 'package:todo/Auth/services/usermanagement.dart';

class EmailSignUp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _EmailSignUpState createState() => new _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  String _name;
  String _email;
  String _phone_no;
  String _password;

  String parse_null_email = null;

  bool _isSelected = false;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  signIn() async {}

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black))
            : Container(),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Image.asset("assets/working.png"),
              ),
              Expanded(
                child: Container(),
              ),
// Image below
//              Image.asset("assets/logo.png")
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/logo.png",
                        width: ScreenUtil.getInstance().setWidth(110),
                        height: ScreenUtil.getInstance().setHeight(110),
                      ),
                      Text("Get More Done",
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: ScreenUtil.getInstance().setSp(40),
                              letterSpacing: 2,
                              color: Color(0xffd8815d),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(90),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(700),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Sign Up",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(45),
                                  fontFamily: "Poppins-Bold",
                                  letterSpacing: .6)),
                          SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30)),
                          Text("Name",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold",
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            decoration: InputDecoration(
                                icon: new Icon(Icons.person, size: 15),
                                hintText: "Enter Name ",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                          Text("Email",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold",
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            decoration: InputDecoration(
                                icon: new Icon(Icons.email, size: 15),
                                hintText: "Enter Email ",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                          Text("Phone",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold",
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            decoration: InputDecoration(
                                icon: new Icon(Icons.phone, size: 15),
                                hintText: "Enter Phone Number ",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            onChanged: (value) {
                              setState(() {
                                _phone_no = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                          Text("Password",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold",
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                icon: new Icon(Icons.lock, size: 15),
                                hintText: "Enter Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                          )
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.end,
//                            children: <Widget>[
//                              Text("Forgot Password?",
//                                  style: TextStyle(
//                                      color: Color(0xffd8815d),
//                                      fontFamily: "Poppins-Medium",
//                                      fontSize:
//                                      ScreenUtil.getInstance().setSp(28)))
//                            ],
//                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(width: 8.0),
                          Text("Sign me In",
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: "Poppins-Medium"))
                        ],
                      ),
                      InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(330),
                          height: ScreenUtil.getInstance().setHeight(100),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xffd8815d),
                                Color(0xffdff16d)
                              ]),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xffd8815d).withOpacity(.3),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
//                        onTap: () => Toast.show("I was developing the wrong button", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM),
//                              onTap: () {
//                                print('My bb wa tt');
//                              },
//                              onTap: verifyPhone,
                              onTap: () {
                                //TODO: Function to login
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _email, password: _password)
                                    .then((signedInUser) {
                                  UserManagement().storeNewUser(
                                      signedInUser,
                                      _name,
                                      _phone_no,
                                      parse_null_email,
                                      context);
                                  print(signedInUser);
                                }).catchError((e) {
                                  print(e);
                                });
                              },
                              child: Center(
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 18,
                                      letterSpacing: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(90),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneLogin()),
                          );
                        },
                        child: Text("Use Phone Login",
                            style: TextStyle(
                                color: Color(0xffd8815d),
                                fontSize: 12.0,
                                fontFamily: "Poppins-Medium")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
