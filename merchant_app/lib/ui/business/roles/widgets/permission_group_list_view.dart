import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/permissions/permission_group.dart';
import 'package:littlefish_merchant/shared/list/generate_list_tile.dart';
import 'package:littlefish_merchant/ui/business/roles/permission_vm.dart';

class PermissionGroupListView extends StatefulWidget {
  final PermissionVM vm;

  const PermissionGroupListView({Key? key, required this.vm}) : super(key: key);

  @override
  State<PermissionGroupListView> createState() =>
      _PermissionGroupListViewState();
}

class _PermissionGroupListViewState extends State<PermissionGroupListView> {
  final GlobalKey<FormState> formKey = GlobalKey();
  Map<String?, List<PermissionGroup?>>? _groupedLists;
  List<String?>? _groupNames;

  @override
  Widget build(BuildContext context) {
    _groupedLists = GenerateListView(
      items: widget.vm.permissionGroups!,
      context: context,
    ).getListMaps();
    _groupNames = GenerateListView(
      items: widget.vm.permissionGroups!,
      context: context,
    ).getUniqueListHeadings();

    return permissionGroupView(context, widget.vm);
  }

  permissionGroupView(
    BuildContext context,
    PermissionVM vm,
  ) => ListView.builder(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (BuildContext ctx, int index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: context.labelMediumBold(_groupNames![index]!),
          ),
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: GenerateListView(
              items: _groupedLists![_groupNames![index]]!,
              context: context,
            ).getListView(vm: vm),
          ),
          Container(
            width: double.infinity,
            height: 16,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ),
        ],
      );
    },
    itemCount: _groupedLists!.length,
  );
}
