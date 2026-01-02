import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';

class CheckOutBarCodeScanner extends StatelessWidget {
  final void Function() onTap;
  final Color color;

  const CheckOutBarCodeScanner({
    Key? key,
    required this.onTap,
    this.color = Colors.black45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        AppAssets.barcodeScannerSvg,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
      onPressed: onTap,
      splashRadius: 64,
    );
  }
}
