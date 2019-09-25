import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/res/model/contacts/model_contact.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "contacts.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE UserContact ("
          "id INTEGER PRIMARY KEY,"
          "firestore_name TEXT,"
          "firestore_user_uid TEXT UNIQUE,"
          "firestore_phone_number TEXT,"
          "saved_contact_name TEXT,"
          "saved_contact_phone_number TEXT"
          ")");
    });
  }

  newContact(UserContact newContact) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM UserContact");
    int id = table.first["id"];
    var raw;
    var userContactExists = getUserContact(newContact.firestore_user_uid);
    if (userContactExists == null) {
      //insert to the table using the new id
      raw = await db.rawInsert(
          "INSERT Into UserContact (id,firestore_name,firestore_user_uid,firestore_phone_number,saved_contact_name,saved_contact_phone_number)"
          " VALUES (?,?,?,?,?,?)",
          [
            id,
            newContact.firestore_name,
            newContact.firestore_user_uid,
            newContact.firestore_phone_number,
            newContact.saved_contact_name,
            newContact.saved_contact_phone_number
          ]);
    }
    return raw;
  }

  updateUserContact(UserContact newContact, int id) async {
    final db = await database;
    var res = await db.update("UserContact", newContact.toMap(),
        where: "id = ?", whereArgs: [newContact.id]);
    return res;
  }

  getUserContact(String uid) async {
    final db = await database;
    var res = await db.query("UserContact",
        where: "firestore_user_uid = ?", whereArgs: [uid]);
    return res.isNotEmpty ? UserContact.fromMap(res.first) : null;
  }

  Future<List<UserContact>> getAllUserContacts() async {
    final db = await database;
    var res = await db.query("UserContact");
    List<UserContact> list =
        res.isNotEmpty ? res.map((c) => UserContact.fromMap(c)).toList() : [];
    return list;
  }

  deleteUserContact(int id) async {
    final db = await database;
    return db.delete("UserContact", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from UserContact");
  }
}
