import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/percentage_progress_indicator.dart';
import 'package:littlefish_merchant/models/shared/image_representable.dart';
import 'package:quiver/strings.dart';

class SetupProgressTile extends StatelessWidget {
  final ImageRepresentable? image;
  final String title;
  final String? description;
  final double progress, imageSize;
  final Color? imageColour, percentageBarColour;
  final TextStyle? titleStyle, descriptionStyle;

  const SetupProgressTile({
    Key? key,
    required this.title,
    required this.progress,
    this.description,
    this.image,
    this.imageSize = 48,
    this.imageColour,
    this.percentageBarColour,
    this.titleStyle,
    this.descriptionStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null)
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 16),
              child: image!.buildWidget(size: imageSize, colour: imageColour),
            ),
          _getTitle(context: context, text: title),
          if (isNotBlank(description))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _getDescription(context: context, text: description!),
            ),
          PercentageProgressIndicator(
            percentage: progress,
            color:
                percentageBarColour ??
                Theme.of(context).extension<AppliedTextIcon>()?.brand,
          ),
        ],
      ),
    );
  }

  _getTitle({required BuildContext context, required String text}) {
    return Center(
      child: context.labelLarge(
        text,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
        isBold: true,
      ),
    );
  }

  _getDescription({required BuildContext context, required String text}) {
    return Center(
      child: context.paragraphMedium(
        text,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
    );
  }
}
