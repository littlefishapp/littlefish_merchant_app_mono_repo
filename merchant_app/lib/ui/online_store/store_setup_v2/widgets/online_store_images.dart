// flutter imports
import 'package:flutter/material.dart';

// packages imports
import 'package:quiver/strings.dart';

// project imports
import 'package:littlefish_merchant/models/shared/image_representable.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/dashed_image_upload.dart';

class OnlineStoreImages extends StatelessWidget {
  final void Function() onTap;
  final String? imageUrl;
  final String? label;
  final String? helperText;

  const OnlineStoreImages({
    Key? key,
    required this.onTap,
    required this.imageUrl,
    this.label,
    this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: isBlank(imageUrl) ? uploadLogoWidget(context) : logoImage(context),
    );
  }

  Widget uploadLogoWidget(BuildContext context) {
    return DashedImageUpload(
      image: IconRepresentable(Icons.add_photo_alternate_outlined),
      label: label ?? 'Upload Logo',
      helperText: helperText ?? 'Click to upload',
      colour: Theme.of(context).colorScheme.secondary,
      onTap: () {
        onTap();
      },
    );
  }

  Widget logoImage(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: FirebaseImage(imageAddress: imageUrl),
    );
  }
}
