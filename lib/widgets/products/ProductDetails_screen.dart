import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';

class ProductDetails extends StatelessWidget {
 final Product? product ;
 final String? productId;
   const ProductDetails({ this.product ,  this.productId,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text(product!.productName!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
             Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                  children: product!.imageUrls!.map((e){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(imageUrl: e),
                    );
                  }).toList(),



              ),
            ),
            const SizedBox(height: 10,),
            Text("ProductName:\t \t"+product!.productName! , style: const TextStyle(fontSize: 16 ,fontWeight: FontWeight.bold),),

          ],
        ),
      ),
    );
  }
}
