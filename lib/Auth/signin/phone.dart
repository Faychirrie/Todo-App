import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Own imports
//Own imports Widgets
import 'package:todo/main.dart';
import 'package:todo/Auth/services/userManagement.dart';

class PhoneLogin extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _PhoneLogin createState() => new _PhoneLogin();
}

class _PhoneLogin extends State<PhoneLogin> {
  bool _isSelected = false;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  String _name;
  String _email;
  String phoneNo;
  String smsCode;
  String verificationId;

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String verId) {
      this.verificationId = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed In');
      });
    };
    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential user) {
      print("Verified");
    };
    final PhoneVerificationFailed verificationFail = (AuthException exception) {
      print('${exception.message}');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFail,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieval);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter sms Code'),
            content: TextField(onChanged: (value) {
              this.smsCode = value;
            }),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    print(user);
                    UserManagement()
                        .storeNewUser(user, _name, phoneNo, _email, context);
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    } else {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);

    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      UserManagement().storeNewUser(user, _name, phoneNo, _email, context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }).catchError((e) => print(e));
  }

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
                    height: ScreenUtil.getInstance().setHeight(100),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(600),
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
                          Text("Phone Login",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(45),
                                  fontFamily: "Poppins-Bold",
                                  letterSpacing: .6)),
                          SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30)),
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
                                hintText: "Enter phone number",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            onChanged: (value) {
                              this.phoneNo = value;
                            },
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                              onTap: verifyPhone,
//                              onTap: () {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => Homepage()),
//                                );
//                              },
                              child: Center(
                                child: Text(
                                  "SignIn",
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
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
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
