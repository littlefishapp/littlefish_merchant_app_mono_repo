// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/dashed_border.dart';
import 'package:littlefish_merchant/models/shared/image_representable.dart';

class DashedImageUpload extends StatelessWidget {
  final ImageRepresentable image;
  final String label;
  final String? helperText;
  final Color colour;
  final void Function() onTap;
  final double borderRadius, imageSize;
  final double? height, width;
  final EdgeInsets padding;

  const DashedImageUpload({
    Key? key,
    required this.image,
    required this.label,
    this.helperText,
    required this.colour,
    required this.onTap,
    this.borderRadius = 6.0,
    this.imageSize = 24,
    this.height,
    this.width,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DashedBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        color: colour,
        child: SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: Container(
              height: height,
              width: width ?? double.infinity,
              padding: padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image.buildWidget(size: imageSize, colour: colour),
                  const SizedBox(height: 8),
                  context.paragraphSmall(label, color: colour, isBold: true),
                  if (helperText != null)
                    context.paragraphSmall(helperText!, color: colour),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
