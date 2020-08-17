import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid, email, fullName;
  Timestamp created;

  UserModel({this.uid, this.email, this.fullName, this.created});
}
