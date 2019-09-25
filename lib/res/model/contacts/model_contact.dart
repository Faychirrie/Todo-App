import 'dart:convert';

class UserContact {
  final String id;
  final String firestore_name;
  final String firestore_user_uid;
  final String firestore_phone_number;
  final String saved_contact_name;
  final String saved_contact_phone_number;

  UserContact(
      {this.id,
      this.firestore_name,
      this.firestore_user_uid,
      this.firestore_phone_number,
      this.saved_contact_name,
      this.saved_contact_phone_number});

  factory UserContact.fromMap(Map<String, dynamic> json) => new UserContact(
        id: json["id"].toString(),
        firestore_name: json["firestore_name"],
        firestore_user_uid: json["firestore_user_uid"],
        firestore_phone_number: json["firestore_phone_number"],
        saved_contact_name: json["saved_contact_name"],
        saved_contact_phone_number: json["saved_contact_phone_number"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "firestore_name": firestore_name,
        "firestore_user_uid": firestore_user_uid,
        "firestore_phone_number": firestore_phone_number,
        "saved_contact_name": saved_contact_name,
        "saved_contact_phone_number": saved_contact_phone_number,
      };
}

UserContact ContactFromJson(String str) {
  final jsonData = json.decode(str);
  return UserContact.fromMap(jsonData);
}

String ContactToJson(UserContact data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
