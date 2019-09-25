import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/Auth/services/taskManagement.dart';
import 'package:todo/tasks.dart';
import 'package:todo/EditTask.dart';
class TaskList extends StatefulWidget {
  final String Pid;

  TaskList({Key key, @required this.Pid}) : super(key: key);

  @override
  _TaskListState createState() => new _TaskListState(Pid: Pid);
/* State<StatefulWidget> createState() {
    return CreateProjectList();
  }*/
}

class _TaskListState extends State<TaskList> {
  final String Pid;

  _TaskListState({Key key, @required this.Pid});
String taskName, taskDescriprion, task_Id, task_assignedTo, taskDeadline,taskDescription,
    taskStatus, taskKind, taskStakes, taskProject, accountabilityPartner, document_ID;
  List colors = [Color(0xffd8815d), Colors.green, Colors.yellow];
  Random random = new Random();

  int index = 0;

  void Save_Task()
  {

  }

  //var  project_list = new ProjectList();

  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    print(Pid);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("Project's Details"),
        backgroundColor: Color(0xffd8815d),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('tasks')
            .where('task_of_project_uid', isEqualTo: Pid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  String projectName = document['task_name'];
                  String first_letter = projectName[0].toUpperCase();
                  return new ListTile(
                    leading: CircleAvatar(
                        backgroundColor: colors[index],
                        // child: Text(document['first_character']),
                        child: Text(first_letter)),
                    title: new Text(document['task_name']),
                    subtitle: new Text(document['task_description']),
                    trailing: RaisedButton(
                      child: Text("Edit"),
                        color: Colors.red,
                        onPressed: (){
                        task_Id= document['task_uid'];
                        Firestore.instance
                            .collection('tasks')
                            .where('task_uid', isEqualTo: task_Id)
                            .snapshots();
                        document_ID = document.documentID;
                        taskName= document['task_name'];
                        taskDescriprion=document['task_description'];
                        task_assignedTo= document['task_assigned_to'];
                        taskDeadline=document['task_deadline'];
                        taskDescription= document['task_description'];
                        taskStatus= document['task_status'] ;
                        taskKind = document['task_kind'];
                        taskStakes= document['task_stakes'];
                        taskProject= document['task_of_project_uid'];
                        accountabilityPartner=document['task_accountability_partner_uid'];
                        print(accountabilityPartner);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Edit_Task(task_Name:taskName, task_Descriprion:taskDescriprion,
                          taskAssignedTo: task_assignedTo, task_Deadline: taskDeadline,task_Status: taskStatus,
                            task_Kind: taskKind, task_Stakes: taskStakes,
                            accountability_Partner: accountabilityPartner, Document_id: document_ID,)));


                        }
                    ),
                  );
                }
                ).toList(),
              );
          }
        },
      ),
    );
  }
}
