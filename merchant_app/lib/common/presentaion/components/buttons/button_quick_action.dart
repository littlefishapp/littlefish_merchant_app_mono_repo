import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class ButtonQuickAction extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  final String title;
  final double width;
  final double? height;

  const ButtonQuickAction({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
    this.width = 80,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final textUsed = TextFormatter.formatStringFromFontCasing(title);

    return SizedBox(
      height: height,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).extension<AppliedSurface>()?.brandSubTitle,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              child: Icon(icon),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: width,
                child: context.paragraphSmall(
                  textUsed,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.primary,
                  alignLeft: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
