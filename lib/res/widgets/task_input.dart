import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * Created by Mahmud Ahsan
 * https://github.com/mahmudahsan
 */
import 'package:flutter/material.dart';
import 'package:todo/tasks.dart';

class TaskInput extends StatefulWidget {
  final Function onSubmitted;

  TaskInput({@required Function this.onSubmitted});

  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
//  bool isSwitched = true;
//
  TextEditingController textEditingController = TextEditingController();

//
//  var selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
              width: 40,
              child: GestureDetector(
                onTap: () {
                  print("onTap called.");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateTask()),
                  );
//                  _displayDialog(context);
//                  showDialog(
//                      context: context,
//                      builder: (context) {
//                        return Dialog(
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(12))
//                          ),
//                          child: Container(
//                            child: SingleChildScrollView(
//                              padding: const EdgeInsets.all(12.0),
//                              child: Column(
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  Text("Add Task",
//                                      style: TextStyle(
//                                          fontWeight: FontWeight.bold,
//                                          fontSize: 16)),
//                                  Divider(
//                                    color: Colors.grey[300],
//                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
//                                  Text("Task Name"),
////                                  new Align(alignment: Alignment.centerLeft, child: new Text("Task Name")),
//                                  TextField(
//                                    decoration: InputDecoration(
//                                        hintText: "Enter Task Name",
//                                        hintStyle: TextStyle(
//                                            color: Colors.grey,
//                                            fontSize: 12.0)),
//                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
//                                  Text("Assign to"),
//                                  TextField(
//                                    decoration: InputDecoration(
//                                        hintText: "Enter Asignee Name",
//                                        hintStyle: TextStyle(
//                                            color: Colors.grey,
//                                            fontSize: 12.0)),
//                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
//                                  Text("Task due by"),
//                                  TextField(
//                                    decoration: InputDecoration(
//                                        hintText: "Tap to pick date",
//                                        hintStyle: TextStyle(
//                                        color: Colors.grey,
//                                        fontSize: 12.0)),
//                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
//                                  Text("Description"),
//                                  TextField(
//                                    onChanged: (value) {
//                                      setState(() {});
//                                    },
//                                    maxLines: 4,
//                                    decoration: InputDecoration(
//                                        hintText: "Description",
//                                        hintStyle: TextStyle(
//                                            color: Colors.grey,
//                                            fontSize: 12.0)),
//                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    children: <Widget>[
//                                      Text("Public/Private (Default: Private)"),
////                                      new Align(alignment: Alignment.centerLeft, child: new Text("Nature (Public/Private)")),
//                                      Switch(
//                                        value: isSwitched,
//                                        onChanged: (value) {
//                                          setState(() {
//                                            isSwitched = value;
//                                          });
//                                        },
//                                        activeTrackColor: Colors.red[100],
//                                        activeColor: Colors.red[300],
//                                      ),
//                                    ],
//                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    children: <Widget>[
//                                      Text("Status "),
//                                      StreamBuilder<QuerySnapshot>(
//                                          stream: Firestore.instance.collection("status").snapshots(),
//                                          builder: (context, snapshot) {
//                                            if (!snapshot.hasData)
//                                              const Text("Loading.....");
//                                            else {
//                                              List<DropdownMenuItem> currencyItems = [];
//                                              for (int i = 0; i < snapshot.data.documents.length; i++) {
//                                                DocumentSnapshot snap = snapshot.data.documents[i];
//                                                currencyItems.add(
//                                                  DropdownMenuItem(
//                                                    child: Text(
//                                                      snap.documentID,
//                                                      style: TextStyle(color: Color(0xff11b719)),
//                                                    ),
//                                                    value: "${snap.documentID}",
//                                                  ),
//                                                );
//                                              }
//                                              return Row(
//                                                mainAxisAlignment: MainAxisAlignment.center,
//                                                children: <Widget>[
//                                                  SizedBox(width: 50.0),
//                                                  DropdownButton(
//                                                    items: currencyItems,
//                                                    onChanged: (currencyValue) {
//                                                      final snackBar = SnackBar(
//                                                        content: Text(
//                                                          'Selected value is $currencyValue',
//                                                          style: TextStyle(color: Color(0xff11b719)),
//                                                        ),
//                                                      );
//                                                      Scaffold.of(context).showSnackBar(snackBar);
//                                                      setState(() {
//                                                        selectedCurrency = currencyValue;
//                                                      });
//                                                    },
//                                                    value: selectedCurrency,
//                                                    isExpanded: false,
//                                                    hint: new Text(
//                                                      "Choose Currency Type",
//                                                      style: TextStyle(color: Color(0xff11b719)),
//                                                    ),
//                                                  ),
//                                                ],
//                                              );
//                                            }
//                                          }),
//                                    ],
//                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
//                                  Text("Stakes"),
//                                  TextField(
//                                    decoration: InputDecoration(
//                                        hintText: "Add stakes of the task",
//                                        hintStyle: TextStyle(
//                                            color: Colors.grey,
//                                            fontSize: 12.0)),
//                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    children: <Widget>[
//                                      Text("Project ID "),
////                                      new Align(alignment: Alignment.centerLeft, child: new Text("Nature (Public/Private)")),
//                                      DropdownButton(
//                                        items: <DropdownMenuItem>[],
//                                      ),
//                                    ],
//                                  ),
//
////                                  Text("Project ID)"),
////                                  TextField(
////                                    controller: _textFieldController,
////                                    decoration: InputDecoration(
////                                        hintText: "Belong to ptoject"),
////                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
//                                  Text("Accountability Partner)"),
//                                  TextField(
//                                    decoration: InputDecoration(
//                                        hintText:
//                                            "Start typing AP's phone number",
//                                        hintStyle: TextStyle(
//                                            color: Colors.grey,
//                                            fontSize: 12.0)),
//                                  ),
//                                  SizedBox(
//                                    height: 24,
//                                  ),
////                                  Divider(
////                                    color: Colors.red[300],
////                                  ),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.end,
//                                    children: <Widget>[
//                                      FlatButton(
//                                        child: new Text('CANCEL'),
//                                        onPressed: () {
//                                          Navigator.of(context).pop();
//                                        },
//                                      ),
//                                      FlatButton(
//                                        child: new Text('DONE',
//                                            style:
//                                                TextStyle(color: Colors.white)),
//                                        color: Colors.red[300],
//                                        onPressed: () {
//                                          Navigator.of(context).pop();
//                                        },
//                                      ),
//                                    ],
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        );
//                      });
                },
                child: Icon(
                  Icons.add,
                  color: Color(0xffca3e47),
                  size: 30,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                    hintText: 'What do you want to do?',
                    border: InputBorder.none),
                textInputAction: TextInputAction.done,
                controller: textEditingController,
                onEditingComplete: () {
                  widget.onSubmitted(controller: textEditingController);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
