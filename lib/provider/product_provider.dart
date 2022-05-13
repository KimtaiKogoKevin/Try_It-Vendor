import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_services.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productData = {};


  getFormData({
    String? productName,
    String? productDescription,
    int? regularPrice,
    int? discountPrice,
     String? category,
     String? mainCategory,
    String? subCategory,
    String? taxStatus ,
    DateTime? discountDateSchedule,
    int? skuNumber,
    bool? manageInventory,
    bool? chargeShipping,
    int? shippingCharge,
    String? brandName,
    int? stockOnHand,
    int? reorderLevel,
    List? sizeList,
    String? otherDetails,






  }) {
    if (productName != null) {
      productData!['productName'] = productName;
    }
    if (productDescription != null) {
      productData!['productDescription'] = productDescription;
    }
    if (regularPrice != null) {
      productData!['regularPrice'] = regularPrice;
    }
    if (discountPrice != null) {
      productData!['discountPrice'] = discountPrice;
    }
    if (category != null) {
      productData!['category'] = category;
    }
    if (mainCategory != null) {
      productData!['mainCategory'] = mainCategory;
    }
    if (subCategory != null) {
      productData!['subCategory'] = subCategory;
    }
    if (taxStatus != null) {
    productData!['taxStatus'] = taxStatus;
    }
    if(discountDateSchedule!= null){
      productData!['discountDateSchedule']= discountDateSchedule;

    }
    if(skuNumber!= null){
      productData!['skuNumber']= skuNumber;

    }

    if(stockOnHand!= null){
      productData!['stockOnHand']= stockOnHand;

    }

    if(reorderLevel!= null){
      productData!['reorderLevel']= reorderLevel;

    }
    if(shippingCharge!= null){
      productData!['shippingCharge']= shippingCharge;

    }
    if(chargeShipping!= null){
      productData!['chargeShipping']= chargeShipping;

    }
    if(brandName!= null){
      productData!['brandName']= brandName;

    }
    if(sizeList!= null){
      productData!['size']= sizeList;

    }
    if(otherDetails!= null){
      productData!['otherDetails']= otherDetails;

    }
    notifyListeners();
  }
}
