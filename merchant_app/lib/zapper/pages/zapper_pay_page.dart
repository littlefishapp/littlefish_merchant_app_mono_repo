import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/zapper/view_model/zapper_vm.dart';

class ZapperPayPage extends StatefulWidget {
  final CheckoutTransaction transaction;
  final BuildContext? parentContext;
  final String? imagePath;

  const ZapperPayPage(
    this.transaction,
    this.imagePath, {
    Key? key,
    this.parentContext,
  }) : super(key: key);

  @override
  State<ZapperPayPage> createState() => _ZapperPayPageState();
}

class _ZapperPayPageState extends State<ZapperPayPage> {
  ZapperVM? vm;
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
    imagePath = widget.imagePath;
    vm ??=
        ZapperVM.fromStore(
            StoreProvider.of<AppState>(context),
            context: context,
          )
          ..onLoadingChanged = () {
            if (mounted) setState(() {});
          }
          ..setTransaction(widget.transaction);

    // TODO(lampian): verify change
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (vm!.qrSVG != null) {
          vm!.cancelInvoice(widget.parentContext ?? context);
        } else {
          Navigator.pop(context, {'proceed': false, 'paid': false});
          return;
        }
      },
      child: AppSimpleAppScaffold(
        title: 'Zapper Pay',
        titleIsWidget: true,
        titleWidget: Container(
          margin: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(AppAssets.zapperTextPng, height: 40),
          ),
        ),
        isEmbedded: true,
        body: (vm!.isLoading! && vm!.qrSVG == null)
            ? const AppProgressIndicator()
            : FutureBuilder(
                future: vm!.generateQRCode(widget.parentContext ?? context),
                builder: (BuildContext context, snapshot) =>
                    snapshot.connectionState == ConnectionState.done
                    ? vm!.qrSVG != null
                          ? layout(context, vm!)
                          : const Text('')
                    : const AppProgressIndicator(),
              ),
      ),
    );
  }

  Column layout(context, ZapperVM vm) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Column(
        children: <Widget>[
          const CommonDivider(),
          const SizedBox(height: 16),
          SizedBox(
            height: 320,
            width: 320,
            child: Material(elevation: 2, child: vm.qrSVG),
          ),
          const CommonDivider(),
          SizedBox(
            height: 144,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const DecoratedText(
                    'Amount Charged',
                    alignment: Alignment.center,
                    fontSize: null,
                    textColor: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LongText(
                        TextFormatter.toStringCurrency(
                          transaction.amountTendered,
                          displayCurrency: false,
                          currencyCode: '',
                        ),
                        fontSize: 36.0,
                        textColor: Theme.of(context).colorScheme.primary,
                        alignment: TextAlign.center,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  LongText(
                    "change: ${TextFormatter.toStringCurrency(transaction.amountChange, displayCurrency: false, currencyCode: '')}",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: (MediaQuery.of(context).size.width / 2) - 28,
            height: 48,
            child: ButtonText(
              onTap: (_) {
                if (vm.qrSVG != null) {
                  vm.cancelInvoice(widget.parentContext ?? context);
                } else {
                  Navigator.of(context).pop({'proceed': false, 'paid': false});
                }
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
                if (vm.qrSVG == null) {
                  showMessageDialog(
                    widget.parentContext ?? context,
                    'Cannot move forward, please verify Zapper details',
                    LittleFishIcons.error,
                  );
                } else {
                  vm.verifyPayment(parentContext ?? context);
                }
              },
              text: 'ACCEPT',
            ),
          ),
        ],
      ),
    ],
  );
}
