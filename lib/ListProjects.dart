import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/project.dart';
import 'package:todo/ListTasks.dart';
import 'package:todo/edit_projects.dart';
class ProjectList extends StatefulWidget {
  //final String pname;
  //final String pdescription;
  //ProjectList(this.pname, this.pdescription);

  @override
  _ProjectListState createState() => new _ProjectListState();

}

class _ProjectListState extends State<ProjectList> {
  List colors = [Color(0xffd8815d), Colors.green, Colors.yellow];
  Random random = new Random();

  int index = 0;
  String project_id;
  DocumentSnapshot _currentDocument;
  String name, description, Document_id;

  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("All Projects"),
        backgroundColor: Color(0xffd8815d),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('projects').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  String projectName = document['project_name'];
                  String first_letter = projectName[0].toUpperCase();
                  return new ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colors[index],
                        child: Text(first_letter),
                      ),
                      title: new Text(document['project_name']),
                      subtitle: new Text(document['project_description']),


                      trailing: RaisedButton(

                     child: Text("Edit"),
                      color: Colors.red,

                      onPressed: ()  {
                        project_id = document['project_uid'];
                        String Did = document.documentID;
                        Document_id = Did;
                        print(Document_id);
                        Firestore.instance
                            .collection('project')
                            .where('project_uid', isEqualTo: project_id)
                            .snapshots();
                        name = document['project_name'];
                        description= document['project_description'];

                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProject(pname: name, pdescription: description, pid: project_id,document_id: Document_id)));

                            }
                        ),


                      onTap: () {
                        project_id = document['project_uid'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskList(Pid: project_id)),

                        );
                      }
                      );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
