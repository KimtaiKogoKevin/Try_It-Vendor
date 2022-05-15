import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:tryit_vendor_app/provider/product_provider.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference vendor =
      FirebaseFirestore.instance.collection('Vendor');
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference mainCategories =
      FirebaseFirestore.instance.collection('mainCategories');
  final CollectionReference products =
      FirebaseFirestore.instance.collection('Products');

  final CollectionReference subCategories =
      FirebaseFirestore.instance.collection('subCategories');

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file, String? reference) async {
    File _file = File(file!.path);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);
    await ref.putFile(_file);
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<List> uploadFiles(
      {List<XFile>? images, String? ref, ProductProvider? provider}) async {
    var imageUrls = await Future.wait(
      images!.map(
        (_image) => uploadFile(image: File(_image.path), reference: ref),
      ),
    );
    provider!.getFormData(imageUrls: imageUrls);

    return imageUrls;
  }

  Future uploadFile({File? image, String? reference}) async {
    firebase_storage.Reference storageReference = storage
        .ref()
        .child('$reference!/${DateTime.now().microsecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    return storageReference.getDownloadURL();
  }

  Future<void> addVendor({Map<String, dynamic>? data, BuildContext? context}) {
    // Call the user's CollectionReference to add a new user

    return vendor
        .doc(user!.uid)
        .set(data)
        .then((value) => scaffold(context, "Add Vendor Success"));
    //.catchError((error) => print("Failed to add Vendor: $error"));
  }

  Future<void> addProducts(
      {Map<String, dynamic>? data, BuildContext? context}) {
    // Call the user's CollectionReference to add a new user

    return products
        .add(data)
        .then((value) => scaffold(context, "Add Product Success"));
    //.catchError((error) => print("Failed to add Vendor: $error"));
  }

  String formattedDate(date) {
    var outputFormatDate = DateFormat.yMd();
    var outputDate = outputFormatDate.format(date);
    return outputDate;
  }
    formattedCurrency(number) {
    var f =  NumberFormat("#,##,###");
    String formattedNumber = f.format(number);
    return formattedNumber;
  }

  //formfield
  Widget formField({
    String? label,
    TextInputType? inputType,
    void Function(String)? onChanged,
    int? maxLines,
    int? minLines,
    String? hint,
  }) {
    return TextFormField(
      keyboardType: inputType,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.indigo),
        ),
        label: Text(label!),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 8, color: Colors.grey),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
        return null;
      },
      onChanged: onChanged,
    );
  }

  //scaffold message
  scaffold(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    ));
  }
}
