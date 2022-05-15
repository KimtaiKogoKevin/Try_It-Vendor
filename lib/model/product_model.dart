import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:tryit_vendor_app/firebase_services.dart';

FirebaseServices services = FirebaseServices();

class Product {
  Product(
      {this.productName,
      this.productDescription,
      this.regularPrice,
      this.discountPrice,
      this.category,
      this.mainCategory,
      this.subCategory,
      this.discountDateSchedule,
      this.skuNumber,
      this.manageInventory,
      this.chargeShipping,
      this.shippingCharge,
      this.brandName,
      this.stockOnHand,
      this.reorderLevel,
      this.sizeList,
      this.otherDetails,
      this.selectedUnit,
      this.imageUrls,
      this.seller,
      this.approved});

  Product.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! == null ? null : json['approved'] as bool,
          brandName: json['brandName']! == null ? null : json['brandName'] as String,
          category: json['category']!  == null ? null : json['category'] as String,
          chargeShipping: json['chargeShipping']! as bool,
          manageInventory: json['manageInventory']! as bool,
          discountDateSchedule: json['discountDateSchedule'] == null ? null : json['discountDateSchedule'] as Timestamp,
          discountPrice: json['discountPrice']! == null ? null : json['discountPrice'] as int,
          imageUrls: json['imageUrls']! == null ? null : json['imageUrls'] as List,
          mainCategory: json['mainCategory'] ==  null ? null : json['mainCategory'] as String,
          otherDetails: json['otherDetails']! == null ? null : json['otherDetails'] as String,
          productDescription: json['productDescription']! == null ? null : json['productDescription'] as String,
          productName: json['productName']! == null ? null : json['productName'] as String,
          regularPrice: json['regularPrice']! == null ? null : json['regularPrice'] as int,
          reorderLevel: json['reorderLevel']! == null ? null : json['reorderLevel'] as int,
          selectedUnit: json['selectedUnit']! == null ? null : json['selectedUnit'] as String,
          sizeList: json['sizeList'] == null ? null : json['sizeList'] as List,
          seller: json['seller']! == null ? null : json['seller'] as Map<dynamic, dynamic>,
          shippingCharge: json['shippingCharge']! == null ? null : json['shippingCharge'] as int,
          skuNumber: json['skuNumber']! == null ? null : json['skuNumber'] as int,
          stockOnHand: json['stockOnHand']! == null ? null : json['stockOnHand'] as int,
          subCategory: json['subCategory'] == null ? null : json['subCategory'] as String,
        );

  final String? productName;
  final String? productDescription;
  final int? regularPrice;
  final int? discountPrice;
  final String? category;
  final String? mainCategory;
  final String? subCategory;
  final Timestamp? discountDateSchedule;
  final int? skuNumber;
  final bool? manageInventory;
  final bool? chargeShipping;
  late final int? shippingCharge;
  final String? brandName;
  final int? stockOnHand;
  final int? reorderLevel;
  final List? sizeList;
  final String? otherDetails;
  final String? selectedUnit;
  final List? imageUrls;
  final bool? approved;
  final Map? seller;

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'brandName': brandName,
      'category': category,
      'chargeShipping': chargeShipping,
      'discountDateSchedule': discountDateSchedule,
      'discountPrice': discountPrice,
      'imageUrls': imageUrls,
      'mainCategory': mainCategory,
      'manageInventory': manageInventory,
      'otherDetails': otherDetails,
      'productDescription': productDescription,
      'productName': productName,
      'regularPrice': regularPrice,
      'reorderLevel': reorderLevel,
      'sizeList': sizeList,
      'selectedUnit': selectedUnit,
      'shippingCharge': shippingCharge,
      'stockOnHand': stockOnHand,
      'skuNumber': skuNumber,
      'subCategory': subCategory,
      'seller': seller,
    };
  }
}

productQuery(approved) {
  return FirebaseFirestore.instance
      .collection('Products')
      .where('approved', isEqualTo: approved)
      .where('seller.uid', isEqualTo: services.user!.uid)
      .orderBy('productName')
      .withConverter<Product>(
        fromFirestore: (snapshot, options) =>
            Product.fromJson(snapshot.data()!),
        toFirestore: (product, _) => product.toJson(),
      );
}
