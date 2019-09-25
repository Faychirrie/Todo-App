import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:todo/main.dart';

class ContactList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactListState();
  }
}

class ContactListState extends State<ContactList> {
  String userid;
  List<String> phoneContacts = new List();

  List<String> newContacts = new List();
  String name_saved_as;

  TextEditingController _textController = TextEditingController();

  String query = "";

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  Future<bool> onBackPress() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
    return Future.value(false);
  }

  void getCurrentUser() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        userid = user.uid;
        print(userid);
      }
    });
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permisionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permisionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      Toast.show("permission granted", context);
      getPhoneContactList();
      return permission;
    }
  }

  void getPhoneContactList() async {
    var contacts = await ContactsService.getContacts();
    contacts.forEach((contact) => contact.phones.forEach(
        (phone) => phoneContacts.add(contact.displayName + phone.value)));
//    print(phoneContacts[1]);
    for (int i = 0; i < phoneContacts.length; i++) {
      String newPhone =
          phoneContacts[i].replaceAll(new RegExp(r"\s+\b|\b\s"), "").trim();
      if (newPhone.length >= 9) {
        String newPhoneContact = newPhone.substring(newPhone.length - 8);
        // print(newPhoneContact);
        newContacts.add(newPhoneContact);
      }
    }
//     print(newContacts[0]);
  }

  getContactName() async {
    Stream<QuerySnapshot> snapshot =
        Firestore.instance.collection('users').snapshots();
  }

  @override
  void initState() {
    _getPermission();
    getCurrentUser();
    super.initState();
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    String phoneDB = document['phone'];

    String index;
    String newPhone = phoneDB.trim().substring(phoneDB.length - 8);

    index = phoneContacts
        .indexWhere((phone) => phone.endsWith(newPhone))
        .toString();

    print(newPhone);

    for (int i = 0; i < phoneContacts.length; i++) {
      String newPhoneForDisplay = phoneContacts[i].replaceAll('+', '');
      if (newPhoneForDisplay.length >= 9) {
        String newPhoneContact1 =
            newPhoneForDisplay.substring(newPhoneForDisplay.length - 8);
        if (newPhoneContact1 == newPhone) {
          name_saved_as = newPhoneForDisplay;
        }
        print(name_saved_as);
        // print(newPhoneContact);
      }
    }

//    }

    if (document['uid'] == userid) {
      return Container();
    } else if (!newContacts.contains(newPhone)) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: Image.asset(
                  "assets/logo.png",
                  width: ScreenUtil.getInstance().setWidth(50),
                  height: ScreenUtil.getInstance().setHeight(50),
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Name: $name_saved_as',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'Nickname: ${document['name']}',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 12),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
//                          'About me: ${document['email'] ?? 'Not available'}',
                          'Email: ${document['email'] ?? 'Not available'}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {},
          color: Colors.grey[200],
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    }
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });
//    prefs = await SharedPreferences.getInstance();
//    prefs.clear();
//    prefs.commit();
    await FirebaseAuth.instance.signOut();

    this.setState(() {
      isLoading = false;
    });

//    Navigator.of(context).pushAndRemoveUntil(
//        MaterialPageRoute(builder: (context) => Login()),
//            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Padding(padding: EdgeInsets.all(10.0)),
          Flexible(
            child: Container(
              child: TextField(
                autofocus: false,
                controller: _textController,
                decoration: InputDecoration(
                    hintText: 'search contacts here',
                    hintStyle: TextStyle(
                        color: Colors.grey[200],
                        fontWeight: FontWeight.normal)),
              ),
            ),
          ),
          Material(
            child: new Container(
              // margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  query = _textController.text;
                  if (query != "") {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) =>
//                                contactResults(
//                                    query: query
//                                )));
                  }
                },
                color: Colors.white,
              ),
            ),
            color: Colors.grey,
          ),
        ]),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: Colors.grey,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),
            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            )
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
