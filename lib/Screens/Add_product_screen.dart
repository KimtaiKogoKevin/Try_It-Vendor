import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryit_vendor_app/provider/product_provider.dart';
import 'package:tryit_vendor_app/widgets/add_product/create_product.dart';
import 'package:tryit_vendor_app/widgets/add_product/inventory_detail.dart';
import 'package:tryit_vendor_app/widgets/add_product/productAttributes.dart';
import 'package:tryit_vendor_app/widgets/add_product/shipping_management.dart';
import 'package:tryit_vendor_app/widgets/customDrawer.dart';

class AddProductScreen extends StatelessWidget {
  static const String id = "Add-Product-Screen";

  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: const Text('Add Products'),
            bottom: const TabBar(
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                width: 4,
                color: Colors.deepOrange,
              )),
              tabs: [
                Tab(child: Text('Create Product')),
                Tab(child: Text('Inventory')),
                Tab(child: Text('Shipping')),
                Tab(child: Text('Product Attributes')),
                Tab(child: Text('Linked Products')),
                Tab(child: Text('Images'))
              ],
            )),
        drawer: const CustomDrawer(),
        body: const TabBarView(
          children: [
            CreateProduct(),
            InventoryManagement(),
            ShippingDetails(),
            ProdAttributes(),
            Center(
              child: Text("1 "),
            ),
            Center(
              child: Text("1 "),
            ),
          ],
        ),
        persistentFooterButtons: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  print(_provider.productData!['productName']);
                },
                child: const Text('Save Product'),
              ),
            )
          ])
        ],
      ),
    );
  }
}
