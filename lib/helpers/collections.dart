import 'package:cloud_firestore/cloud_firestore.dart';

class Collections {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference users = firestore.collection(Paths.users);
  static CollectionReference foodSwap = firestore.collection(Paths.foodSwap);
  static CollectionReference smartShopping = firestore.collection(
    Paths.smartShopping,
  );
  static CollectionReference notifications = firestore.collection(
    Paths.notifications,
  );
  static CollectionReference donations = firestore.collection(Paths.donations);
  static CollectionReference reports = firestore.collection(Paths.reports);
}

class Paths {
  static String users = "users";
  static String foodSwap = "food-swap";
  static String smartShopping = "smart-shopping";
  static String notifications = "notifications";
  static String donations = "donations";
  static String reports = "reports";
}
