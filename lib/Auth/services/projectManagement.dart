import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:todo/ListProjects.dart';

class ProjectManagement {
  String user_uid;
  String project_name;
  String project_description;
  String project_uid;
  String p_name, p_escription;
  String dId;
  String current ;
  final db = Firestore.instance;
  //String id = Firestore.instance.collection("collection_name").document().getId();

//  updateData(p_name,p_description,dId, context) async {
//    await db
//        .collection('projects')
//        .document(dId)
//        .updateData({
//      'project_name': p_name,
//      'project_description':p_description
//        });
//  }

  storeNewProject(project_name, project_description, user_uid, context) {
    project_uid = randomAlphaNumeric(20);
//    print(uid);

    //TODO: Add project
    Firestore.instance.collection('/projects').add({
      'project_uid': project_uid,
      'project_name': project_name,
      'project_description': project_description,
      'project_owner_uid': user_uid,
      'project_date_added': Timestamp.now(),
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('landingpage');
    }).catchError((e) {
      print(e);
    });
  }
}
