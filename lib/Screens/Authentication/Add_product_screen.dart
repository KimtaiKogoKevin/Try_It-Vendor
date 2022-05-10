import 'package:flutter/material.dart';
import 'package:tryit_vendor_app/widgets/customDrawer.dart';

class AddProductScreen extends StatelessWidget {
  static const String id = "Add-Product-Screen";
      const AddProductScreen({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return Scaffold(
            appBar:AppBar(
              elevation:0,
              title:const Text('Add Products'),
            ) ,
          drawer: CustomDrawer(),
          body:Center(
            child:Text("Product Addition Screen")
          )
        );
      }
    }
