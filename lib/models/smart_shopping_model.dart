import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saver_bbk_main/models/users_model.dart';

class SmartShoppingModel {
  String? listId;
  String? listName;
  List<Items>? items;
  DateTime? createdAt;

  SmartShoppingModel({this.listId, this.listName, this.items, this.createdAt});
  factory SmartShoppingModel.fromMap(Map<String, dynamic> map) {
    return SmartShoppingModel(
      listId: map['listId'],
      listName: map['listName'],
      items:
          (map['items'] as List?)
              ?.map((item) => Items.fromMap(item))
              .toList() ??
          [],
      createdAt:
          (map['createdAt'] != null)
              ? (map['createdAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listId'] = listId;
    data['listName'] = listName;
    data['items'] = items;
    data['createdAt'] = createdAt;
    return data;
  }
}
