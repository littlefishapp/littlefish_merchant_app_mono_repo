import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/presentaion/components/common_divider.dart';
import '../../../../common/presentaion/components/decorated_text.dart';

class MppQuickPaymentMethodsList extends StatefulWidget {
  final Function(BuildContext context, SourceOfFunds type) onTap;
  final SourceOfFunds? initialType;

  const MppQuickPaymentMethodsList({
    Key? key,
    required this.onTap,
    this.initialType,
  }) : super(key: key);

  @override
  State<MppQuickPaymentMethodsList> createState() =>
      _MppQuickPaymentMethodsListState();
}

class _MppQuickPaymentMethodsListState
    extends State<MppQuickPaymentMethodsList> {
  List<SourceOfFunds> fundsTypeList = [];
  late SourceOfFunds? selectedType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: paymentList(context, fundsTypeList));
  }

  String getEnumValueName(SourceOfFunds enumValue) {
    String enumString = enumValue.name;
    return enumString[0].toUpperCase() + enumString.substring(1);
  }

  IconData getFundsTypeIcon(SourceOfFunds type) {
    switch (type) {
      case SourceOfFunds.card:
        return MdiIcons.creditCard;
      case SourceOfFunds.cash:
        return Icons.local_atm_outlined;
      case SourceOfFunds.credit:
        return MdiIcons.creditCard;
      case SourceOfFunds.eft:
        return Icons.attach_money;
      case SourceOfFunds.mobileMoney:
        return Icons.phone_android;
      case SourceOfFunds.other:
        return Icons.more_horiz;
      default:
        return Icons.help;
    }
  }

  @override
  void initState() {
    super.initState();

    selectedType =
        widget.initialType; // if null then no defualt payment type applied

    fundsTypeList = [SourceOfFunds.card, SourceOfFunds.cash];
  }

  paymentList(BuildContext context, List<SourceOfFunds> types) =>
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: types.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return paymentListItems(
            selectedIcon: getFundsTypeIcon(types[index]),
            unselectedIcon: getFundsTypeIcon(types[index]),
            type: types[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(),
      );

  paymentListItems({
    required IconData? unselectedIcon,
    required IconData? selectedIcon,
    required SourceOfFunds type,
  }) => InkWell(
    onTap: () {
      if (mounted) {
        setState(() {
          selectedType = type;
          widget.onTap(context, type);
        });
      }
    },
    child: ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      trailing: Radio(
        value: true,
        groupValue: selectedType == type ? true : false,
        onChanged: (qe) {
          setState(() {});
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
        getEnumValueName(type),
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
