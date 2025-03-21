import 'package:cloud_firestore/cloud_firestore.dart';

class Collections {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference users = firestore.collection(Paths.users);
}

class Paths {
  static String users = "users";
}
