import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryit_vendor_app/provider/product_provider.dart';

class ProdAttributes extends StatefulWidget {
  const ProdAttributes({Key? key}) : super(key: key);

  @override
  State<ProdAttributes> createState() => _ProdAttributesState();
}

class _ProdAttributesState extends State<ProdAttributes>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String? brandName;
  String? selectedUnit;

  final List<String> _sizeList = [];
   final List<String> _unit = ["Kg" ,"gram", "ml" , "litre" , "metres" ,"cm"];

  final _sizeText = TextEditingController();
  bool? savedSize = false;
  bool? _entered = false;

  Widget _formField({
    String? label,
    TextInputType? inputType,
    void Function(String)? onChanged,
    int? maxLines,
    int? minLines,
    String? hint,
  }) {
    return TextFormField(
      keyboardType: inputType,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.indigo),
        ),
        label: Text(label!),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 8, color: Colors.grey),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
        return null;
      },
      onChanged: onChanged,
    );
  }

  Widget _unitDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: selectedUnit,

      hint: const Text(
        'Size / quantity of the Product',
        style: TextStyle(fontSize: 18),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.grey),
      onChanged: (String? newValue) {
        setState(() {
          selectedUnit = newValue!;
          provider.getFormData(selectedUnit: newValue);
        });
      },
      items: _unit.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black),),
        );
      }).toList(),
      validator: (value) {
        if(value!.isEmpty){
          return 'Select Unit';

        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _formField(
                label: 'Brand Name',
                inputType: TextInputType.text,
                onChanged: (value) {
                  provider.getFormData(brandName: value);
                }),
            const SizedBox(
              height: 20,
            ),
         _unitDropDown(provider) ,

            Row(children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Size'),
                  ),
                  controller: _sizeText,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _entered = true;
                      });
                    }
                  },
                ),
              ),
              if (_entered == true)
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sizeList.addAll([_sizeText.text]);
                        _sizeText.clear();
                        _entered = false;
                        savedSize = false;
                      });
                    },
                    child: const Text('Add')),
            ]),
            const SizedBox(height: 10),
            if (_sizeList.isNotEmpty)
              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _sizeList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onLongPress: () {
                          setState(() {
                            _sizeList.removeAt(index);

                            provider.getFormData(sizeList: _sizeList);
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.orangeAccent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              _sizeList[index],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (_sizeList.isNotEmpty)
              Column(
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Long Press To delete',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      )),
                  if (savedSize == false)
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text(savedSize == true && _sizeList.isNotEmpty
                              ? 'Saved'
                              : 'Click to Save'),
                          onPressed: () {
                            setState(() {
                              savedSize = true;
                              provider.getFormData(sizeList: _sizeList);
                            });
                          },
                        ),
                      ),
                    ]),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _formField(
                  label: 'Add other details',
                  inputType: TextInputType.multiline,
                  maxLines: 3,
                  onChanged: (value) {
                    provider.getFormData(otherDetails: value);
                  }),
            ),
          ],
        ),
      );
    });
  }
}
