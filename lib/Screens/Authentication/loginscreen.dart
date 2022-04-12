import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:tryit_vendor_app/Screens/Authentication/registrationscreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    // If the user is already signed-in, use it as initial data
    initialData: FirebaseAuth.instance.currentUser,
    builder: (context, snapshot) {
      // User is not signed in
      if (!snapshot.hasData) {
        return  SignInScreen(
            headerBuilder: (context, constraints, _) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/images/logo.png')
                ),
              );
            },
            providerConfigs: const [
              EmailProviderConfiguration() ,
              GoogleProviderConfiguration(clientId:'428937200324-c2frui4if6t2eil1i3pmi40q0g3hv7s8.apps.googleusercontent.com'),
              PhoneProviderConfiguration()
            ]
        );
      }

      // Render your application if authenticated
      return RegistrationScreen();
    },
  );
  }
}
