import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_button.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';
import 'package:littlefish_merchant/ui/sales/pages/transaction_page.dart';
import 'package:quiver/strings.dart';

class SalesTransactionTile extends StatelessWidget {
  final CheckoutTransaction sale;

  final EdgeInsetsGeometry? contentPadding;

  final bool isDense;
  const SalesTransactionTile({
    super.key,
    required this.sale,
    this.isDense = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return _listItemTile(context, sale);
  }

  _listItemTile(BuildContext context, CheckoutTransaction item) {
    final textIconColours =
        Theme.of(context).extension<AppliedTextIcon>() ??
        const AppliedTextIcon();
    return ListTile(
      contentPadding: contentPadding,
      dense: !EnvironmentProvider.instance.isLargeDisplay! || isDense,
      onTap: () async {
        if (EnvironmentProvider.instance.isLargeDisplay!) {
          showPopupDialog(
            context: context,
            content: TransactionPage(transaction: item),
          );
        } else {
          await Navigator.of(context).push(
            CustomRoute(
              builder: (BuildContext context) {
                return TransactionPage(transaction: item);
              },
            ),
          );
        }

        AppVariables.store!.dispatch(getInitialTransactions());
      },
      leading: getLeadingWidget(context, item),
      title: context.labelSmall(
        '${TextFormatter.toShortDate(dateTime: item.transactionDate ?? DateTime.now(), format: 'HH:mm')} - #${item.transactionNumber?.toInt().toString()}',
      ),

      // _displayTitleBasedOnType(item),
      subtitle: Row(
        children: [
          context.labelXSmall('${getTransactionType(item)} ', alignLeft: true),
          statusIcon(item.status ?? '', context),
        ],
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.isQuickRefund)
            context.labelSmall(
              '-${TextFormatter.toStringCurrency(item.totalRefund)}',
              color: textIconColours.error,
              isBold: true,
            ),
          if (item.isFullyRefunded && !item.isQuickRefund && !item.isCashBack)
            context.labelSmall(
              '-${TextFormatter.toStringCurrency(item.totalRefund)}',
              color: textIconColours.error,
              isBold: true,
            ),
          if (item.isRefunded && !item.isFullyRefunded && !item.isQuickRefund ||
              (item.isCashBack && !item.isQuickRefund))
            context.labelXSmall(
              '(-${TextFormatter.toStringCurrency(item.isCashBack ? item.cashbackAmount : item.totalRefund)})  ',
              color: textIconColours.error,
            ),
          if ((!item.isFullyRefunded && !item.isQuickRefund) ||
              (item.isCashBack && !item.isQuickRefund))
            context.labelSmall(
              TextFormatter.toStringCurrency(item.checkoutTotal),
              isSemiBold: true,
            ),
        ],
      ),
    );
  }

  String getTransactionType(CheckoutTransaction item) {
    if (item.isQuickRefund) {
      return 'Quick Refund';
    }

    if (item.isFullyRefunded) {
      return 'Full Refund';
    }

    if (item.isRefunded) {
      return 'Partial Refund';
    }

    if (item.isCashBack) {
      return 'Purchase + Cashback';
    }

    if (item.isWithdrawal) {
      return 'Cash Withdrawal';
    }

    return 'Purchase';
  }

  String toTitleCase(String text) {
    return text
        .toLowerCase()
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  Widget statusIcon(String text, BuildContext context) {
    IconData iconData = Icons.close;
    final textTheme = Theme.of(context).extension<AppliedTextIcon>();
    Color iconColor = textTheme?.error ?? Colors.redAccent;
    if (text.toLowerCase().contains('complete') ||
        text.toLowerCase().contains('refund')) {
      iconData = Icons.check;
      iconColor = textTheme?.success ?? Colors.green;
    }

    return Icon(iconData, color: iconColor, size: 14);
  }

  Widget getLeadingWidget(BuildContext context, CheckoutTransaction item) {
    if (item.paymentType?.isCard ?? false) {
      String cardType = item.cardType.toLowerCase();

      String imageIcon = '';

      if (cardType.isNotEmpty) {
        if (cardType.toLowerCase().contains('visa')) {
          cardType = 'Visa';
          imageIcon = ImageConstants.visaSvg;
        } else if (cardType.toLowerCase().contains('master')) {
          cardType = 'Mastercard';
          imageIcon = ImageConstants.mastercardSvg;
        } else if (cardType.toLowerCase().contains('maestro')) {
          cardType = 'Maestro';
          imageIcon = ImageConstants.maestroSvg;
        } else if (cardType.toLowerCase().contains('diners')) {
          cardType = 'Diners Club';
          imageIcon = ImageConstants.dinersSvg;
        } else if (cardType.toLowerCase().contains('amex')) {
          cardType = 'AMEX';
          imageIcon = ImageConstants.amexSvg;
        }

        if (imageIcon.isNotEmpty) {
          return ListLeadingIconTile(
            icon: isBlank(imageIcon)
                ? item.paymentType?.iconData ?? Icons.payment
                : imageIcon,
          );
        }
      }
    }
    return ListLeadingIconTile(
      icon: item.paymentType?.iconData ?? Icons.payment,
    );
  }
}
