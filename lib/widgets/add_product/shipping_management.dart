import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryit_vendor_app/firebase_services.dart';
import 'package:tryit_vendor_app/provider/product_provider.dart';

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  State<ShippingDetails> createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails>  with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  FirebaseServices _services = FirebaseServices();
  bool? chargeShipping = false;
  int? shippingCharge;
  int? reorderLevel;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<ProductProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Charge Shipping', style: TextStyle(color: Colors.grey),),

                value: chargeShipping,
                onChanged: (value) {
                  setState(() {
                    chargeShipping = value;
                    provider.getFormData(chargeShipping: value);
                  });
                }),
            if (chargeShipping == true)
              _services.formField(
                  label: 'Shipping Charge',
                  hint: 'As a percentage',
                  inputType: TextInputType.number,
                  onChanged: (value) {
                    provider.getFormData(shippingCharge: int.parse(value));
                  }),
          ],
        ),
      );
    });
  }
}
