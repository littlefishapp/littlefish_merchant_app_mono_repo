import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';

class SetupSectionTile extends StatefulWidget {
  final String title;
  final IconData? leadingIcon;
  final String? description;
  final void Function(BuildContext)? onTap;
  final bool isSelected;
  final Color? selectedColour;
  final bool enabled;

  const SetupSectionTile({
    Key? key,
    required this.title,
    this.description,
    this.leadingIcon,
    this.onTap,
    this.isSelected = false,
    this.selectedColour,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<SetupSectionTile> createState() => _SetupSectionTileState();
}

// TODO(lampian): design system deviation
// Design requires the following but the current primitve colours
// are not setup correctly to support this.
// selected -
// border -> applied border.success  [using text icon primary]
// tile color -> applied surface.success-subTitle [using positeve subTitle]
// leading icon -> applied text icon.successAlt [using positive]
// title -> applied text icon.success  [using positive]
// description -> applied text icon.success [using positive]
// trailing icon -> applied text icon.successAlt [using positive]
// not selected -
// border -> applied border.disabled [design system wrong]
// tile color -> applied surface.primary [using primary]
// leading icon -> applied text icon.secondary [using secondary]
// title -> applied text icon.primary [using primary]
// description -> applied text icon.secondary [using secondary]
// trailing icon -> applied text icon.secondary [using secondary]
class _SetupSectionTileState extends State<SetupSectionTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: getBorderColour(context), width: 1),
        borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
      ),
      tileColor: widget.isSelected
          ? Theme.of(context).extension<AppliedSurface>()?.positiveSubTitle
          : Theme.of(context).extension<AppliedSurface>()?.primary,
      leading: _getLeadingIcon(context),
      title: _getTitle(context),
      subtitle: _getDescription(context),
      trailing: _getTrailingIcon(context),
      enabled: widget.enabled,
      onTap: () {
        if (widget.onTap != null) widget.onTap!(context);
      },
    );
  }

  Color getBorderColour(BuildContext context) {
    Color borderColour = widget.enabled
        ? widget.isSelected
              ? Theme.of(context).extension<AppliedTextIcon>()?.positive ??
                    Colors.black54
              : Theme.of(context).extension<AppliedTextIcon>()?.secondary ??
                    Colors.black54
        : (Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized ??
                  Colors.black54)
              .withAlpha(80);
    return borderColour;
  }

  Icon? _getLeadingIcon(BuildContext context) {
    if (widget.leadingIcon == null) return null;

    Color iconColour = widget.enabled
        ? widget.isSelected
              ? Theme.of(context).extension<AppliedTextIcon>()?.positive ??
                    Colors.black54
              : Theme.of(context).extension<AppliedTextIcon>()?.secondary ??
                    Colors.black54
        : (Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized ??
                  Colors.black54)
              .withAlpha(80);

    return Icon(widget.leadingIcon, color: iconColour, size: 24);
  }

  Icon _getTrailingIcon(BuildContext context) {
    Color iconColour = widget.enabled
        ? widget.isSelected
              ? Theme.of(context).extension<AppliedTextIcon>()?.positive ??
                    Colors.black54
              : Theme.of(context).extension<AppliedTextIcon>()?.secondary ??
                    Colors.black54
        : (Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized ??
                  Colors.black54)
              .withAlpha(80);

    return widget.isSelected
        ? Icon(Icons.check_circle, color: iconColour, size: 24)
        : Icon(Icons.radio_button_unchecked, color: iconColour, size: 24);
  }

  Widget _getTitle(BuildContext context) {
    Color textColour = widget.enabled
        ? widget.isSelected
              ? Theme.of(context).extension<AppliedTextIcon>()?.positive ??
                    Colors.black54
              : Theme.of(context).extension<AppliedTextIcon>()?.primary ??
                    Colors.black54
        : (Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized ??
                  Colors.black54)
              .withAlpha(80);

    return Text(
      widget.title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textColour,
        //fontFamily: UIStateData.primaryFontFamily,
      ),
    );
  }

  Text? _getDescription(BuildContext context) {
    if (widget.description == null) return null;

    Color textColour = widget.enabled
        ? widget.isSelected
              ? Theme.of(context).extension<AppliedTextIcon>()?.positive ??
                    Colors.black54
              : Theme.of(context).extension<AppliedTextIcon>()?.secondary ??
                    Colors.black54
        : (Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized ??
                  Colors.black54)
              .withAlpha(80);

    return Text(
      widget.description!,
      style: TextStyle(
        fontSize: 12,
        fontWeight: widget.isSelected ? FontWeight.w500 : FontWeight.w400,
        color: textColour,
        //fontFamily: UIStateData.primaryFontFamily,
      ),
    );
  }
}
