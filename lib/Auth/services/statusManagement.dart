import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';

class StatusManagement {
  String user_uid;
  String status_name;
  String status_description;
  String status_uid;

  storeNewStatus(status_name, status_description, user_uid, context) {
    status_uid = randomAlphaNumeric(5);
//    print(uid);

    //TODO: Add status
    Firestore.instance.collection('/status').add({
      'status_uid': status_uid,
      'status_name': status_name,
      'status_description': status_description,
      'status_added_by': user_uid,
      'status_date_added': Timestamp.now(),
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('landingpage');
    }).catchError((e) {
      print(e);
    });
  }
}
