import 'package:flutter/material.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/ui/online_store/products/viewmodels/product_vm.dart';

import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:quiver/strings.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';

class ProductGalleryPage extends StatefulWidget {
  final StoreProduct? item;

  final ProductVM? vm;

  const ProductGalleryPage({Key? key, required this.item, required this.vm})
    : super(key: key);

  @override
  State<ProductGalleryPage> createState() => _ProductGalleryPageState();
}

class _ProductGalleryPageState extends State<ProductGalleryPage> {
  bool _uploading = false;

  void setUploading(bool value) {
    if (mounted) {
      setState(() {
        _uploading = value;
      });
    } else {
      _uploading = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FileManager()
              .chooseAndUploadImage(
                context,
                groupId: widget.item!.businessId,
                itemId: widget.item!.id,
                sectionId: 'products',
              )
              .then((result) {
                if (result != null) {
                  widget.item!.gallery!.add(result.downloadUrl);
                }
              });
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: <Widget>[
          if (_uploading)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const LinearProgressIndicator(),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Text(
              'Upload your feature and gallery images',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          featureImage(context, widget.vm),
          gallery(context, widget.vm, widget.item!),
        ],
      ),
    );
  }

  SizedBox featureImage(context, ProductVM? vm) => SizedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        isBlank(widget.item!.featureImageAddress)
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: InkWell(
                    onTap: () async {
                      setUploading(true);
                      await FileManager()
                          .chooseAndUploadImage(
                            context,
                            groupId: widget.item!.businessId,
                            itemId: widget.item!.productId,
                            sectionId: 'products',
                          )
                          .then((result) {
                            if (result != null) {
                              widget.item!.featureImageAddress =
                                  result.fullPath;
                              widget.item!.featureImageUrl = result.downloadUrl;
                            }
                          })
                          .whenComplete(() => setUploading(false));
                    },
                    child: const Material(
                      child: Center(child: Icon(Icons.add, size: 64)),
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: InkWell(
                    onTap: () async {
                      setUploading(true);
                      await FileManager()
                          .chooseAndUploadImage(
                            context,
                            groupId: widget.item!.businessId,
                            itemId: widget.item!.productId,
                            sectionId: 'products',
                          )
                          .then((result) {
                            if (result != null) {
                              widget.item!.featureImageAddress =
                                  result.fullPath;
                              widget.item!.featureImageUrl = result.downloadUrl;
                            }
                          })
                          .whenComplete(() => setUploading(false));
                    },
                    child: Material(
                      child: FirebaseImage(
                        imageAddress: widget.item!.featureImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    ),
  );

  Container gallery(context, vm, StoreProduct product) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: product.gallery?.length ?? 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) => Stack(
        children: <Widget>[
          FirebaseImage(imageAddress: product.gallery![index]),
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const DeleteIcon(),
              onPressed: () {
                if (mounted) {
                  setState(() {
                    widget.item!.gallery!.removeAt(index);
                  });
                } else {
                  widget.item!.gallery!.removeAt(index);
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}
