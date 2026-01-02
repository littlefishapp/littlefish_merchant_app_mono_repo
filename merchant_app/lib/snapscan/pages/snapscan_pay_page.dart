// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/snapscan/view_model/snapscan_vm.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import '../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class SnapscanPayPage extends StatefulWidget {
  final CheckoutTransaction transaction;
  final BuildContext? parentContext;
  final String? imagePath;

  const SnapscanPayPage(
    this.transaction,
    this.imagePath, {
    Key? key,
    this.parentContext,
  }) : super(key: key);

  @override
  State<SnapscanPayPage> createState() => _SnapscanPayPageState();
}

class _SnapscanPayPageState extends State<SnapscanPayPage> {
  SnapscanVM? vm;
  late CheckoutTransaction transaction;
  BuildContext? parentContext;
  Map<String, dynamic>? options;
  String? imagePath;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    transaction = widget.transaction;
    parentContext = widget.parentContext;
    vm ??=
        SnapscanVM.fromStore(
            StoreProvider.of<AppState>(context),
            context: context,
          )
          ..onLoadingChanged = () {
            if (mounted) setState(() {});
          }
          ..setTransaction(widget.transaction)
          ..generateQRString();

    return PopScope(
      child: AppScaffold(
        title: 'Snapscan Pay',
        body: (vm?.isLoading ?? true)
            ? const AppProgressIndicator()
            : layout(context, vm!),
      ),
    );
  }

  Column layout(context, SnapscanVM vm) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Column(
        children: <Widget>[
          SizedBox(
            height: 320,
            width: 320,
            child: Material(
              color: Colors.transparent,
              child: vm.generateQRCode(),
            ),
          ),
          const SizedBox(height: 20),
          const DecoratedText(
            'Amount Due',
            alignment: Alignment.center,
            fontWeight: FontWeight.w400,
            fontSize: 24,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DecoratedText(
                TextFormatter.toStringCurrency(
                  transaction.amountTendered,
                  displayCurrency: true,
                  currencyCode: '',
                ),
                fontSize: 32,
                alignment: Alignment.center,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
      // Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: (MediaQuery.of(context).size.width / 2) - 28,
            height: 48,
            child: ButtonText(
              onTap: (_) {
                vm.verifyPayment(widget.parentContext ?? context, cancel: true);
              },
              text: 'CANCEL',
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: (MediaQuery.of(context).size.width / 2) - 28,
            height: 48,
            child: ButtonText(
              onTap: (_) async {
                vm.verifyPayment(parentContext ?? context);
              },
              text: 'ACCEPT',
            ),
          ),
        ],
      ),
      // SizedBox(height: 2),
    ],
  );
}
