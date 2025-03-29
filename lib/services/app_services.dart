import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/models/food_swap_model.dart';
import 'package:saver_bbk_main/models/smart_shopping_model.dart';
import 'package:saver_bbk_main/models/users_model.dart';

class Services {
  static String uid = HiveHelper.getUID();
  static Stream<QuerySnapshot<UserModel>> getUserDetails({String? uid}) {
    return Collections.users
        .where('uid', isEqualTo: uid)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .snapshots();
  }

  static Stream<int> getUserPointsStream() {
    return Collections.users.where('uid', isEqualTo: uid).snapshots().map((
      snapshot,
    ) {
      if (snapshot.docs.isEmpty) return 0;
      return snapshot.docs.first.get('points');
    });
  }

  static Stream<List<FoodSwapModel>> getUserSwapListStream() {
    return Collections.foodSwap.snapshots().map((query) {
      return query.docs
          .where((doc) => doc['uid'] == uid)
          .map(
            (doc) => FoodSwapModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    });
  }

  static Stream<List<FoodSwapModel>> getAvialableSwapListStream() {
    return Collections.foodSwap
        .where('status', isEqualTo: "P")
        .orderBy('expiredDate', descending: false)
        .snapshots()
        .map((query) {
          final filteredDocs =
              query.docs.where((doc) => doc['uid'] != uid).toList();
          return filteredDocs
              .map(
                (doc) => FoodSwapModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();
        });
  }

  static Future<List<String>> getKitchenItemNames(
    List<String> selectedPreferences,
  ) async {
    try {
      DocumentSnapshot doc = await Collections.users.doc(uid).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;

        if (data["kitchenItems"] != null) {
          List<Map<String, dynamic>> kitchenItems =
              (data['kitchenItems'] as List)
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
          List<String> excludedCategories = [];
          if (selectedPreferences.contains("Vegan")) {
            excludedCategories.addAll(["Meat", "Poultry", "Seafood", "Dairy"]);
          }
          if (selectedPreferences.contains("Vegetarian")) {
            excludedCategories.addAll(["Meat", "Poultry", "Seafood"]);
          }
          if (selectedPreferences.contains("No Preferences")) {
            excludedCategories.clear();
          }
          List<String> itemNames =
              kitchenItems
                  .where(
                    (item) => !excludedCategories.contains(item['category']),
                  )
                  .map((item) => item['name'].toString())
                  .toList();

          return itemNames;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<FoodSwapModel>> getUserSwapListFuture() async {
    try {
      QuerySnapshot querySnapshot =
          await Collections.foodSwap.where('uid', isEqualTo: uid).get();

      return querySnapshot.docs
          .map(
            (doc) => FoodSwapModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Stream<List<AcceptedSwapItem>> getRequestSwapListStream(
    String itemId,
  ) {
    return Collections.foodSwap.doc(itemId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('requests')) {
          final List<dynamic> swapsRequests = data['requests'];
          return swapsRequests.map((req) {
            return AcceptedSwapItem.fromMap(req as Map<String, dynamic>);
          }).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    });
  }

  static Future<void> updateFCMToken(String token) async {
    try {
      return Collections.users.doc(uid).update({'fcmToken': token});
    } catch (e) {
      if (kDebugMode) {
        print('Error updating FCM token: $e');
      }
    }
  }

  static Stream<List<SmartShoppingModel>> getSmartList() {
    return Collections.smartShopping
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((query) {
          return query.docs.map((doc) {
            return SmartShoppingModel.fromMap(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
        });
  }

  static Stream<List<SmartShoppingModel>> fetchSmartListAllItems(
    String listId,
  ) {
    return Collections.smartShopping
        .where("listId", isEqualTo: listId)
        .snapshots()
        .map((query) {
          return query.docs.map((doc) {
            return SmartShoppingModel.fromMap(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
        });
  }

  static Future<void> addNotification(RemoteMessage message) async {
    try {
      print('UID: $uid');

      final notificationId = Collections.notifications.doc().id;
      print('Saving to Firestore with ID: $notificationId');

      await Collections.notifications.doc(notificationId).set({
        'uid': uid,
        'notificationId': notificationId,
        'title': message.notification?.title ?? 'No Title',
        'body': message.notification?.body ?? 'No Body',
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      });

      print('Notification saved successfully!');
    } catch (e) {
      print('Error adding notification: $e');
    }
  }
}
