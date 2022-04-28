import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tryit_vendor_app/Screens/Authentication/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tryit_vendor_app/firebase_services.dart';
import 'package:tryit_vendor_app/model/vendor_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'Authentication/registrationscreen.dart';
import 'home.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();

    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream: services.vendor.doc(services.user?.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.data!.exists) {
          return const RegistrationScreen();
        }

        var data = snapshot.data!.data();
        Vendor vendor = Vendor.fromJson(data as Map<String, dynamic>);
        if (vendor.approved == true) {
          return const HomePage();
        }
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 80,
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: vendor.logoImage!,
                    placeholder: (context, url) =>
                        Container(height: 100, width: 100, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(vendor.businessName!,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                'Your Application has been sent to  FlipIt  administrator for approval  \n  expect a message from us  soon!  ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  )),
                ),
                child: const Text('Sign Out'),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen(),
                    ));
                  });
                },
              )
            ],
          ),
        ));
      },
    ));
  }
}
