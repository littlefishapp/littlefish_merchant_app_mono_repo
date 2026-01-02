//package imports
import 'package:collection/collection.dart';
//flutter imports
import 'package:flutter/material.dart';

//project imports
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/models/permissions/permission_group.dart';
import 'package:littlefish_merchant/models/products/product_discount.dart';
import 'package:littlefish_merchant/shared/list/list_types/permission_group_list_widget.dart';
import 'package:littlefish_merchant/shared/list/list_types/permission_list_widget.dart';
import 'package:littlefish_merchant/shared/list/list_types/product_discount_list_widget.dart';
import 'package:littlefish_merchant/shared/list/list_types/role_list_widget.dart';
import 'package:littlefish_merchant/ui/business/roles/permission_vm.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/view_models/product_discount_vm.dart';

class GenerateListView<E> {
  List<E> items;
  BuildContext context;
  late Function(E, BuildContext)? onTap;
  late Function(List<E>?, bool?)? leadingOnTap;
  late Function(E, BuildContext?)? trailingOnTap;

  GenerateListView({
    this.onTap,
    this.trailingOnTap,
    this.leadingOnTap,
    required this.items,
    required this.context,
  });

  Widget getListView<T>({T? vm}) {
    if (items is List<BusinessRole>) {
      List<BusinessRole?> roles = items as List<BusinessRole?>;
      PermissionVM permissionVM = vm as PermissionVM;
      List<BusinessRole?> businessRoles = List.from(roles);
      if (!(permissionVM.store!.state.enableGuestUser == true)) {
        businessRoles.removeWhere(
          (role) => role?.systemRole == true && role?.name == 'Guest Cashier',
        );
      }
      businessRoles.sort((a, b) {
        final aSystemRole = a?.systemRole ?? false;
        final bSystemRole = b?.systemRole ?? false;

        if (aSystemRole == bSystemRole) return 0;
        return aSystemRole ? -1 : 1;
      });

      return RoleListWidget(
        businessRoles: businessRoles,
        vm: permissionVM,
        onTap: onTap != null
            ? (item, ctx) {
                onTap!(item as E, ctx);
              }
            : null,
        trailingOnTap: trailingOnTap != null
            ? (item, ctx) {
                trailingOnTap!(item as E, ctx);
              }
            : null,
      );
    }

    if (items is List<ProductDiscount>) {
      List<ProductDiscount> productDiscount = items as List<ProductDiscount>;
      ProductDiscountVM productDiscountVM = vm as ProductDiscountVM;
      return ProductDiscountListWidget(
        productDiscounts: productDiscount,
        vm: productDiscountVM,
        onTap: onTap != null
            ? (item, ctx) {
                onTap!(item as E, ctx);
              }
            : null,
        trailingOnTap: trailingOnTap != null
            ? (item, ctx) {
                trailingOnTap!(item as E, ctx);
              }
            : null,
      );
    }

    if (items is List<Permission> || items is List<Permission?>) {
      List<Permission?> permissions = items as List<Permission?>;
      PermissionVM permissionVM = vm as PermissionVM;
      return PermissionListWidget(
        permissions: permissions,
        vm: permissionVM,
        onTap: (value, ctx) {
          onTap!(value as E, ctx);
        },
        leadingOnTap: (value, isValue) {
          leadingOnTap!(value as List<E>, isValue);
        },
      );
    }

    if ((items is List<PermissionGroup> || items is List<PermissionGroup?>) &&
        (vm is PermissionVM)) {
      List<PermissionGroup?> permissionGroups = items as List<PermissionGroup?>;
      PermissionVM permissionVM = vm;
      return PermissionGroupListWidget(
        permissionGroups: permissionGroups,
        vm: permissionVM,
      );
    }

    return const SizedBox();
  }

  getListMaps<T>({T? type}) {
    if (items is List<Permission> || items is List<Permission?>) {
      List<Permission?> permissions = items as List<Permission?>;
      if (type == PermissionClassification.subGroupHeading) {
        return groupBy(permissions, (Permission? p0) => p0!.subGroupName);
      }
      if (type == PermissionClassification.groupParent) {
        return groupBy(permissions, (Permission? p0) => p0!.permissionGroupId);
      }
    }

    if (items is List<PermissionGroup> || items is List<PermissionGroup?>) {
      List<PermissionGroup?> permissionGroups = items as List<PermissionGroup?>;
      return groupBy(
        permissionGroups,
        (PermissionGroup? p0) => p0!.subGroupName,
      );
    }
  }

  getUniqueListHeadings() {
    if (items is List<Permission> || items is List<Permission?>) {
      List<Permission?> permissions = items as List<Permission?>;
      return permissions
          .map((permission) => permission?.subGroupName)
          .toSet()
          .toList();
    }

    if (items is List<PermissionGroup> || items is List<PermissionGroup?>) {
      List<PermissionGroup?> permissionGroups = items as List<PermissionGroup?>;
      return permissionGroups
          .map((permission) => permission?.subGroupName)
          .toSet()
          .toList();
    }
  }
}
