// Flutter imports:
import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.color,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Function onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return button(context, text, icon: icon, color: color);
  }

  Widget button(
    BuildContext context,
    String text, {
    required IconData icon,
    Color? color,
  }) => Tooltip(
    message: text,
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(40),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        child: SizedBox(
          height: 64,
          width: 64,
          child: Icon(
            icon,
            size: 36,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        onTap: () {
          onTap();
        },
      ),
    ),
  );
}
