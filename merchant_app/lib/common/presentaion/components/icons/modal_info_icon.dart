import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_helper.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/info_icon.dart';
import 'package:littlefish_merchant/models/enums.dart';

class ModalInfoIcon extends StatelessWidget {
  final StatusType status;
  final bool isBoxIcon;
  final IconData? iconData;

  const ModalInfoIcon({
    super.key,
    required this.status,
    required this.isBoxIcon,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return InfoIcon(
      iconData: iconData ?? ModalHelper.getIconByStatus(status),
      iconColour: ModalHelper.getstrokeColour(
        status: status,
        context: context,
        isBoxIcon: isBoxIcon,
      ),
      backgroundColour: ModalHelper.getFillColour(
        status: status,
        context: context,
        isBoxIcon: isBoxIcon,
      ),
      useOutlineStyling: true,
      enableOpacity: false,
      borderColour: ModalHelper.getFillColour(
        status: status,
        context: context,
        isBoxIcon: isBoxIcon,
      ),
    );
  }
}
