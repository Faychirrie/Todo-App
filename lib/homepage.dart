import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/main.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String uid;

  getUid() {}

  @override
  void initState() {
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("Karibu Home"),
      ),
      body: Center(
        child: Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('You are now logged in as ${uid}'),
              SizedBox(
                height: 15.0,
              ),
              new OutlineButton(
                borderSide: BorderSide(
                    color: Colors.red, style: BorderStyle.solid, width: 3.0),
                child: Text('Logout'),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((action) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
