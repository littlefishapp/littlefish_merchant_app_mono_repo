import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/shared/list/generate_list_tile.dart';
import 'package:littlefish_merchant/ui/business/roles/permission_vm.dart';

class PermissionListView extends StatefulWidget {
  final List<Permission?> permissions;
  final String? permissionGroupId;
  final PermissionVM vm;

  const PermissionListView({
    Key? key,
    required this.permissions,
    required this.vm,
    this.permissionGroupId,
  }) : super(key: key);

  @override
  State<PermissionListView> createState() => _PermissionListViewState();
}

class _PermissionListViewState extends State<PermissionListView> {
  Map<String?, List<Permission?>>? _groupedLists;
  List<String?>? _groupNames;
  List<Permission?>? _permissions;

  @override
  initState() {
    super.initState();
    _permissions = widget.permissionGroupId == null
        ? widget.permissions
        : widget.permissions
              .where(
                (element) =>
                    element!.permissionGroupId == widget.permissionGroupId,
              )
              .toList();
  }

  @override
  Widget build(BuildContext context) {
    _permissions = widget.permissionGroupId == null
        ? widget.permissions
        : widget.permissions
              .where(
                (element) =>
                    element!.permissionGroupId == widget.permissionGroupId,
              )
              .toList();
    _groupedLists ??= GenerateListView(
      items: _permissions ?? [],
      context: context,
    ).getListMaps(type: PermissionClassification.subGroupHeading);
    _groupNames ??= GenerateListView(
      items: _permissions ?? [],
      context: context,
    ).getUniqueListHeadings();
    return permissionView(context);
  }

  Widget permissionView(BuildContext context) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (BuildContext ctx, int index) {
      return Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(16),
            child: context.paragraphSmall(
              _groupNames![index] as String,
              color: Theme.of(context).colorScheme.secondary,
              isSemiBold: true,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GenerateListView(
              items: _groupedLists![_groupNames![index]]!,
              context: context,
              leadingOnTap: (List<Permission?>? values, bool? isAdd) async {
                if (widget.vm.currentBusinessRole?.systemRole == false) {
                  List<Permission?> permissions = values as List<Permission?>;
                  List<String?> permissionIds = permissions
                      .map((permission) => permission!.id)
                      .toList();
                  await widget.vm.updateBusinessRolePermissions!(
                    permissionIds,
                    isAdd!,
                  );
                  setState(() {});
                }
              },
            ).getListView(vm: widget.vm),
          ),
        ],
      );
    },
    itemCount: _groupedLists!.length,
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(),
  );
}
