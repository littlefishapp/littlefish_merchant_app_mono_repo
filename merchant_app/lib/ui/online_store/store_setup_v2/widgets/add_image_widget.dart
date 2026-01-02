import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/tools/network_image/flutter_network_image.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/models/shared/image_representable.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/dashed_image_upload.dart';

class UploadImage extends StatelessWidget {
  final void Function() onTap;
  final String? imageUri;
  final double? width, height;
  final double radius;

  const UploadImage({
    Key? key,
    required this.onTap,
    required this.imageUri,
    this.width,
    this.height = 140,
    this.radius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: isBlank(imageUri)
          ? uploadImageWidget(context)
          : image(context, imageUri!),
    );
  }

  Widget uploadImageWidget(BuildContext context) {
    return DashedImageUpload(
      height: height,
      width: width,
      image: IconRepresentable(Icons.add_photo_alternate_outlined),
      label: 'Add Image',
      colour: Theme.of(context).colorScheme.secondary,
      onTap: () {
        onTap();
      },
    );
  }

  Widget image(BuildContext context, String imageUri) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: LittleFishCore.instance
                        .get<FlutterNetworkImage>()
                        .asImageProviderByUrl(imageUri),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700.withOpacity(0.75),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(radius),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Edit Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
