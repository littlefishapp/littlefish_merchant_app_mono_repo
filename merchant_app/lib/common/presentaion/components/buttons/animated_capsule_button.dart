import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class AnimatedCapsuleButton extends StatelessWidget {
  final Function(BuildContext context)? onTap;
  final String text;
  final bool? disabled;
  final Color? textColor, buttonColor;
  final Animation<double> controller;
  final BuildContext parentContext;
  // final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> margin;
  final Animation<Color?> color;
  final IconData? icon;

  final double radius, elevation;

  AnimatedCapsuleButton({
    Key? key,
    this.onTap,
    required this.text,
    this.textColor = Colors.white,
    this.buttonColor,
    this.radius = 4.0,
    this.elevation = 2.0,
    this.icon,
    required this.parentContext,
    required this.controller,
    this.disabled,
  }) : height = Tween<double>(begin: 32, end: 40).animate(
         CurvedAnimation(
           parent: controller,
           curve: const Interval(0, 0.9, curve: Curves.ease),
         ),
       ),
       margin =
           Tween<EdgeInsets>(
             begin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
             end: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
           ).animate(
             CurvedAnimation(
               parent: controller,
               curve: const Interval(0, 0.9, curve: Curves.ease),
             ),
           ),
       color =
           ColorTween(
             begin: Theme.of(parentContext).colorScheme.primary,
             end: Theme.of(parentContext).colorScheme.secondary,
           ).animate(
             CurvedAnimation(
               parent: controller,
               curve: const Interval(0, 0.9, curve: Curves.ease),
             ),
           ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final textUsed = TextFormatter.formatStringFromFontCasing(text);
    return AnimatedBuilder(
      animation: controller,
      builder: (ctx, widget) => chargeButton(parentContext, textUsed),
    );
  }

  Container chargeButton(BuildContext context, String textUsed) => Container(
    margin: margin.value,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        backgroundColor: color.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        disabledBackgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: disabled == true
          ? null
          : () => onTap == null
                ? showComingSoon(
                    context: context,
                    description: 'Button: $textUsed',
                  )
                : onTap!(context),
      child: SizedBox(
        height: height.value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: icon == null
                  ? Text(
                      textUsed,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        //fontFamily: UIStateData.primaryFontFamily,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(icon, color: textColor),
                        Visibility(
                          visible: textUsed.isNotEmpty,
                          child: const SizedBox(width: 8),
                        ),
                        Text(
                          textUsed,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            //fontFamily: UIStateData.primaryFontFamily,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
