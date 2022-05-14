import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_services.dart';
import '../model/vendor_model.dart';
class VendorProvider with ChangeNotifier {
  final FirebaseServices _services = FirebaseServices();
  DocumentSnapshot? doc;
  Vendor? vendor;

  getVendorData(){
    _services.vendor.doc(_services.user!.uid).get().then((document){
      doc = document;
      vendor = Vendor.fromJson(document.data()as Map<String,dynamic>);
      notifyListeners();
    });

  }
}
