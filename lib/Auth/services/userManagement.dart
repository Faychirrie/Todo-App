import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  String uid;

  storeNewUser(userResults, String name, String phone,
      String email_from_phone_verification, context) {
//    print(userResults.user.uid);
//    print(userResults.user.email);
    if (email_from_phone_verification != null) {
      FirebaseAuth.instance.currentUser().then((val) {
        this.uid = val.uid;
      }).catchError((e) {
        print(e);
      });

      print(userResults);
      //TODO: If Phone registration
      Firestore.instance.collection('/users').add({
        'uid': userResults.uid,
        'name': name,
        'phone': phone,
        'email': email_from_phone_verification,
        'reg_date': Timestamp.now()
      }).then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('landingpage');
      }).catchError((e) {
        print(e);
      });
    } else {
      //TODO: If Email registration
      print(userResults);
      Firestore.instance.collection('/users').add({
        'uid': userResults.user.uid,
        'name': name,
        'phone': phone,
        'email': userResults.user.email,
        'reg_date': Timestamp.now()
      }).then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('landingpage');
      }).catchError((e) {
        print(e);
      });
    }
  }
}
