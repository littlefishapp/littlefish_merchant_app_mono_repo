import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/shared/image_representable.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/utils/linked_account_utils.dart';

class ProviderImageDisplay extends StatelessWidget {
  final String imagePath;
  final String providerName;
  final double width;
  final double height;

  const ProviderImageDisplay({
    Key? key,
    required this.imagePath,
    this.width = 88,
    this.height = 88,
    required this.providerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerImage = LinkedAccountUtils.getProviderDisplayImage(
      providerName: providerName,
      imageURI: imagePath,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: AnyImageRepresentable(
        name: providerImage,
        width: width,
        height: height,
      ).buildWidget(),
    );
  }
}
