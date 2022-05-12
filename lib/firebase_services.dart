import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
}
