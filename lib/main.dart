import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:todo/Auth/signin/phone.dart';
import 'package:todo/Auth/signin/email.dart';
import 'package:todo/Auth/signup/email.dart';
import 'package:todo/project.dart';
import 'package:todo/res/constants.dart';
import 'package:todo/res/model/contacts/db_contact.dart';
import 'package:todo/res/model/contacts/model_contact.dart';
import 'package:todo/res/model/model.dart' as Model;
import 'package:todo/res/model/db_wrapper.dart';
import 'package:todo/res/utils/utils.dart';
import 'package:todo/res/widgets/done.dart';
import 'package:todo/res/widgets/header.dart';
import 'package:todo/res/widgets/popup.dart';
import 'package:todo/res/widgets/task_input.dart';
import 'package:todo/res/widgets/todo.dart';
import 'package:todo/status.dart';
import 'package:todo/tasks.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        'landingpage': (BuildContext context) => MyApp(),
        'phoneLogin': (BuildContext context) => PhoneLogin(),
        'emailLogin': (BuildContext context) => EmailLogin(),
        'emailSignUp': (BuildContext context) => EmailSignUp(),
        'task': (BuildContext context) => CreateTask(),
        'project': (BuildContext context) => CreateProject(),
        'status': (BuildContext context) => CreateStatus()
      },
      theme: ThemeData.light().copyWith(
        backgroundColor: Color(0xfffff5eb),
      ),
      title: kAppTitle,
    ));
//
//class TodosApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//
//
//      home: HomeScreen(),
//    );
//  }
//}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController _pageController = PageController();

  double currentPage = 0;

  String uid;

  //TODO: Global variables for getting users
  String userid;
  List<String> phoneContacts = new List();
  List<String> newPhoneContacts = new List();
  DocumentSnapshot document;
  List<DocumentSnapshot> documentsList;
  String name_saved_as;
  String phone_saved_as;

  String userUidFirebase;

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
    _getPermission();
    getCurrentUser();
    getTodosAndDones();
    welcomeMsg = Utils.getWelcomeMessage();
  }

  String welcomeMsg;
  List<Model.Todo> todos;
  List<Model.Todo> dones;

  //String _selection;

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Utils.hideKeyboard(context);
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Header(
                                      msg: welcomeMsg,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 35),
                                      child: Popup(
                                        getTodosAndDones: getTodosAndDones,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: TaskInput(
                                  onSubmitted: addTaskInTodo,
                                ), // Add Todos
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                expandedHeight: 200,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    switch (index) {
                      case 0:
                        return Todo(
                          todos: todos,
                          onTap: markTodoAsDone,
                          onDeleteTask: deleteTask,
                        ); // Active todos
                      case 1:
                        return SizedBox(
                          height: 30,
                        );
                      default:
                        return Done(
                          dones: dones,
                          onTap: markDoneAsTodo,
                          onDeleteTask: deleteTask,
                        ); // Done todos
                    }
                  },
                  childCount: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getTodosAndDones() async {
    final _todos = await DBWrapper.sharedInstance.getTodos();
    final _dones = await DBWrapper.sharedInstance.getDones();

    setState(() {
      todos = _todos;
      dones = _dones;
    });
  }

  void addTaskInTodo({@required TextEditingController controller}) {
    final inputText = controller.text.trim();

    if (inputText.length > 0) {
      // Add todos
      Model.Todo todo = Model.Todo(
        title: inputText,
        created: DateTime.now(),
        updated: DateTime.now(),
        status: Model.TodoStatus.active.index,
      );

      DBWrapper.sharedInstance.addTodo(todo);
      getTodosAndDones();
    } else {
      Utils.hideKeyboard(context);
    }

    controller.text = '';
  }

  void markTodoAsDone({@required int pos}) {
    DBWrapper.sharedInstance.markTodoAsDone(todos[pos]);
    getTodosAndDones();
  }

  void markDoneAsTodo({@required int pos}) {
    DBWrapper.sharedInstance.markDoneAsTodo(dones[pos]);
    getTodosAndDones();
  }

  void deleteTask({@required Model.Todo todo}) {
    DBWrapper.sharedInstance.deleteTodo(todo);
    getTodosAndDones();
  }

  //TODO Get contacts and store in sqlflite
  void getCurrentUser() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        userid = user.uid;
//        print(userid);
      }
    });
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permisionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permisionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      Toast.show("permission granted", context);
      getPhoneContactList();
      return permission;
    }
  }

  void getPhoneContactList() async {
    var contacts = await ContactsService.getContacts();
    contacts.forEach((contact) => contact.phones.forEach(
        (phone) => phoneContacts.add(contact.displayName + phone.value)));
//    print(phoneContacts[1]);
    for (int i = 0; i < phoneContacts.length; i++) {
      String newPhone =
          phoneContacts[i].replaceAll(new RegExp(r"\s+\b|\b\s"), "").trim();
      if (newPhone.length >= 9) {
        String newPhoneContact = newPhone.substring(newPhone.length - 8);
//         print(newPhoneContact);
        newPhoneContacts.add(newPhoneContact);
      }
    }
    storeContacts();
//     print(newPhoneContacts.length);
  }

  void storeContacts() async {
    String phoneNumberFirebase;
    String trimmedPhoneNumberFirebase;
    final QuerySnapshot result =
        await Firestore.instance.collection('users').getDocuments();
    documentsList = result.documents;
    if (documentsList.length > 0) {
      for (int y = 0; y < documentsList.length; y++) {
        phoneNumberFirebase = documentsList[y]['phone'];
        String userNameFirebase = documentsList[y]['name'];
        userUidFirebase = documentsList[y]['uid'];
        String userEmailFirebase = documentsList[y]['email'];
        trimmedPhoneNumberFirebase = phoneNumberFirebase
            .trim()
            .substring(phoneNumberFirebase.length - 8);

//        print(trimmedPhoneNumberFirebase);

        for (int i = 0; i < phoneContacts.length; i++) {
          String newPhoneForDisplay = phoneContacts[i];
//            String newPhoneForDisplayTrimmed = phoneContacts[i].trim().substring(phoneNumberFirebase.length - 8);
//            print(newPhoneForDisplayTrimmed);
          if (newPhoneContacts.contains(trimmedPhoneNumberFirebase)) {
            if (userUidFirebase != userid && userUidFirebase != null) {
              String newPhoneContact1 =
                  newPhoneForDisplay.substring(newPhoneForDisplay.length - 8);
              if (newPhoneContact1 == trimmedPhoneNumberFirebase) {
                name_saved_as = newPhoneForDisplay
                    .replaceAll(new RegExp(r"[0-9,+]"), "")
                    .trim();
                phone_saved_as = newPhoneForDisplay
                    .replaceAll(new RegExp(r"[^0-9,+]"), "")
                    .trim();
                print("Added to db: ");
                print(name_saved_as);
                List<UserContact> listOfContact = [];
                var contact = UserContact(
                    firestore_name: userNameFirebase,
                    firestore_user_uid: userUidFirebase,
                    firestore_phone_number: phoneNumberFirebase,
                    saved_contact_name: name_saved_as,
                    saved_contact_phone_number: phone_saved_as);
                listOfContact.add(contact);
                UserContact insertContact = listOfContact[0];
                await DBProvider.db.newContact(insertContact);
              } else {
//                    Toast.show("Skipped Number in contact but not in firebase", context);
                print("----------------------");
                print("Skipped Number in contact but not in firebase");
                print(newPhoneForDisplay);
              }
            } else {
//                Toast.show("Skipped your Number", context);
              if (userUidFirebase != null) {
                print("Firebase Uid    : " + userUidFirebase);
                print("Current User Uid: " + userid);
                print("Skipped your Number");
                print(newPhoneForDisplay);
                userUidFirebase = null;
              }
            }
          } else {
//              Toast.show("Skipped Number", context);
            print("----------------------");
            print("Skipped Number");
            print(newPhoneForDisplay);
          }
          print("I = $i");
        }
        //Todo: 111
      }
    } else {
//      Toast.show("Firebase list empty", context);
      print("**************************");
      print("Firebase list empty");
    }

//    print(documents);

//    String phoneDB = document['phone'];

//
////    }
//
//    if (document['uid'] == userid) {
//      print("Ur Number");
//    } else if (!newPhoneContacts.contains(newPhone)) {
//      print("Skipped Number");
//    } else {
//      print("Ur Number");
//    }
//
//
//    List<UserContact> listOfContact = [];
//    var contact = UserContact(firestore_name: "Raouf", firestore_user_uid: "Rahiche", firestore_phone_number: "temp", saved_contact_name: "temp", saved_contact_phone_number: "temp");
//    listOfContact.add(contact);
//    UserContact rnd = listOfContact[0];
//    await DBProvider.db.newContact(rnd);
  }
}
