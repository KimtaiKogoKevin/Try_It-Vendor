import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryit_vendor_app/firebase_services.dart';
import 'package:tryit_vendor_app/provider/product_provider.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({Key? key}) : super(key: key);

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseServices _services = FirebaseServices();
  final List<String> _categories = [];
  String? selectedCategory;

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

  Widget _categoryDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      hint: const Text(
        'Select Category',
        style: TextStyle(fontSize: 18),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue!;
          provider.getFormData(category: selectedCategory);
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black),),
        );
      }).toList(),
      validator: (value) {
        return 'Selected Category';
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getCategories();
    super.initState();
  }

  getCategories() {
    _services.categories.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          _categories.add(element['catName']);
        });
      });
    });
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
                provider.getFormData(productName: value);
              }),
          SizedBox(height:30),

          _formField(
              label: 'Price: KSH:',
              inputType: TextInputType.number,
              onChanged: (value) {
                //save in provider
                provider.getFormData(regularPrice: int.parse(value));
              }),

          SizedBox(height:30),

          _categoryDropDown(provider),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.productData!['mainCategory'] ??
                        ' Select Main Category',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  if(selectedCategory!=null)
                  InkWell(
                      onTap: () {
                        showDialog(context: context, builder: (context) {
                          return MainCategoryList(
                            selectedCategory: selectedCategory,
                            provider: provider,
                          );
                        }).whenComplete(() {
                        setState((){

                        });
                        });
                      },
                      child: const Icon(Icons.arrow_drop_down)),
                ]),
          ),
          const Divider(
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.productData!['subCategory'] ??
                        ' Select Sub Category',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  if(provider.productData!['mainCategory']!=null)
                    InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (context) {
                            return SubCategoryList(
                              selectedMainCategory: provider.productData!['mainCategory'],
                              provider: provider,
                            );
                          }).whenComplete(() {
                            setState((){

                            });
                          });
                        },
                        child: const Icon(Icons.arrow_drop_down)),
                ]),
          ),
         SizedBox(height:30),

        ]),
      );
    });
  }
}

class MainCategoryList extends StatelessWidget {
  final String? selectedCategory;

  const MainCategoryList({ this.provider, this.selectedCategory, Key? key})
      : super(key: key);
  final ProductProvider? provider;

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Dialog(
        child: FutureBuilder<QuerySnapshot>(
          future: _services.mainCategories.where(
              'category', isEqualTo: selectedCategory).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.data!.size == 0) {
              return Center(child: const Text('No Main Categories'));
            }

            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  return ListTile(
                      onTap: () {
                        provider!.getFormData(
                            mainCategory: snapshot.data!
                                .docs[index]['mainCategory']
                        );
                        Navigator.pop(context);
                      },
                      title: Text(snapshot.data!.docs[index]['mainCategory'],)
                  );
                });
          },

        )
    );
  }
}
class SubCategoryList extends StatelessWidget {
  final String? selectedMainCategory;

  const SubCategoryList({ this.provider, this.selectedMainCategory, Key? key})
      : super(key: key);
  final ProductProvider? provider;

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Dialog(
        child: FutureBuilder<QuerySnapshot>(
          future: _services.subCategories.where(
              'mainCategory', isEqualTo: selectedMainCategory).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.data!.size == 0) {
              return const Center(child: Text('No Sub Categories'));
            }

            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  return ListTile(
                      onTap: () {
                        provider!.getFormData(
                          subCategory: snapshot.data!.docs[index]['subCatName']
                        );
                        Navigator.pop(context);

                      },
                      title: Text(snapshot.data!.docs[index]['subCatName'],)
                  );
                });
          },

        )
    );
  }
}


