import 'package:flutter/material.dart';
import 'package:tryit_vendor_app/widgets/customDrawer.dart';

class ProductScreen extends StatelessWidget {
  static const String id = "Product-Screen";
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          elevation:0,
          title:const Text('Products'),

        ) ,
      drawer: CustomDrawer(),
      body: Center (
        child: Text("Product Screen"),
      )
    );
  }
}
