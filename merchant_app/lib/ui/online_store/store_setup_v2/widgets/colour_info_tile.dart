import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/dashed_border.dart';

class ColourInfoTile extends StatelessWidget {
  final String title;
  final String? description;
  final Color? colour;
  final void Function()? onTap;

  const ColourInfoTile({
    Key? key,
    required this.title,
    this.description,
    this.colour,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
      leading: InkWell(
        onTap: onTap,
        child: colour == null
            ? _dashedEmptyCircle()
            : CircleAvatar(backgroundColor: colour!),
      ),
      title: _getText(
        context: context,
        text: title,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      subtitle: description != null
          ? _getText(
              context: context,
              text: description!,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            )
          : null,
    );
  }

  Widget _dashedEmptyCircle() {
    return DashedBorder(
      strokeWidth: 3,
      borderRadius: BorderRadius.circular(30),
      child: CircleAvatar(backgroundColor: colour ?? Colors.white),
    );
  }

  Text _getText({
    required BuildContext context,
    required String text,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
        //fontFamily: UIStateData.primaryFontFamily,
      ),
    );
  }
}
