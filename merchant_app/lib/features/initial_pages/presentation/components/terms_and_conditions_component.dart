import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/viewer/resource_viewer.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/terms_and_conditions_entity.dart';

class TermsAndConditionsComponent extends StatelessWidget {
  final TermsAndConditionsEntity config;

  const TermsAndConditionsComponent({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13),
          children: [..._buildPrefixSpans(context), _buildLinkSpan(context)],
        ),
      ),
    );
  }

  List<TextSpan> _buildPrefixSpans(BuildContext context) {
    final Color color = _textColor(context);
    return config.prefixTexts
        .map(
          (t) => TextSpan(
            text: t,
            style: TextStyle(color: color),
          ),
        )
        .toList();
  }

  TextSpan _buildLinkSpan(BuildContext context) {
    final Color color = _textColor(context);
    return TextSpan(
      text: config.linkText,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
      recognizer: TapGestureRecognizer()
        ..onTap = () => Navigator.of(context).push(
          CustomRoute(
            builder: (_) => ResourceViewer(
              url: AppVariables.termsAndConditions,
              title: config.title,
              isAsset: config.isAsset,
            ),
          ),
        ),
    );
  }

  Color _textColor(BuildContext context) {
    final AppliedTextIcon? theme = Theme.of(
      context,
    ).extension<AppliedTextIcon>();
    final Color primary = theme?.primary ?? Colors.black;
    final Color inverse = theme?.inversePrimary ?? Colors.white;
    return config.inverseColour ? inverse : primary;
  }
}
