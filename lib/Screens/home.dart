import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryit_vendor_app/provider/vendor_provider.dart';

import '../widgets/customDrawer.dart';

class HomePage extends StatelessWidget {
  static const String id  = 'Home-Page';
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final vendorData = Provider.of<VendorProvider>(context);
    if(vendorData.doc==null){
      vendorData.getVendorData();
    }
    return  Scaffold(
      appBar:AppBar(
        elevation:0,
        title:const Text('DashBoard'),

      ) ,
      drawer: const Drawer(
       child: CustomDrawer()
      ),
      body:const Center(
       child: Text("Hello")
      )
    );
  }
}

