import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? gender;
  final String? fcmToken;
  final Timestamp? dob;
  final String? nationality;
  final String? country;
  final String? state;
  final String? city;
  final String? zipCode;
  final int? points;
  final List<Items>? kitchenItems;
  final int? monthlyItemQuantityAddedCount;
  final int? monthlyItemQuantityRemovedCount;
  final DateTime? createdAt;

  UserModel({
    this.uid,
    this.title,
    this.firstName,
    this.fcmToken,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.address,
    this.gender,
    this.dob,
    this.nationality,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.points,
    this.kitchenItems,
    this.monthlyItemQuantityAddedCount,
    this.monthlyItemQuantityRemovedCount,
    this.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    DateTime? parseTimestamp(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    return UserModel(
      uid: data['uid'] ?? '',
      title: data['title'] ?? '',
      firstName: data['firstName'] ?? '',
      fcmToken: data['fcmToken'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      gender: data['gender'] ?? '',
      dob: data['dob'],
      nationality: data['nationality'] ?? '',
      country: data['country'] ?? '',
      state: data['state'] ?? '',
      city: data['city'] ?? '',
      zipCode: data['zipCode'] ?? '',
      points: data['points'] ?? 0,
      kitchenItems:
          (data['kitchenItems'] as List<dynamic>?)
              ?.map((item) => Items.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      monthlyItemQuantityAddedCount: data['addedItemQuantityCount'] ?? 0,
      monthlyItemQuantityRemovedCount: data['noOfQuantityRemoved'] ?? 0,
      createdAt: parseTimestamp(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore({bool isNew = false}) {
    return {
      'uid': uid,
      'title': title,
      'firstName': firstName,
      'fcmToken': fcmToken,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'gender': gender,
      'dob': dob,
      'nationality': nationality,
      'country': country,
      'state': state,
      'city': city,
      'zipCode': zipCode,
      'points': points,
      'kitchenItems': kitchenItems?.map((item) => item).toList(),
      'addedItemQuantityCount': monthlyItemQuantityAddedCount,
      'noOfQuantityRemoved': monthlyItemQuantityRemovedCount,
      'createdAt':
          isNew
              ? FieldValue.serverTimestamp()
              : (createdAt != null ? Timestamp.fromDate(createdAt!) : null),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'firstName': firstName,
      'fcmToken': fcmToken,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'gender': gender,
      'dob': dob,
      'nationality': nationality,
      'country': country,
      'state': state,
      'city': city,
      'zipCode': zipCode,
      'points': points,
      'kitchenItems': kitchenItems?.map((item) => item).toList() ?? [],
      'addedItemQuantityCount': monthlyItemQuantityAddedCount,
      'noOfQuantityRemoved': monthlyItemQuantityRemovedCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseJsonTimestamp(dynamic value) {
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    return UserModel(
      uid: json['uid'] ?? '',
      title: json['title'] ?? '',
      firstName: json['firstName'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'],
      nationality: json['nationality'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      zipCode: json['zipCode'] ?? '',
      points: json['points'] ?? 0,
      monthlyItemQuantityAddedCount: json['addedItemQuantityCount'] ?? 0,
      monthlyItemQuantityRemovedCount: json['noOfQuantityRemoved'] ?? 0,
      kitchenItems:
          (json['kitchenItems'] as List<dynamic>?)
              ?.map((item) => Items.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: parseJsonTimestamp(json['createdAt']),
    );
  }
}

class Items {
  final String? id;
  final String? name;
  final String? image;
  final String? category;
  final int? quantity;
  final String? unit;
  final String? status;
  final dynamic expiredDate;

  Items({
    this.id,
    this.name,
    this.image,
    this.category,
    this.quantity,
    this.unit,
    this.status,
    this.expiredDate,
  });

  /// ✅ Renamed `fromJson` to `fromMap`
  factory Items.fromMap(Map<String, dynamic> map) {
    dynamic expDate = map['expiredDate'];
    return Items(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Unknown',
      image: map['item_image'] as String? ?? '',
      category: map['category'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      unit: map['unit'] as String? ?? '',
      status: map['status'] as String? ?? '',
      expiredDate: expDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'item_image': image,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'status': status,
      'expiredDate': Timestamp.fromDate(expiredDate ?? DateTime.now()),
    };
  }

  static String generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
