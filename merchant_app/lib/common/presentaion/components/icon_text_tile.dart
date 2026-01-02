// flutter imports
import 'package:flutter/material.dart';

class IconTextTile extends StatelessWidget {
  final Widget icon;
  final Text text;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double height;

  const IconTextTile({
    required this.icon,
    required this.text,
    this.onTap,
    this.padding,
    this.height = 56,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {if (onTap != null) onTap!()},
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Padding(
              padding:
                  padding ??
                  const EdgeInsets.only(
                    left: 32,
                    top: 16,
                    right: 16,
                    bottom: 16,
                  ),
              child: icon,
            ),
            text,
          ],
        ),
      ),
    );
  }
}
