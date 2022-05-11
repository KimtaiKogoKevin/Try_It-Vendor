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
    notifyListeners();
  }
}
