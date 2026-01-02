// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/errors/show_error.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';

// Package imports

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/tools/helpers.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class PaymentMethodsList extends StatefulWidget {
  final Function(BuildContext context, PaymentType type) onTap;
  final PaymentType? originalTransactionPaymentType;
  final PaymentType? initialType;
  final List<PaymentType>? paymentTypes;
  final bool useAllEnabledPaymentTypes;
  const PaymentMethodsList({
    Key? key,
    required this.onTap,
    this.originalTransactionPaymentType,
    this.paymentTypes,
    this.initialType,
    this.useAllEnabledPaymentTypes = false,
  }) : super(key: key);

  @override
  State<PaymentMethodsList> createState() => _PaymentMethodsListState();
}

class _PaymentMethodsListState extends State<PaymentMethodsList> {
  List<PaymentType> fundsTypeList = [];
  late PaymentType? selectedType;

  @override
  void initState() {
    super.initState();

    selectedType = widget.initialType;

    fundsTypeList = isNotNullOrEmpty(widget.paymentTypes)
        ? widget.paymentTypes!
        : widget.useAllEnabledPaymentTypes
        ? _getAllEnabledPaymentTypes()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    if (fundsTypeList.isEmpty) {
      return _noPaymentTypes();
    }

    return SizedBox(child: paymentList(context, fundsTypeList));
  }

  Widget _noPaymentTypes() {
    return ShowError(
      message: 'No payment methods available',
      detailsPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    );
  }

  ListView paymentList(BuildContext context, List<PaymentType> types) {
    List<PaymentType> filteredTypes = types;

    if (widget.originalTransactionPaymentType != null) {
      if (widget.originalTransactionPaymentType?.name?.toLowerCase() ==
          'snapscan') {
        filteredTypes = types
            .where((type) => type.name?.toLowerCase() == 'cash')
            .toList();
      } else if (types
          .where(
            (element) =>
                element.name?.toLowerCase() ==
                widget.originalTransactionPaymentType?.name?.toLowerCase(),
          )
          .isNotEmpty) {
        filteredTypes = types
            .where(
              (type) =>
                  type.name?.toLowerCase() ==
                  widget.originalTransactionPaymentType?.name?.toLowerCase(),
            )
            .toList();
      }
      selectedType = filteredTypes.first;
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredTypes.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int index) {
        return paymentListItems(
          index: index, //filteredTypes[index].index,
          selectedIcon: filteredTypes[index].iconData,
          unselectedIcon: filteredTypes[index].iconData,
          type: filteredTypes[index],
        );
      },
    );
  }

  Widget paymentListItems({
    required IconData? unselectedIcon,
    required IconData? selectedIcon,
    required int? index,
    required PaymentType type,
  }) {
    return ItemListTile(
      onTap: () {
        if (mounted) {
          setState(() {
            selectedType = type;
            widget.onTap(context, type);
          });
        }
      },
      trailingIcon: Radio(
        activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
        value: type,
        groupValue: selectedType, // Use the actual selectedType
        onChanged: (PaymentType? value) {
          if (mounted) {
            setState(() {
              selectedType = value;
              widget.onTap(context, value!);
            });
          }
        },
      ),
      leading: ListLeadingIconTile(
        icon: selectedType == type ? selectedIcon : unselectedIcon,
        iconColor: selectedType == type
            ? Theme.of(context).extension<AppliedTextIcon>()?.brand
            : null,
      ),
      title: type.name ?? '',
    );
  }

  List<PaymentType> _getAllEnabledPaymentTypes() {
    List<PaymentType> allPaymentTypes =
        AppVariables.store?.state.appSettingsState.paymentTypes ?? [];
    return allPaymentTypes.where((type) => type.enabled == true).toList();
  }
}
