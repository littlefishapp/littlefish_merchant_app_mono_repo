import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/controls/control_check_box.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';

class SalesMoreActions {
  static Widget showMoreActions({
    required BuildContext context,
    required bool isSelected,
    required Function(bool) onChanged,
  }) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).extension<AppliedSurface>()?.secondary,
      ),
      color: Theme.of(context).extension<AppliedSurface>()?.primary,
      surfaceTintColor: Theme.of(context).extension<AppliedSurface>()?.primary,
      onSelected: (value) {},
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[];
        items.add(
          PopupMenuItem(
            padding: EdgeInsets.only(left: 16),
            value: 'terminal_filter',
            child: Expanded(
              child: ItemListTile(
                title: 'This Device',
                backgroundColor: Colors.transparent,
                onTap: () {},
                leading: ControlCheckBox(
                  isSelected: isSelected,
                  onChanged: (value) async {
                    onChanged(value);
                    Navigator.of(context).pop();
                  },
                ),
                trailingIcon: const SizedBox.shrink(),
              ),
            ),
          ),
        );

        return items;
      },
    );
  }
}
