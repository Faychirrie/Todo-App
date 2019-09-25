import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:todo/Auth/services/taskManagement.dart';
import 'package:todo/res/model/contacts/model_contact.dart';
import 'package:todo/res/widgets/contacts/ap/contacts_ap_dialog.dart';
import 'package:todo/res/widgets/contacts/assignee/contacts_asignee_dialog.dart';
import 'package:todo/res/widgets/date/notifcation_dialog.dart';

 class Edit_Task extends StatefulWidget {
  final task_Name, task_Descriprion, taskId, taskAssignedTo, task_Deadline,
      task_Status, task_Kind, task_Stakes, task_Project, accountability_Partner, Document_id;


  Edit_Task(
      {Key key, this.task_Name, this.task_Descriprion, this.taskId, this.taskAssignedTo,
        this.task_Deadline, this.task_Status, this.task_Kind, this.task_Stakes,
        this.task_Project, this.accountability_Partner, this.Document_id
      })
      : super(key: key);
  @override
  _Edit_TaskState createState() => _Edit_TaskState(task_Name: task_Name,
      task_Descriprion: task_Descriprion,
      taskId: taskId,
      task_Deadline: task_Deadline,
      taskAssignedTo: taskAssignedTo,
      task_Status: task_Status,
      task_Kind: task_Kind,
      task_Stakes: task_Stakes,
      task_Project: task_Project,
      accountability_Partner: accountability_Partner, Document_id:Document_id);

}

class _Edit_TaskState extends State<Edit_Task> {
  final task_Name, task_Descriprion, taskId, taskAssignedTo,
      task_Deadline, task_Status, task_Kind, task_Stakes, task_Project, accountability_Partner, Document_id;
  _Edit_TaskState({Key key, this.task_Name, this.task_Descriprion,this.taskId, this.taskAssignedTo,
    this.task_Deadline, this.task_Status, this.task_Kind,this.task_Stakes, this.task_Project,
    this.accountability_Partner, this.Document_id});
  bool isSwitched = true;

  var selectedStatus;
  var selectedProject;

  String uid;

  List<DropdownMenuItem> statusItems;
  List<DropdownMenuItem> projectsItems;

  DateTime selectedDate = DateTime.now();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  String sampleTime;
  var myContactsController = TextEditingController();
  var taskNameController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  var myAssigneeContactsController = TextEditingController();
  var timecontroller = TextEditingController();
  var taskStatusController = TextEditingController();
  var taskKindContactsController = TextEditingController();
  var taskStakescontroller = TextEditingController();
  var taskProjectController = TextEditingController();
  var APController = TextEditingController();

  UserContact selectedUserAP;
  UserContact selectedAssignee;

  String _task_name;
  var _task_deadline;
  String _task_description;
  String _task_kind = "private";
  String _task_status;
  String _task_stakes;
  String _task_belongs_to_project_uid;
  String _task_accountability_partner_uid;
  String _task_assignee_uid;

  @override
  void initState() {
    print(task_Deadline);
    taskNameController.text = task_Name;
    taskDescriptionController.text =task_Descriprion;
    //selectedStatus = task_Status;
    taskStakescontroller.text = task_Stakes;
    //_task_belongs_to_project_uid = task_Project;
    timecontroller.text = task_Deadline;
    myAssigneeContactsController.text = taskAssignedTo;
    //selectedStatus = task_Status;
    myContactsController.text = accountability_Partner;
    sampleTime = dateFormat.format(selectedDate);

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
  _updateData() async {
    await Firestore.instance
        .collection('tasks')
        .document(Document_id)
        .updateData({
      'task_name': taskNameController.text,
      //'task_belongs_to_user': user,
      'task_assigned_to': myAssigneeContactsController.text,
      //Convert deadline to date timestamp
      'task_deadline':timecontroller.text ,
      'task_description': taskDescriptionController.text,
      'task_status': _task_status,
      'task_kind': _task_kind,
      'task_stakes': taskStakescontroller.text,
      'task_of_project_uid': _task_belongs_to_project_uid,
      'task_accountability_partner_uid':myContactsController.text,

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
          title: new Text(task_Name),
          backgroundColor: Color(0xffd8815d),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          )),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
//                    Text("Add Task",
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            fontSize: 16)),
//                    Divider(
//                      color: Colors.grey[300],
//                    ),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Task Name"),
//                                  new Align(alignment: Alignment.centerLeft, child: new Text("Task Name")),
                  TextField(
                    controller: taskNameController,
                    decoration: InputDecoration(
                        hintText: "Enter Task Name",
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 12.0)),
                    onChanged: (value) {
                      setState(() {
                        _task_name = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Assign to"),
                  TextField(
                    onTap: () {
                      //TODO: Add show dialog method here
                      Toast.show("Tap list to select Assignee", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      showAssigneeContactsDialog(context,
                          onSelectedAssignee: (selectedAssignee) {
                            setState(() {
                              this.selectedAssignee = selectedAssignee;
                              myAssigneeContactsController.text =
                                  selectedAssignee.saved_contact_name;
                              _task_assignee_uid =
                                  selectedAssignee.firestore_user_uid;
                              print("Assignee Uid: $_task_assignee_uid");
                            });
                          });
                    },
                    readOnly: true,
                    controller: myAssigneeContactsController,
                    decoration: InputDecoration(
                        icon: new Icon(Icons.person_outline, size: 18),
                        hintText: "Click to select an Assignee",
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 12.0)),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Task due by"),
                  TextField(
                    onTap: () async {
                      showDateTimeDialog(context, initialDate: selectedDate,
                          onSelectedDate: (selectedDate) {
                            setState(() {
                              this.selectedDate = selectedDate;
                              timecontroller.text = dateFormat.format(selectedDate);
                              _task_deadline = timecontroller.text;
                            });
                          });
                    },
                    readOnly: true,
                    controller: timecontroller,
                    decoration: InputDecoration(
                        icon: new Icon(Icons.calendar_today, size: 18),
//                          prefixIcon: Icon(Icons.calendar_today),
                        hintText:
                        "Tap to pick due date(Deadline) e.g.$sampleTime",
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 12.0)),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Description"),
                  TextField(
                    controller: taskDescriptionController,
                    onChanged: (value) {
                      setState(() {
                        _task_description = value;
                      });
                    },
                    maxLines: 4,
                    decoration: InputDecoration(
                        hintText: "Description",
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 12.0)),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Public/Private (Default: Private)"),
//                                      new Align(alignment: Alignment.centerLeft, child: new Text("Nature (Public/Private)")),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                          if (isSwitched != true) {
                            _task_kind = "public";
                          } else {
                            _task_kind = "private";
                          }
                        },
                        activeTrackColor: Colors.red[100],
                        activeColor: Color(0xffd8815d),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Status "),
                      StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("status")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              const Text("Loading.....");
                            else {
                              statusItems = [];
                              for (int index = 0;
                              index < snapshot.data.documents.length;
                              index++) {
                                DocumentSnapshot snap =
                                snapshot.data.documents[index];
                                statusItems.add(
                                  DropdownMenuItem(
                                    child: Text(
                                      snap["status_name"],
                                      style:
                                      TextStyle(color: Color(0xffd8815d)),
                                    ),
                                    value: "${snap["status_uid"]}",
                                  ),
                                );
                              }
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 50.0),
                                DropdownButton(
                                  items: statusItems,
                                  onChanged: (statusValue) {
                                    _task_status = statusValue;
//                                      final snackBar = SnackBar(
//                                        content: Text(
//                                          'Selected uid value is $statusValue',
//                                          style: TextStyle(color: Color(0xffd8815d)),
//                                        ),
//                                      );
//                                      Scaffold.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      selectedStatus = statusValue;
                                    });
                                  },
                                  value: selectedStatus,
                                  isExpanded: false,
                                  hint: new Text(
                                    "Choose Status Type",
                                    style: TextStyle(color: Color(0xffd8815d)),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Stakes"),
                  TextField(
                    controller: taskStakescontroller,
                    onChanged: (value) {
                      setState(() {
                        _task_stakes = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Add stakes of the task",
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 12.0)),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Task of Project"),
//                                      new Align(alignment: Alignment.centerLeft, child: new Text("Nature (Public/Private)")),
                      StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("projects")
                              .snapshots(),
                          builder: (context, pSnapshot) {
                            if (!pSnapshot.hasData)
                              const Text("Loading.....");
                            else {
                              projectsItems = [];
                              for (int index = 0;
                              index < pSnapshot.data.documents.length;
                              index++) {
                                DocumentSnapshot snap =
                                pSnapshot.data.documents[index];
                                projectsItems.add(
                                  DropdownMenuItem(
                                    child: Text(
                                      snap["project_name"],
                                      style:
                                      TextStyle(color: Color(0xffd8815d)),
                                    ),
                                    value: "${snap['project_uid']}",
                                  ),
                                );
                              }
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 50.0),
                                DropdownButton(
                                  items: projectsItems,
                                  onChanged: (projectValue) {
                                    _task_belongs_to_project_uid = projectValue;
//                                      final snackBar = SnackBar(
//                                        content: Text(
//                                          'Selected project_uid value is $projectValue',
//                                          style: TextStyle(color: Color(0xffd8815d)),
//                                        ),
//                                      );
//                                      Scaffold.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      selectedProject = projectValue;
                                    });
                                  },
                                  value: selectedProject,
                                  isExpanded: false,
                                  hint: new Text(
                                    "Choose Project Type",
                                    style: TextStyle(color: Color(0xffd8815d)),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ],
                  ),

//                                  Text("Project ID)"),
//                                  TextField(
//                                    controller: _textFieldController,
//                                    decoration: InputDecoration(
//                                        hintText: "Belong to ptoject"),
//                                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Accountability Partner"),
                  TextField(
                    onTap: () {
                      //TODO: Add show dialog method here
                      Toast.show("Tap list to select an AP", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      showAPContactsDialog(context,
                          onSelectedAP: (selectedUserAP) {
                            setState(() {
                              this.selectedUserAP = selectedUserAP;
                              myContactsController.text =
                                  selectedUserAP.saved_contact_name;
                              _task_accountability_partner_uid =
                                  selectedUserAP.firestore_user_uid;
                              print("AP Uid: $_task_accountability_partner_uid");
                            });
                          });
                    },
                    controller: myContactsController,
                    readOnly: true,
                    decoration: InputDecoration(
                        icon: new Icon(Icons.verified_user, size: 18),
                        hintText: "Click to select an Accountability partner",
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 12.0)),
                  ),
                  SizedBox(
                    height: 48,
                  ),
//                                  Divider(
//                                    color: Colors.red[300],
//                                  ),
                ],
              ),
            ),
          ),
//            Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                crossAxisAlignment: CrossAxisAlignment.end,
//                children: <Widget>[
//                  FlatButton(
//                    child: new Text('CANCEL'),
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                  ),
//                  FlatButton(
//                    child: new Text('DONE',
//                        style:
//                        TextStyle(color: Colors.white)),
//                    color: Colors.red[300],
//                    onPressed: () {
//                      TaskManagement().storeNewTask(_task_name, _task_deadline, _task_description, _task_kind, _task_status, _task_stakes, _task_belongs_to_project_uid, uid, _task_accountability_partner_uid, _task_assignee_uid, context);
//                    },
//                  ),
//                ],
//              ),
//            )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.save),
        label: const Text('Save task'),
        backgroundColor: Color(0xffd8815d),
        onPressed:_updateData,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
//        hasNotch: false,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
