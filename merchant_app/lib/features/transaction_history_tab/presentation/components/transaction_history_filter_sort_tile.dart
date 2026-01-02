import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/controls/control_check_box.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/date_select_form_field.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/tools/text_formatter.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/filter_item.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/sort_item.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/view_models/order_transaction_list_vm.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';

class TransactionHistoryFilterTile extends StatelessWidget {
  final TransactionHistoryFilterItem filter;
  final OrderTransactionListVM vm;

  const TransactionHistoryFilterTile({
    super.key,
    required this.filter,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return _listItemTile(context);
  }

  _listItemTile(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ItemListTile(
        title: filter.label,
        backgroundColor: Colors.transparent,
        onTap: () {},
        leading: ControlCheckBox(
          isSelected: filter.enabled,
          onChanged: (value) async {
            filter.enabled = value;
            vm.updateTransactionFilters!(filter);
          },
        ),
        trailingIcon: const SizedBox.shrink(),
      ),
    );
  }
}

class TransactionHistoryFilterDateTile extends StatelessWidget {
  final TransactionHistoryFilterItem filter;
  final OrderTransactionListVM vm;

  const TransactionHistoryFilterDateTile({
    super.key,
    required this.filter,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: DateSelectFormField(
        useOutlineStyling: true,
        hintText: 'Please select date',
        key: const Key('invoiceDate'),
        labelText: filter.label,
        suffixIcon: Icons.calendar_today,
        lastDate: DateTime.now().toUtc(),
        firstDate: DateTime(2000, 01, 01),
        initialValue: TextFormatter.toShortDate(
          dateTime: filter.type == OrderTransactionHistoryFilter.endDate
              ? filter.date ?? DateTime(2000, 01, 01)
              : filter.date ?? DateTime.now().toUtc(),
        ),
        initialDate: filter.type == OrderTransactionHistoryFilter.endDate
            ? filter.date ?? DateTime(2000, 01, 01)
            : filter.date ?? DateTime.now().toUtc(),
        isRequired: true,
        inputAction: TextInputAction.next,
        onSaveValue: (value) {},
        onFieldSubmitted: (value) {
          filter.enabled = false;
          filter.enabled = true;
          filter.date = value;
          vm.updateTransactionFilters!(filter);
        },
      ),
    );
  }
}

class TransactionHistorySortTile extends StatelessWidget {
  final TransactionHistorySortItem sort;
  final OrderTransactionListVM vm;
  final Function(bool) onTap;

  const TransactionHistorySortTile({
    super.key,
    required this.sort,
    required this.onTap,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return _listItemTile(context);
  }

  Widget _listItemTile(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      title: context.paragraphMedium(
        sort.label,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        alignLeft: true,
        isSemiBold: true,
      ),
      trailing: Radio(
        activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
        onChanged: (_) async {
          bool value = !sort.enabled;
          await onTap(value);
        },
        groupValue: true,
        value: sort.enabled,
      ),
      onTap: () async {},
    );
  }
}
