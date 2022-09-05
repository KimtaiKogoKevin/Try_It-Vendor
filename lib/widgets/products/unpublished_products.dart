import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:tryit_vendor_app/firebase_services.dart';
import 'package:tryit_vendor_app/model/product_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tryit_vendor_app/widgets/products/ProductCard.dart';

class UnpublishedProducts extends StatelessWidget {
  const UnpublishedProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return FirestoreQueryBuilder<Product>(
        query: productQuery(false),
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('error ${snapshot.error}');
          }

          return ProductCard(services: _services, snapshot: snapshot);
        });
  }
}
