import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:tryit_vendor_app/firebase_services.dart';
import 'package:tryit_vendor_app/model/product_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'ProductDetails_screen.dart';

class PublishedProducts extends StatelessWidget {
  const PublishedProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return FirestoreQueryBuilder<Product>(
        query: productQuery(true),
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('error ${snapshot.error}');
          }
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text('No Published Products'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                Product product = snapshot.docs[index].data();
                String id = snapshot.docs[index].id;
                var discount =
                    (product.regularPrice! - product.discountPrice!) /
                        product.regularPrice! *
                        100;

                return Slidable(
                  
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProductDetails(product: product , productId: id,)));
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
                                      imageUrl: product.imageUrls![0]),
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 40, 20, 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.contain,

                                      child: Text(
                                        'Name: \t \t \t' + product.productName!,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
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
                                                    product.regularPrice)
                                                .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.red)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (product.discountPrice != null)
                                      Text(
                                          'Discount:' +
                                              discount.toInt().toString() +
                                              '% \tKSH\t' +
                                              _services
                                                  .formattedCurrency(
                                                      product.discountPrice)
                                                  .toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                  ]),
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
                          onPressed: (context) {},
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.archive,
                          label: 'delete',
                        ),
                        SlidableAction(
                          flex: 3,
                          onPressed: (context) {

                              _services.products
                                  .doc(id)
                                  .update({'approved': product.approved == false ? true : false});
                            },


                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          icon: Icons.approval,
                          label: 'UnPublish',

                        ),
                      ],
                    ));
              },
            ),
          );
        });
  }
}
