import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

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
          approved: json['approved'] !as bool,
          brandName: json['brandName'] !as String,
          category: json['category']! as String,
          chargeShipping: json['chargeShipping']! as bool,
          discountDateSchedule: json['discountDateSchedule'] == null  ? null : json['discountDateSchedule'] as Timestamp,
          discountPrice: json['discountPrice']! as int,
          imageUrls: json['imageUrls']! as List,
          mainCategory: json['mainCategory'] == null   ? null : json['mainCategory'] as String,
          otherDetails: json['otherDetails']! as String,
          productDescription: json['productDescription']! as String,
          productName: json['productName']! as String,
          regularPrice: json['regularPrice']! as int,
          reorderLevel: json['reorderLevel']! as int,
          selectedUnit: json['selectedUnit']! as String,
          sizeList: json['sizeList'] == null ? null : json['sizeList']  as List,
          seller: json['seller'] !as Map<dynamic, dynamic>,
          shippingCharge: json['shippingCharge']! as int,
          skuNumber: json['skuNumber'] !as int,
          stockOnHand: json['stockOnHand']! as int,
          subCategory: json['subCategory']==null ? null : json['subCategory'] as String,
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
  final int? shippingCharge;
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
productQuery(approved){
  return FirebaseFirestore.instance.collection('Products').where('approved',isEqualTo: approved)
      .orderBy('productName')
      .withConverter<Product>(
    fromFirestore: (snapshot, options) => Product.fromJson(snapshot.data()!),
    toFirestore: (product,_) => product.toJson(),);

}

