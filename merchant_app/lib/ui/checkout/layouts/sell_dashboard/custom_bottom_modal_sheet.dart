import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';

void showCustomBottomSheet({
  required BuildContext context,
  required List<Widget> items,
  EdgeInsetsGeometry? padding,
  double cornerRadius = 1.0,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).extension<AppliedSurface>()?.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(cornerRadius)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 74.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                    ),
                  ),
                ),
                ...items.map<Widget>((Widget item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: item,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    },
  );
}
