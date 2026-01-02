import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';

class AddItemWithIconButton extends StatelessWidget {
  final Function(BuildContext context)? onTap;
  final String text;
  final bool? disabled;

  const AddItemWithIconButton({
    Key? key,
    this.onTap,
    required this.text,
    this.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Color(0xFFF6F6F6),
        ),
        height: 48,
        child: ButtonText(
          icon: Icons.add,
          text: text,
          onTap: (_) {
            if (onTap != null) {
              onTap!(context);
            }
          },
        ),
      ),
    );
  }
}
