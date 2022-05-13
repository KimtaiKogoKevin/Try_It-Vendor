import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference vendor = FirebaseFirestore.instance.collection('Vendor');
  final CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  final CollectionReference mainCategories = FirebaseFirestore.instance.collection('mainCategories');

  final CollectionReference subCategories = FirebaseFirestore.instance.collection('subCategories');


  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file, String? reference) async {
    File _file = File(file!.path);
    Reference ref = FirebaseStorage.instance.ref(reference);
    await ref.putFile(_file);
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }
  Future <void> addVendor({Map<String,dynamic>?data}) {
    // Call the user's CollectionReference to add a new user

    return vendor.doc(user!.uid)
        .set(data)
        .then((value) => print("Vendor Added"))
        .catchError((error) => print("Failed to add Vendor: $error"));
  }
  String formattedDate(date){

    var outputFormatDate = DateFormat.yMd().add_jm();
    var outputDate = outputFormatDate.format(date);
    return outputDate;
  }


  //formfield
  Widget formField({
    String? label,
    TextInputType? inputType,
    void Function(String)? onChanged,
    int?  maxLines,
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
        hintStyle: const TextStyle(fontSize: 8 , color: Colors.grey),

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

}

