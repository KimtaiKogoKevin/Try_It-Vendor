import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:tryit_vendor_app/firebase_services.dart';
import 'package:tryit_vendor_app/provider/product_provider.dart';
import 'package:tryit_vendor_app/widgets/add_product/Image_details.dart';
import 'package:tryit_vendor_app/widgets/add_product/general_details.dart';
import 'package:tryit_vendor_app/widgets/add_product/inventory_detail.dart';
import 'package:tryit_vendor_app/widgets/add_product/productAttributes.dart';
import 'package:tryit_vendor_app/widgets/add_product/shipping_management.dart';
import 'package:tryit_vendor_app/widgets/customDrawer.dart';

import '../provider/vendor_provider.dart';

class AddProductScreen extends StatefulWidget {
  static const String id = "Add-Product-Screen";

  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final _provider = Provider.of<ProductProvider>(context);
    final _vendorProvider = Provider.of<VendorProvider>(context);

    FirebaseServices _services = FirebaseServices();
    return Form(
      key: formKey,
      child: DefaultTabController(
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
                  Tab(child: Text('General')),
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
              General(),
              InventoryManagement(),
              ShippingDetails(),
              ProdAttributes(),
              Center(
                child: Text("1 "),
              ),
              ImageDetails(),
            ],
          ),
          persistentFooterButtons: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_provider.imageFiles!.isEmpty) {
                      _services.scaffold(
                          context, "Product Images field cannot be empty!");
                      return;
                    }
                    if (formKey.currentState!.validate()) {
                      EasyLoading.show(status: 'Please Wait');
                      //Save to FireStore
                      _provider.getFormData(seller: {
                        'name': _vendorProvider.vendor!.businessName,
                        'uid': _services.user!.uid
                      });
                      _services
                          .uploadFiles(
                              images: _provider.imageFiles,
                              ref:
                                  'products/${_vendorProvider.vendor!.businessName}/${_provider.productData!['productName']}',
                              provider: _provider)
                          .then((value) => {
                                if (value.isNotEmpty)
                                  {
                                    //save to firebase
                                    _services
                                        .addProducts(
                                            data: _provider.productData,
                                            context: context)
                                        .then((value) {
                                      EasyLoading.dismiss();
                                      setState(() {
                                        _provider.clearProductData();

                                      });
                                    })
                                  }
                              });
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
