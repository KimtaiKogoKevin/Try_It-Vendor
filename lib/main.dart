import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tryit_vendor_app/Screens/Authentication/loginscreen.dart';
import 'package:tryit_vendor_app/Screens/home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:tryit_vendor_app/provider/product_provider.dart';
import 'package:tryit_vendor_app/provider/vendor_provider.dart';
import 'Screens/Add_product_screen.dart';
import 'Screens/ProductScreen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Provider.debugCheckInvalidValueType = null;
  runApp(
      MultiProvider(
        providers: [
          Provider<VendorProvider>(create: (_) => VendorProvider()),
          Provider<ProductProvider>(create: (_) => ProductProvider()),


        ],
        child: MyApp(),
      ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.indigo,

      ),
      home: const SplashScreen() ,
      builder:EasyLoading.init(),
      routes:{
    HomePage.id:(context) => const HomePage(),
        ProductScreen.id:(context) => const ProductScreen(),
        AddProductScreen.id:(context) => const AddProductScreen(),
        LoginScreen.id:(context) => const LoginScreen(),




      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                LoginScreen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            Image.asset('assets/images/logo.png',fit:BoxFit.contain),
            const Text('Vendor Application ' , textAlign:  TextAlign.center , style:TextStyle(fontSize: 30),)
          ]

        ),
      ),

    );
  }
}


