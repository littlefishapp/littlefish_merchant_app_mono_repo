import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

import '../../../app/theme/applied_system/applied_surface.dart';
import '../../../app/theme/applied_system/applied_text_icon.dart';

class SelectCustomerTile extends StatefulWidget {
  final Customer? customer;
  final Function(BuildContext, Customer) onSetCustomer;
  final Function() onClearCustomer;

  const SelectCustomerTile({
    Key? key,
    required this.customer,
    required this.onSetCustomer,
    required this.onClearCustomer,
  }) : super(key: key);
  @override
  State<SelectCustomerTile> createState() => _SelectCustomerTileState();
}

class _SelectCustomerTileState extends State<SelectCustomerTile> {
  @override
  Widget build(BuildContext context) {
    return selectCustomerTile(context);
  }

  Widget selectCustomerTile(BuildContext context) {
    return widget.customer == null
        ? ButtonSecondary(
            text: 'Add Customer',
            onTap: (c) {
              if (widget.customer == null) {
                selectCustomer(context);
              } else {
                widget.onClearCustomer();
              }
            },
          )
        : ListTile(
            contentPadding: const EdgeInsets.all(0),
            tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
            title: Text(
              '${widget.customer!.displayName}',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Last Visit: ${TextFormatter.toShortDate(dateTime: widget.customer!.lastPurchaseDate ?? DateTime.now(), format: AppVariables.appDateFormat)}',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: ListLeadingIconTile(
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
              icon: Icons.person,
            ),
            trailing: IconButton(
              onPressed: () {
                widget.onClearCustomer();
              },
              icon: const Icon(Icons.close),
            ),
          );
  }

  selectCustomer(BuildContext context) async {
    if (EnvironmentProvider.instance.isLargeDisplay!) {
      await showPopupDialog(
        context: context,
        content: CustomerSelectPage(
          canAddNew: true,
          onSelected: (BuildContext context, Customer? customer) {
            if (customer != null) {
              // TODO(lampian): Important - fix use of widget.customer
              //widget.customer = customer;
              widget.onSetCustomer(context, customer);
            }
          },
          isDialog: true,
        ),
      );
    } else {
      await Navigator.of(context).push(
        CustomRoute(
          builder: (BuildContext context) => CustomerSelectPage(
            canAddNew: true,
            onSelected: (BuildContext context, Customer? customer) {
              if (customer != null) {
                widget.onSetCustomer(context, customer);
              }
            },
          ),
        ),
      );
    }
  }
}
