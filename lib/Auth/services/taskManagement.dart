import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';

class TaskManagement {
  String user_uid;
  String task_uid;
  String task_name;
  String task_belongs_to_user_uid;
  String task_assigned_to;
  var task_deadline_date;
  String task_description;
  String task_status;
  String task_kind;
  String task_stakes;
  String task_belongs_to_project_uid;
  String task_accountability_partner_uid;

  SelectAll (taskId, context)
  {
  }
//  storeNewTask(task_name, task_description, task_uid, context){
  storeNewTask(
      task_name,
      task_deadline_date,
      task_description,
      task_kind,
      task_status,
      task_stakes,
      task_belongs_to_project_uid,
      user_uid,
      task_accountability_partner_uid,
      task_assigned_to,
      BuildContext context) {
    task_uid = randomAlphaNumeric(5);
//    print(uid);


    //TODO: Add Task
    Firestore.instance.collection('/tasks').add({
      'task_uid': task_uid,
      'task_name': task_name,
      'task_belongs_to_user': user_uid,
      'task_assigned_to': task_assigned_to,
      //Convert deadline to date timestamp
      'task_deadline': DateTime.parse(task_deadline_date),
      'task_description': task_description,
      'task_status': task_status,
      'task_kind': task_kind,
      'task_stakes': task_stakes,
      'task_of_project_uid': task_belongs_to_project_uid,
      'task_accountability_partner_uid': task_accountability_partner_uid,
      'task_date_added': Timestamp.now(),
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('landingpage');
    }).catchError((e) {
      print(e);
    });
  }
}
