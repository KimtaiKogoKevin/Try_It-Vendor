import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tryit_vendor_app/firebase_services.dart';

import '../../model/product_model.dart';

class ProductDetails extends StatefulWidget {
  final Product? product;

  final String? productId;

  const ProductDetails({this.product, this.productId, Key? key})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  bool editable =true ;

  final _productName = TextEditingController();
  final _productDescription = TextEditingController();

  final brand = TextEditingController();
  final discount = TextEditingController();
  final regularPrice = TextEditingController();
  final category = TextEditingController();
  final mainCategory = TextEditingController();
  final subCategory = TextEditingController();
  final reorderLevel = TextEditingController();
  final stockOnHand = TextEditingController();
  final shippingCharge = TextEditingController();
  final quantityUnit = TextEditingController();

  Widget _textField(
      {TextEditingController? controller,
      String? label,
      TextInputType? keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return '$label cannot be null';
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _productName.text = widget.product!.productName!;
      _productDescription.text = widget.product!.productDescription!;

      brand.text = widget.product!.brandName!;
      discount.text = widget.product!.discountPrice!.toString();
      regularPrice.text = widget.product!.regularPrice!.toString();
      category.text = widget.product!.category!;
      mainCategory.text = widget.product!.mainCategory!;
      subCategory.text = widget.product!.subCategory!;
      reorderLevel.text = widget.product!.reorderLevel!.toString();
      stockOnHand.text = widget.product!.stockOnHand!.toString();
      shippingCharge.text = widget.product!.shippingCharge!.toString();
      quantityUnit.text = widget.product!.selectedUnit!.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.product!.productName!),
          actions: [
            editable ? 
            IconButton(onPressed: (){
              setState(() {
                editable = false;
              });
            }, icon: const Icon(Icons.edit_outlined)) : IconButton(onPressed: (){
              setState(() {
                editable = true;

              });
            }, icon: Icon(Icons.save))
          ] 
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: [
              AbsorbPointer(
                absorbing: editable,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.product!.imageUrls!.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(imageUrl: e),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Brand ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _textField(
                                label: 'Brand',
                                controller: brand,
                                keyboardType: TextInputType.text))
                      ],
                    ),
                    Row(children: [
                      const Text(
                        'Name ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _textField(
                              label: 'Name',
                              controller: _productName,
                              keyboardType: TextInputType.text)),
                    ]),
                    Row(children: [
                      const Text(
                        'Description ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _textField(
                              label: 'Description',
                              controller: _productDescription,
                              keyboardType: TextInputType.text)),
                    ]),
                    Row(
                      children: [
                        if (widget.product!.discountPrice != null)
                          Expanded(
                            child: Row(
                              children: [
                                const Text(
                                  'Discount Price KSH ',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                    child: _textField(
                                        label: 'Discounted Price',
                                        controller: discount,
                                        keyboardType: TextInputType.number)),
                              ],
                            ),
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(children: [
                            const Text(
                              'Regular Price KSH ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                                child: _textField(
                                    label: 'Regular Price',
                                    controller: regularPrice,
                                    keyboardType: TextInputType.number)),
                          ]),
                        ),
                      ],
                    ),
                    Row(children: [
                      const Text(
                        ' Category',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Container(
                              child: _textField(
                                  keyboardType: TextInputType.none,
                                  controller: category,
                                  label: 'Category'))),
                    ]),
                    if (mainCategory != null)
                      Row(children: [
                        const Text(
                          ' Main Category',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                            child: _textField(
                                keyboardType: TextInputType.none,
                                controller: mainCategory,
                                label: 'MainCategory')),
                      ]),
                    if (subCategory != null)
                      Row(children: [
                        const Text(
                          ' Sub Category',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                            child: _textField(
                                keyboardType: TextInputType.none,
                                controller: subCategory,
                                label: 'SubCategory')),
                      ]),
                    if (widget.product!.manageInventory == true)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Text(
                                      'Sku Number ',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                        child: Text(widget.product!.skuNumber
                                            .toString())),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Row(children: [
                                  const Text(
                                    'Re order level ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                      child: _textField(
                                          label: 'Reorder Level',
                                          controller: reorderLevel,
                                          keyboardType: TextInputType.number)),
                                ]),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Text(
                                      'Quantity Unit ',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                        child: _textField(
                                            label: 'Quantity Unit',
                                            controller: quantityUnit,
                                            keyboardType:
                                                TextInputType.number)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Row(children: [
                                  const Text(
                                    'Stock On Hand ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                      child: _textField(
                                          label: 'Stock On Hand',
                                          controller: stockOnHand,
                                          keyboardType: TextInputType.number)),
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (widget.product!.chargeShipping == true)
                      Row(children: [
                        const Text(
                          'shippingCharge',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                            child: _textField(
                                label: 'shippingCharge',
                                controller: shippingCharge,
                                keyboardType: TextInputType.text)),
                      ]),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
