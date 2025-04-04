import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  final String? id;
  final String? foodName;
  final String? image;
  final String? foodType;
  final int? noOfServe;
  final String? discription;
  final String? pickUpLocation;
  final bool? isAccpected;
  final String? raisedBy;
  final String? status;
  final String? type;
  final String? contactName;
  final String? contactMobile;
  final String? contactContryCode;
  final DateTime? expiredDate;
  final DateTime? createdAt;

  DonationModel({
    this.id,
    this.foodName,
    this.image,
    this.foodType,
    this.noOfServe,
    this.discription,
    this.pickUpLocation,
    this.isAccpected,
    this.raisedBy,
    this.status,
    this.type,
    this.contactContryCode,
    this.contactMobile,
    this.contactName,
    this.createdAt,
    this.expiredDate,
  });

  static DonationModel fromMap(Map<String, dynamic> data) {
    return DonationModel(
      id: data['id'],
      foodName: data['foodName'],
      image: data['image'],
      foodType: data['foodType'],
      noOfServe: data['noOfServe'],
      discription: data['discription'],
      pickUpLocation: data['pickUpLocation'],
      isAccpected: data['isAccpected'],
      raisedBy: data['raisedBy'],
      status: data['status'],
      type: data['type'],
      contactContryCode: data['contactContryCode'],
      contactMobile: data['contactMobile'],
      contactName: data['contactName'],
      expiredDate:
          data['expiredDate'] != null
              ? (data['expiredDate'] as Timestamp).toDate()
              : null,
      createdAt:
          data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodName': foodName,
      'image': image,
      'foodType': foodType,
      'noOfServe': noOfServe,
      'discription': discription,
      'pickUpLocation': pickUpLocation,
      'isAccpected': isAccpected,
      'raisedBy': raisedBy,
      'status': status,
      'type': type,
      'contactContryCode': contactContryCode,
      'contactMobile': contactMobile,
      'contactName': contactName,
      'expiredDate':
          expiredDate != null ? Timestamp.fromDate(expiredDate!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
