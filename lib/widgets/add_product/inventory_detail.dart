import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryit_vendor_app/firebase_services.dart';
import 'package:tryit_vendor_app/provider/product_provider.dart';

class InventoryManagement extends StatefulWidget {

  const InventoryManagement({Key? key}) : super(key: key);

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  FirebaseServices _services = FirebaseServices();

  bool? manageInventory = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<ProductProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          _services.formField(
              label: 'SKU',
              hint: 'stock keeping unit number',
              inputType: TextInputType.text,
              onChanged: (value) {
                provider.getFormData(skuNumber: int.parse(value));
              }),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Manage Inventory', style:TextStyle(color:Colors.grey)),
              value: manageInventory, onChanged: (value){
            setState(() {
              manageInventory = value;
              provider.getFormData(manageInventory: value);
            });
          }) ,
          if(manageInventory==true)
            Column(
              children: [
                _services.formField(
                    label: 'Current Stock',
                    inputType: TextInputType.text,
                    onChanged: (value) {
                      provider.getFormData(stockOnHand:int.parse(value));
                    }),
                const SizedBox(height: 20,),
                _services.formField(
                    label: 're-Order Level',
                    hint: 'Threshold at which you must replenish your stock',
                    inputType: TextInputType.text,
                    onChanged: (value) {
                      provider.getFormData(reorderLevel: int.parse(value));
                    }),
              ],
            )
        ]),
      );
    });
  }
}
