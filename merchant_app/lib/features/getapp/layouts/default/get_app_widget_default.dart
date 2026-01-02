import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GetAppWidgetDefault extends StatefulWidget {
  final String url;

  const GetAppWidgetDefault({super.key, required this.url});

  @override
  State<GetAppWidgetDefault> createState() => _GetAppWidgetDefaultState();
}

class _GetAppWidgetDefaultState extends State<GetAppWidgetDefault> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          context.labelLarge('Scan To Download App!', isBold: true),
          const SizedBox(height: 12),
          CardSquareFlat(
            child: QrImageView(
              data: widget.url,
              version: QrVersions.auto,
              size: MediaQuery.of(context).size.width * 0.5,
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: context.labelSmall(
              'Scan the QR code above to download the app',
              isBold: false,
              alignLeft: false,
            ),
          ),
          if (AppVariables.isPOSBuild)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(MdiIcons.apple, size: 32),
                  const SizedBox(width: 8),
                  Icon(MdiIcons.android, size: 32),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
