import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryit_vendor_app/provider/product_provider.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({Key? key}) : super(key: key);

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  Widget _formField({
    String? label,
    TextInputType? inputType,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        label: Text(label!),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
      },
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          _formField(
              label: 'Enter Product Name',
              inputType: TextInputType.name,
              onChanged: (value) {
                //save in provider
                provider.getFormData(productName:value);
              })
        ]),
      );
    });
  }
}
