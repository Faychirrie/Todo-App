import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/Auth/services/projectManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateProject extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _CreateProjectState createState() => new _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  _CreateProjectState();
  TextEditingController project_nameController = TextEditingController();
  TextEditingController project_descriptionController = TextEditingController();
  String _project_name;
  String _project_description;
  String uid;
  Save(){
    if(project_descriptionController.text !=null)
    {

    }
  }
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
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
            title: new Text("Create A New Project"),
            backgroundColor: Color(0xffd8815d),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, true),
            )),
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              //child:Image.asset("assets/background.jpg"),
            ),
            Expanded(
              child: Container(),
            ),
          ]),
          SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    /*Text("Create A New Project",
                                style: TextStyle(
                                    fontFamily: "Poppins-Bold",
                                    fontSize: ScreenUtil.getInstance().setSp(40),
                                    letterSpacing: 2,
                                    color: Color(0xffd8815d),
                                    fontWeight: FontWeight.bold)),*/
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(35),
                ),
                Container(
                    width: ScreenUtil.getInstance().setWidth(700),
                    height: ScreenUtil.getInstance().setHeight(600),
                    alignment: Alignment(0.0, 0.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.5, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 20.0),
                        ]),
                    child: Padding(
                        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Column(
                          children: <Widget>[
                            Text("Project Name",
                                style: TextStyle(
                                    fontFamily: "Poppins-Bold",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26))),
                            TextField(
                              controller: project_nameController,
                              onEditingComplete: () {
                                project_nameController.text =_project_name;

                              },
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  hintText: "project name",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(35),
                            ),
                            Text("Description",
                                style: TextStyle(
                                    fontFamily: "Poppins-Bold",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26))),
                            TextField(
                              controller: project_descriptionController,
                              onEditingComplete: () {
                                project_descriptionController.text =_project_description;

                              },
                              maxLines: 8,
                              decoration: InputDecoration(
                                  hintText: "Description",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                            ),
                          ],
                        ))),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(40),
                ),
                InkWell(
                  child: Container(
                    width: ScreenUtil.getInstance().setWidth(330),
                    height: ScreenUtil.getInstance().setHeight(100),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xffd8815d), Color(0xffdff16d)]),
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
                        onTap: (){

                          ProjectManagement().storeNewProject(_project_name,
                                  _project_description, uid, context);
                   },
                        child: Center(
                          child: Text(
                            "Save",
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
          ))
        ]));
  }
}
