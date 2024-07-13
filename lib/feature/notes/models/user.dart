import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  UserModel.fromDocumentSnapshot(DocumentSnapshot doc)
      : id = doc["id"],
        name = doc["name"],
        email = doc["email"];
}
