import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:search_page/search_page.dart';
import 'package:tryit_vendor_app/firebase_services.dart';

import '../../model/product_model.dart';
import 'ProductDetails_screen.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({this.services, this.snapshot});

  final FirebaseServices? services;
  final  FirestoreQueryBuilderSnapshot? snapshot ;

  @override
  State<ProductCard> createState() => _ProductCardState();

}

class _ProductCardState extends State<ProductCard> {
  FirebaseServices _services = FirebaseServices();
  List<Product> productsList=[];
  @override
  void initState() {
    getProductList();
    super.initState();
  }

  Widget _products(){
    return  ListView.builder(
      itemCount: widget.snapshot!.docs.length,
      itemBuilder: (context, index) {
        Product product = widget.snapshot!.docs[index].data();
        String id = widget.snapshot!.docs[index].id;
        var discount =
            (product.regularPrice! - product.discountPrice!) /
                product.regularPrice! *
                100;

        return Slidable(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProductDetails(
                              product: product,
                              productId: id,
                            )));
              },
              child: Card(
                child: Row(
                  children: [
                    SizedBox(
                        height: 100,
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                              imageUrl:
                              product.imageUrls![0]),
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            10, 40, 0, 20),
                        child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  'Name: \t \t \t' +
                                      product.productName!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  ' Price: \t  KSH\t' +
                                      _services
                                          .formattedCurrency(
                                          product
                                              .regularPrice)
                                          .toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.bold,
                                      decoration:
                                      TextDecoration
                                          .lineThrough,
                                      color: Colors.red)),
                              const SizedBox(
                                height: 5,
                              ),
                              if (product.discountPrice !=
                                  null)
                                Text(
                                    'Discount:' +
                                        discount
                                            .toInt()
                                            .toString() +
                                        '% \tKSH\t' +
                                        _services
                                            .formattedCurrency(
                                            product
                                                .discountPrice)
                                            .toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.red)),
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 3,
                  onPressed: (context) {
                    //  _services.products.doc(id).delete();
                    _services.scaffold(context, "delete");
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'delete',
                ),
                SlidableAction(
                  flex: 3,
                  onPressed: (context) {
                    _services.products.doc(id).update({
                      'approved': product.approved == false
                          ? true
                          : false
                    });
                  },
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  icon: Icons.approval,
                  label: 'UnPublish',
                ),
              ],
            ));
      },
    );
  }
  getProductList(){

    return widget.snapshot!.docs.forEach((element) {
      Product product = element.data();
      setState(() {
        productsList.add(
            Product(
                approved: product.approved,
                brandName: product.brandName,
                productName: product.productName,
                productDescription: product.productDescription,
                regularPrice: product.regularPrice,
                discountPrice: product.discountPrice,
                category: product.category,
                mainCategory: product.mainCategory,
                subCategory: product.subCategory,
                manageInventory: product.manageInventory,
                chargeShipping: product.chargeShipping,
                skuNumber: product.skuNumber,
                stockOnHand: product.stockOnHand,
                reorderLevel: product.reorderLevel,
                shippingCharge: product.shippingCharge,
                selectedUnit: product.selectedUnit,
                seller: product.seller,
                otherDetails: product.otherDetails,
                discountDateSchedule: product.discountDateSchedule,
                imageUrls: product.imageUrls ,
              productId: element.id

            )
        );
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  onTap: (){
                    showSearch(
                      context: context,
                      delegate: SearchPage<Product>(
                        // onQueryUpdate: (s) => print(s),
                        items: productsList,
                        searchLabel: 'Search Products',
                        suggestion: _products(),
                        failure: Center(
                          child: Text('No Products found :('),
                        ),
                        filter: (product) => [
                          product.productName,
                          product.category,
                          product.subCategory,
                        ],
                        builder: (product) =>    Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProductDetails(
                                            product: product,
                                            productId: product.productId ,
                                          ))).whenComplete(() {
                                            setState(() {
                                              productsList.clear();
                                              getProductList();
                                            });
                              });
                            },
                            child: Card(
                              child: Row(
                                children: [
                                  SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CachedNetworkImage(
                                            imageUrl:
                                            product.imageUrls![0]),
                                      )),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 40, 0, 20),
                                      child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                'Name: \t \t \t' +
                                                    product.productName!,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                ' Price: \t  KSH\t' +
                                                    _services
                                                        .formattedCurrency(
                                                        product
                                                            .regularPrice)
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    decoration:
                                                    TextDecoration
                                                        .lineThrough,
                                                    color: Colors.red)),

                                          ]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        //     ListTile(
                        // title: Text(prosuct.),
                        // subtitle: Text(person.surname),
                        // trailing: Text('${person.age} yo'),
                        // ),
                      ),);
                  },

                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(

                      icon: const Icon(Icons.search,color: Colors.white,),
                      hintText: 'Search Products',
                      hintStyle: const TextStyle(color: Colors.white),
                      contentPadding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),

                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Total product count : ${widget.snapshot!.docs.length}'),
                ),
              ),
              Expanded(
                child: _products()
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
