import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FoodSwapModel {
  final String? id;
  final String? name;
  final String? category;
  final int? quantity;
  final String? unit;
  final String? status;
  final String? uid;
  final List<AcceptedSwapItem>? requests;
  final DateTime? expiredDate;

  FoodSwapModel({
    this.id,
    this.name,
    this.category,
    this.quantity,
    this.unit,
    this.status,
    this.uid,
    this.requests,
    this.expiredDate,
  });

  factory FoodSwapModel.fromMap(Map<String, dynamic> map, String docId) {
    return FoodSwapModel(
      id: docId,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? 0,
      unit: map['unit'] ?? '',
      status: map['status'] ?? '',
      uid: map['uid'] ?? '',
      requests:
          (map['requests'] as List<dynamic>?)
              ?.map(
                (request) =>
                    AcceptedSwapItem.fromMap(request as Map<String, dynamic>),
              )
              .toList() ??
          [],
      expiredDate:
          map['expiredDate'] != null
              ? (map['expiredDate'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }
}

class AcceptedSwapItem {
  final int? reqId;
  final String? acceptedSwapItem;
  final String? acceptedSwapItemId;
  final String? pickupDate;
  final String? pickupLocation;
  final String? pickupTime;
  final String? swapedItemId;
  final DateTime? timestamp;
  final String? uid;

  const AcceptedSwapItem({
    this.reqId,
    this.acceptedSwapItem,
    this.acceptedSwapItemId,
    this.pickupDate,
    this.pickupLocation,
    this.pickupTime,
    this.swapedItemId,
    this.timestamp,
    this.uid,
  });
  factory AcceptedSwapItem.fromMap(Map<String, dynamic> map) {
    return AcceptedSwapItem(
      reqId: map['reqId'] as int?,
      acceptedSwapItem: map['acceptedSwapItem'] as String?,
      acceptedSwapItemId: map['acceptedSwapItemId'] as String?,
      pickupDate: map['pickupDate'],
      pickupLocation: map['pickupLocation'] as String?,
      pickupTime: map['pickupTime'],
      swapedItemId: map['swapedItemId'] as String?,
      timestamp:
          map['timestamp'] != null
              ? (map['timestamp'] is Timestamp
                  ? (map['timestamp'] as Timestamp).toDate()
                  : DateTime.tryParse(map['timestamp']))
              : null,
      uid: map['uid'] as String?,
    );
  }

  factory AcceptedSwapItem.fromJson(String source) =>
      AcceptedSwapItem.fromMap(json.decode(source));
  AcceptedSwapItem copyWith({
    int? reqId,
    String? acceptedSwapItem,
    String? pickupDate,
    String? pickupLocation,
    String? pickupTime,
    String? swapedItemId,
    DateTime? timestamp,
    String? uid,
  }) {
    return AcceptedSwapItem(
      reqId: reqId ?? this.reqId,
      acceptedSwapItem: acceptedSwapItem ?? this.acceptedSwapItem,
      pickupDate: pickupDate ?? this.pickupDate,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupTime: pickupTime ?? this.pickupTime,
      swapedItemId: swapedItemId ?? this.swapedItemId,
      timestamp: timestamp ?? this.timestamp,
      uid: uid ?? this.uid,
    );
  }

  @override
  String toString() {
    return 'AcceptedSwapItem(acceptedSwapItem: $acceptedSwapItem, pickupDate: $pickupDate, pickupLocation: $pickupLocation, pickupTime: $pickupTime, swapedItemId: $swapedItemId, timestamp: $timestamp, uid: $uid)';
  }
}
