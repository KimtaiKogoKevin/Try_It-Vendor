import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider.dart';

class ImageDetails extends StatefulWidget {
  const ImageDetails({Key? key}) : super(key: key);

  @override
  State<ImageDetails> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>?> pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    return images;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer <ProductProvider>(builder: (context, provider,child){
      return  Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextButton(
                child: const Text('Add Product Image'),
                onPressed: () {
                  pickImage().then((value) {
                    var list = value!.forEach((image) {
                      setState(() {
                        provider.getImageFile(image);
                      });
                    });
                  });
                }),
            Center(
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: provider.imageFiles!.length,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onLongPress: () {
                            setState(() {
                              provider.imageFiles!.removeAt(index);
                            });
                          },
                          child: provider.imageFiles == null
                              ? Container(
                            child: const Center(
                              child: Text('No Images selected'),
                            ),
                          )
                              : Image.file(File(provider.imageFiles![index].path))),
                    );
                  }),
            )
          ],
        ),
      );
    });
  }
}
