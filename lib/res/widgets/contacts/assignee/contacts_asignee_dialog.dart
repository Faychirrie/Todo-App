import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/main.dart';
import 'package:todo/res/model/contacts/db_contact.dart';
import 'package:todo/res/model/contacts/model_contact.dart';

Dialog showAssigneeContactsDialog(
  BuildContext context, {
  @required ValueChanged<UserContact> onSelectedAssignee,
}) {
  final dialog = Dialog(
    child: ContactsDialogForAssignee(onSelectedAssignee: onSelectedAssignee),
  );
  showDialog(context: context, builder: (BuildContext context) => dialog);
}

class ContactsDialogForAssignee extends StatefulWidget {
  final ValueChanged<UserContact> onSelectedAssignee;

  const ContactsDialogForAssignee({this.onSelectedAssignee}) : super();

  @override
  _ContactsDialogForAssigneeState createState() =>
      _ContactsDialogForAssigneeState();
}

class _ContactsDialogForAssigneeState extends State<ContactsDialogForAssignee> {
  //Variables for contacts start here
  String userid;

  bool isLoading = false;

  UserContact myContactsController;

  @override
  void initState() {
    super.initState();
  }

  //Contacts Dialog starts here
  Future<bool> onBackPress() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select Assignee",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Text(
                "List pulled from your contacts",
                style: TextStyle(color: Colors.white, fontSize: 9.0),
              ),
            ]),
        backgroundColor: Color(0xffd8815d),
      ),
      body: FutureBuilder<List<UserContact>>(
        future: DBProvider.db.getAllUserContacts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserContact>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                UserContact item = snapshot.data[index];
                String user_saved_name = item.saved_contact_name;
                String user_user_name = item.firestore_name;
                String user_user_number = item.saved_contact_phone_number;
                return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    child: Container(
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Material(
                              child: Image.asset(
                                "assets/logo.png",
                                width: ScreenUtil.getInstance().setWidth(50),
                                height: ScreenUtil.getInstance().setHeight(50),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            Flexible(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'Name: $user_saved_name',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 15),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 0.0, 0.0, 5.0),
                                    ),
                                    Container(
                                      child: Text(
                                        'Username: $user_user_name',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 0.0, 0.0, 5.0),
                                    ),
                                    Container(
                                      child: Text(
//                          'About me: ${document['email'] ?? 'Not available'}',
                                        'Phone number: $user_user_number',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 0.0, 0.0, 0.0),
                                    )
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 20.0),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            myContactsController = item;
                          });
                          widget.onSelectedAssignee(myContactsController);
                          Navigator.of(context).pop();
                        },
                        color: Colors.grey[200],
                        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      margin: EdgeInsets.only(
                          bottom: 3.5, left: 5.0, right: 5.0, top: 3.0),
                    ));
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
