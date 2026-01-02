// Flutter imports:
import 'package:flutter/material.dart';

// Package imports
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart'
    as old_payment_payment_types;

import '../../../features/order_common/data/model/payment_type.dart';

class OrderPaymentMethodsList extends StatefulWidget {
  final Function(BuildContext context, PaymentType type) _onTap;
  final PaymentType? _originalTransactionPaymentType;
  final PaymentType? _initialType;
  final List<PaymentType>? _paymentTypes;
  final bool _useAllEnabledPaymentTypes;

  const OrderPaymentMethodsList({
    Key? key,
    required dynamic Function(BuildContext, PaymentType) onTap,
    PaymentType? originalTransactionPaymentType,
    List<PaymentType>? paymentTypes,
    PaymentType? initialType,
    bool useAllEnabledPaymentTypes = false,
  }) : _useAllEnabledPaymentTypes = useAllEnabledPaymentTypes,
       _paymentTypes = paymentTypes,
       _initialType = initialType,
       _originalTransactionPaymentType = originalTransactionPaymentType,
       _onTap = onTap,
       super(key: key);

  @override
  State<OrderPaymentMethodsList> createState() =>
      _OrderPaymentMethodsListState();
}

class _OrderPaymentMethodsListState extends State<OrderPaymentMethodsList> {
  List<PaymentType> fundsTypeList = [];
  late PaymentType? selectedType;

  @override
  void initState() {
    super.initState();

    selectedType = widget._initialType;

    fundsTypeList = isNotNullOrEmpty(widget._paymentTypes)
        ? widget._paymentTypes!
        : widget._useAllEnabledPaymentTypes
        ? _getAllEnabledPaymentTypes()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: paymentList(context, fundsTypeList));
  }

  IconData getFundsTypeIcon(PaymentType type) {
    switch (type.providerName.toLowerCase()) {
      case 'card':
        return MdiIcons.creditCard;
      case 'cash':
        return Icons.local_atm_outlined;
      default:
        return Icons.help;
    }
  }

  ListView paymentList(BuildContext context, List<PaymentType> types) {
    List<PaymentType> filteredTypes = types;

    if (widget._originalTransactionPaymentType != null) {
      if (types
          .where(
            (element) =>
                element.providerName.toLowerCase() ==
                widget._originalTransactionPaymentType?.providerName
                    .toLowerCase(),
          )
          .isNotEmpty) {
        filteredTypes = types
            .where(
              (type) =>
                  type.providerName.toLowerCase() ==
                  widget._originalTransactionPaymentType?.providerName
                      .toLowerCase(),
            )
            .toList();
      }
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredTypes.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return paymentListItems(
          index: index,
          selectedIcon: getFundsTypeIcon(filteredTypes[index]),
          unselectedIcon: getFundsTypeIcon(filteredTypes[index]),
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
    return InkWell(
      onTap: () {
        if (mounted) {
          setState(() {
            selectedType = type;
            widget._onTap(context, type);
          });
        }
      },
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        trailing: Radio(
          activeColor: Theme.of(context).colorScheme.primary,
          value: type,
          groupValue: selectedType, // Use the actual selectedType
          onChanged: (PaymentType? value) {
            if (mounted) {
              setState(() {
                selectedType = value;
                widget._onTap(context, value!);
              });
            }
          },
        ),
        leading: Icon(
          selectedType == type ? selectedIcon : unselectedIcon,
          size: 30.0,
          color: selectedType == type
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade700,
        ),
        title: DecoratedText(
          type.providerName,
          fontSize: null,
          fontWeight: selectedType == type ? FontWeight.bold : null,
          textColor: selectedType == type
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade700,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  List<PaymentType> _getAllEnabledPaymentTypes() {
    List<PaymentType> allPaymentTypes = _mapToOrderPaymentTypes(
      AppVariables.store?.state.appSettingsState.paymentTypes,
    );
    return allPaymentTypes;
  }

  List<PaymentType> _mapToOrderPaymentTypes(
    List<old_payment_payment_types.PaymentType>? paymentTypes,
  ) {
    if ((paymentTypes ?? []).isEmpty) {
      return [];
    }

    var enabledTypes = paymentTypes!
        .where((element) => element.enabled == true)
        .toList();

    return enabledTypes
        .map((e) => PaymentType(providerName: e.name ?? 'unknown'))
        .toList();
  }
}
