import 'package:flutter/material.dart';
import 'package:tryit_vendor_app/widgets/customDrawer.dart';
import 'package:tryit_vendor_app/widgets/products/published_products.dart';
import 'package:tryit_vendor_app/widgets/products/unpublished_products.dart';

class ProductScreen extends StatelessWidget {
  static const String id = "Product-Screen";

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('Products'),
            bottom: const TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide:
                        BorderSide(color: Colors.deepOrangeAccent, width: 6)),
                tabs: [
                  Tab(
                    child: Text('Unpublished Products'),
                  ),
                  Tab(
                    child: Text('Published Products'),
                  )
                ]),
          ),
          drawer: const CustomDrawer(),
          body: const TabBarView(
            children: [
              UnpublishedProducts(),
              PublishedProducts(),


            ],
          ),
        ));
  }
}
