import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  bool editable = true;
  bool? manageInventory;
  bool? chargeShipping;

  DateTime? discountDuration;

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
  final skuNumber = TextEditingController();
  final otherDetails = TextEditingController();

  Widget _textField(
      {TextEditingController? controller,
      String? label,
      TextInputType? keyboardType,
      int? maxLines,
      int? minLines,
      String? Function(String?)? validator}) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: null,
      minLines: null,
      controller: controller,
      validator: validator == null
          ? (value) {
              if (value!.isEmpty) {
                return '$label cannot be null';
              }
              return null;
            }
          : (value) {
              if (int.parse(regularPrice.text) <= int.parse(discount.text)) {
                 _services.scaffold(context, "Regular price is invalid , Discount is greater than regular price!");
              }
              return null;
            },
    );
  }

  updateProduct() {
    EasyLoading.show();
    _services.products.doc(widget.productId).update({
      "brandName": brand.text,
      "productName": _productName.text,
      "productDescription": _productDescription.text,
      "otherDetails": otherDetails.text,
      "discountPrice":int.parse(discount.text),
      "regularPrice":int.parse(regularPrice.text),
      "stockOnHand":int.parse(stockOnHand.text),
      "reorderLevel": int.parse(reorderLevel.text),
      "shippingCharge": int.parse(shippingCharge.text),
      "manageInventory": manageInventory,
      "chargeShipping": chargeShipping,
    }).then((value) {
      setState(() {
        editable = true;

        _services.scaffold(context, "Update Saved");
      });
      EasyLoading.dismiss();
    });
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
      skuNumber.text = widget.product!.skuNumber!.toString();

      quantityUnit.text = widget.product!.selectedUnit!.toString();
      if (widget.product!.discountDateSchedule != null) {
        discountDuration = DateTime.fromMicrosecondsSinceEpoch(
            widget.product!.discountDateSchedule!.microsecondsSinceEpoch);
      }
      manageInventory = widget.product!.manageInventory;
      chargeShipping = widget.product!.chargeShipping;
      otherDetails.text = widget.product!.otherDetails!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text(widget.product!.productName!), actions: [
          editable
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _services.scaffold(context, "Editing enabled");

                      editable = false;
                    });
                  },
                  icon: const Icon(Icons.edit_outlined))
              : IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateProduct();
                    }

                  },
                  icon: const Icon(Icons.save))
        ]),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Text(
                          'Description ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _textField(
                                label: 'Description',
                                controller: _productDescription,
                                maxLines: 5,
                                minLines: 2,
                                keyboardType: TextInputType.multiline)),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Text(
                          'Other Details ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _textField(
                                label: 'other Details',
                                controller: otherDetails,
                                maxLines: 5,
                                minLines: 2,
                                keyboardType: TextInputType.multiline)),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey.shade300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(children: [
                                if (widget.product!.discountPrice != null)
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Discount Price',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                            child: _textField(
                                                label: 'Discount Price',
                                                controller: discount,
                                                keyboardType:
                                                    TextInputType.number ,
                                                validator:(value){
                                                  if(value!.isEmpty){
                                                    return "Value cannot be null";
                                                  }
                                                  if(int.parse(value)> int.parse(discount.text)){
                                                    _services.scaffold(context, "Regular   price  cannot be greater than normal price ");
                                                  }
                                                })),
                                      ],
                                    ),
                                  ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Row(children: [
                                    const Text(
                                      'Regular Price',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                        child: _textField(
                                            label: 'Regular Price ',
                                            controller: regularPrice,
                                            keyboardType: TextInputType.number ,
                                        validator:(value){
                                              if(value!.isEmpty){
                                                return "Value cannot be null";
                                              }
                                              if(int.parse(value)< int.parse(discount.text)){
                                                _services.scaffold(context, "Regular price  cannot be less than discount price ");

                                              }
                                        } )),
                                  ]),
                                ),
                              ]),
                              const SizedBox(height: 10),
                              if (discountDuration != null)
                                Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Discount Valid Until:',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                              _services.formattedDate(
                                                  discountDuration),
                                              style: const TextStyle(
                                                  color: Colors.grey))
                                        ]),
                                    if (editable == false)
                                      ElevatedButton(
                                          onPressed: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      discountDuration!
                                                          .microsecondsSinceEpoch),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(4000),
                                            ).then((value) {
                                              setState(() {
                                                discountDuration = value;
                                              });
                                            });
                                          },
                                          child: const Text('Modify Date'))
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
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
                    ),
                    if (mainCategory != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
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
                      ),
                    if (subCategory != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
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
                      ),
                    if (widget.product!.manageInventory == true)
                      Container(
                        color: Colors.grey.shade300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Manage Inventory'),
                                  value: manageInventory,
                                  onChanged: (value) {
                                    setState(() {
                                      manageInventory = value;
                                      // widget.product!.manageInventory =value;
                                      if (value == false) {
                                        stockOnHand.clear();
                                        reorderLevel.clear();
                                      }
                                    });
                                  }),
                              if (manageInventory == true)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Stock level ',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                              child: _textField(
                                                  label: 'Stock level',
                                                  controller: stockOnHand,
                                                  keyboardType:
                                                      TextInputType.number))
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
                                                keyboardType:
                                                    TextInputType.number)),
                                      ]),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
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
                                      keyboardType: TextInputType.number)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(children: [
                            const Text(
                              'SKU Number ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                                child:
                                    Text(widget.product!.skuNumber.toString())),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      child: Column(
                        children: [
                          CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Charge Shipping?'),
                              value: chargeShipping,
                              onChanged: (value) {
                                setState(() {
                                  chargeShipping = value;
                                  if (value == false) {
                                    shippingCharge.clear();
                                  }
                                });
                              }),
                          if (chargeShipping == true)
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
                            ])
                        ],
                      ),
                    ),
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
