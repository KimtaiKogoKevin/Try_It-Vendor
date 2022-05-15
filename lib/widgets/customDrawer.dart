import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryit_vendor_app/Screens/ProductScreen.dart';
import 'package:tryit_vendor_app/provider/vendor_provider.dart';


import '../Screens/Add_product_screen.dart';
import '../Screens/Authentication/loginscreen.dart';
import '../Screens/home.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vendorData = Provider.of<VendorProvider>(context);
    Widget _menu({String? menuTitle, IconData? icon, String? route}) {
      return ListTile(
        leading: icon == null ? null : Icon(icon),
        title: Text(menuTitle!),
        onTap: () {
          Navigator.pushReplacementNamed(context, route!);
        },
      );
    }

    return Drawer(
      child: Column(children: [
        Container(
            height: 120,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                DrawerHeader(
                    child: vendorData.doc == null
                        ? const Text(
                            'Loading ....',
                            style: TextStyle(color: Colors.white),
                          )
                        : Row(
                            children: [
                              CachedNetworkImage(imageUrl: vendorData.doc!['logoImage']),
                              const SizedBox(width: 10,),
                              Text(
                                vendorData.doc!['businessName'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
              ],
            )),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _menu(
                  menuTitle: 'Home',
                  icon: Icons.home_outlined,
                  route: HomePage.id),
              ExpansionTile(
                  title: const Text('Products'),
                  leading: const Icon(Icons.weekend_outlined),
                  children: [
                    _menu(menuTitle: 'All Products', route: ProductScreen.id, icon: Icons.all_inclusive_rounded),
                    _menu(
                        menuTitle: 'Add Products', route: AddProductScreen.id ,icon: Icons.add),
                  ])
            ],
          ),
        ),
        const Divider(color: Colors.grey,),
        ListTile(
          title: Text('SignOut'),
          trailing:Icon(Icons.exit_to_app),
          onTap: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, LoginScreen.id);
            
          },
        )
      ]),
    );
  }
}
