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
}
