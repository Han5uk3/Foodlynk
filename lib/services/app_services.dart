import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/models/users_model.dart';

class Services {
  static String uid = HiveHelper.getUID();
  static Stream<QuerySnapshot<UserModel>> getUserDetails() {
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

  static Stream<List<DocumentSnapshot>> getUserSwapListStream() {
    return Collections.foodSwap.snapshots().map(
      (query) => query.docs.where((doc) => doc['uid'] == uid).toList(),
    );
  }

  static Stream<List<DocumentSnapshot>> getAvialableSwapListStream() {
    return Collections.foodSwap
        .where('status', isEqualTo: "P")
        .orderBy('expiredDate', descending: false)
        .snapshots()
        .map((query) => query.docs.where((doc) => doc['uid'] != uid).toList());
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
      print(e);
      return [];
    }
  }
}
