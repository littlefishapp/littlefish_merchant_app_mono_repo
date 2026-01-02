// Flutter imports:
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// Package imports:

// Project imports:
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import '../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../models/settings/payments/payment_type.dart';
import '../../../tools/billing/billing_helpers.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/app_progress_indicator.dart';

class CheckoutCustomKeyPad extends StatefulWidget {
  final Function(double value, String? description) onSubmit;

  final double? initialValue;
  final BuildContext? parentContext;
  final KeyPadType keypadType;
  final String? title;
  final bool? enableAppBar;

  final CheckoutVM vm;
  final Future<void> Function()? animateCallback;

  final Function(double amount) onValueChanged;

  final Function(String description) onDescriptionChanged;

  const CheckoutCustomKeyPad({
    Key? key,
    required this.onSubmit,
    required this.initialValue,
    required this.onValueChanged,
    required this.onDescriptionChanged,
    required this.vm,
    required this.keypadType,
    this.enableAppBar,
    this.title,
    this.animateCallback,
    this.parentContext,
  }) : super(key: key);

  @override
  State<CheckoutCustomKeyPad> createState() => _CheckoutCustomKeyPadState();
}

class _CheckoutCustomKeyPadState extends State<CheckoutCustomKeyPad> {
  late String _textValue;

  //String? _displayValue;

  String? _description;

  // FocusNode _focusNode = FocusNode();

  // TextEditingController? _editingController;
  TextEditingController? _descriptionController;

  GlobalKey<FormState> descKey = GlobalKey<FormState>();

  @override
  void initState() {
    _textValue = widget.initialValue.toString();

    // _editingController = TextEditingController();

    _descriptionController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    // _editingController?.dispose();
    _descriptionController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_textValue.isEmpty) {
      //debugPrint('no value');
      _textValue = widget.vm.customAmount.toString().replaceAll('.', '');
    } else {
      _textValue = _textValue.toString().replaceAll('.', '');
    }

    // FocusScope.of(context).requestFocus(_focusNode);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: AppScaffold(
        displayAppBar: widget.enableAppBar ?? true,
        title: widget.title ?? '',
        body: widget.vm.isLoading!
            ? Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: AppProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  hasScaffold: true,
                ),
              )
            : layout(context),
        persistentFooterButtons: [
          keypadButton(context),
          const SizedBox(height: 16),
          keypad(context),
        ],
      ),
    );
  }

  Container layout(BuildContext context) => Container(
    alignment: Alignment.center,
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: widget.keypadType == KeyPadType.quickPayment ? 20 : 32,
          ),
          //Amount details
          keypadDisplay(context),
          // Details for page
          keypadDetails(context),
        ],
      ),
    ),
  );

  Row keypadDisplay(BuildContext context) {
    // debugPrint(_displayValue);
    var amountDisplayText = TextFormatter.toStringCurrency(
      double.parse(_textValue) / 100,
      displayCurrency: false,
      currencyCode: '',
    );

    var chargeText = Flexible(
      fit: FlexFit.loose,
      child: SizedBox(
        height: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SizedBox(
            //   height: 16,
            // ),
            //amount heading
            Text(
              widget.keypadType == KeyPadType.cashPayment
                  ? 'AMOUNT RECEIVED'
                  : 'AMOUNT',
              style: const TextStyle(
                color: Color(0xfd8e8c8f),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: widget.keypadType == KeyPadType.quickPayment ? 8 : 16,
            ),
            //amount
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DecoratedText(
                    LocaleProvider.instance.currencyCode,
                    alignment: Alignment.center,
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
                    textColor: const Color(0xfd1f1f21),
                  ),
                  const SizedBox(width: 4),
                  DefaultTextStyle(
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      //fontFamily: UIStateData.primaryFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 32.0,
                      color: Color(0xfd1f1f21),
                    ),
                    child: Text(amountDisplayText, textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Row(children: <Widget>[chargeText]);
  }

  Flexible keypadDetails(BuildContext context) {
    double amount =
        (widget.vm.checkoutTotal ?? Decimal.zero * Decimal.fromInt(100))
            .toDouble();
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Change Amount
          Visibility(
            visible: widget.keypadType == KeyPadType.cashPayment,
            child: Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Change: ${TextFormatter.formatCurrency((double.parse(_textValue) - amount).toString())}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.keypadType != KeyPadType.cashPayment,
            child: Container(
              alignment: Alignment.center,
              // padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(
                top: widget.keypadType == KeyPadType.quickSale ? 24 : 4,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 1, // Set the number of lines you want to allow

                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.notes),
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                onChanged: (desc) {
                  _description = desc;
                },
              ),
            ),
          ),
          //Related to payment types
          SizedBox(height: widget.keypadType == KeyPadType.quickSale ? 24 : 0),
          SizedBox(height: widget.keypadType == KeyPadType.quickSale ? 24 : 0),
        ],
      ),
    );
  }

  Container keypadButton(BuildContext context) => Container(
    height: 56,
    padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
    child: ButtonPrimary(
      upperCase: true,
      buttonColor: double.parse(_textValue.toString()) / 100 == 0.00
          ? const Color(0xfd8e8c8f)
          : Theme.of(context).colorScheme.secondary,
      text: widget.keypadType == KeyPadType.quickPayment
          ? 'Add'
          : widget.keypadType == KeyPadType.cashPayment
          ? 'Confirm Payment'
          : 'Continue to Payment',
      onTap: (context) {
        double textValueDouble = double.parse(_textValue.toString()) / 100;
        if (textValueDouble <= 0 &&
            (widget.keypadType == KeyPadType.cashPayment ||
                widget.keypadType == KeyPadType.quickPayment)) {
          showMessageDialog(
            context,
            'Please enter the cash amount to be paid by the customer.',
            LittleFishIcons.info,
          );
        } else {
          if (widget.keypadType == KeyPadType.quickSale) {
            widget.vm.items = [];
          }
          widget.onSubmit(textValueDouble, _description);
        }
      },
    ),
  );

  ListView paymentList(
    BuildContext context,
    List<PaymentType> types,
    CheckoutVM vm,
  ) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    itemCount: types.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      return paymentListItems(
        index: types[index].displayIndex,
        selectedIcon: types[index].icon,
        unselectedIcon: types[index].icon,
        type: types[index],
        vm: vm,
      );
    },
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(),
  );

  InkWell paymentListItems({
    required IconData? unselectedIcon,
    required IconData? selectedIcon,
    required int? index,
    required PaymentType type,
    required CheckoutVM vm,
  }) => InkWell(
    onTap: () async {
      if (isNotPremium(type.name)) {
        showPopupDialog(
          defaultPadding: false,
          context: context,
          content: billingNavigationHelper(isModal: true),
        );
      } else {
        vm.paymentTypeIndex = index;
        vm.setPaymentType(type);
        if (type.name!.toLowerCase() == 'cash') {
          vm.setAmountTendered(Decimal.zero);
        } else {
          vm.setAmountTendered(vm.checkoutTotal);
        }
      }
    },
    child: ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      trailing: Radio(
        value: true,
        groupValue: vm.paymentType == type ? true : false,
        onChanged: (qe) {
          setState(() {});
        },
      ),
      leading: (type.imageURI != null && type.imageURI!.isNotEmpty)
          ? Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(type.imageURI!)),
              ),
            )
          : Icon(
              vm.paymentTypeIndex == index ? selectedIcon : unselectedIcon,
              size: 30.0,
              color: vm.paymentTypeIndex == index
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
            ),
      title: DecoratedText(
        type.name,
        fontSize: null,
        fontWeight: vm.paymentTypeIndex == index ? FontWeight.bold : null,
        textColor: vm.paymentTypeIndex == index
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade700,
        alignment: Alignment.centerLeft,
      ),
    ),
  );

  Container keypad(BuildContext context) {
    var keypadoptions = keys();

    return Container(
      height: 280,
      decoration: const BoxDecoration(color: Color(0xfdd1d2d8)),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        children: [
          keypadRow(keypadoptions.take(3), context),
          keypadRow(keypadoptions.getRange(3, 6), context),
          keypadRow(keypadoptions.getRange(6, 9), context),
          keypadRow(keypadoptions.getRange(9, 12), context),
        ],
      ),
    );
  }

  // Future<void> _captureDescription(BuildContext context) async {
  //   await Navigator.of(context).push<String>(
  //     CustomRoute(
  //       builder: (ctx) => StringPopupForm(
  //         formKey: descKey,
  //         onSubmit: (context, dynamic value) {
  //           this._description = value;

  //           //trigger the change
  //           if (widget.onDescriptionChanged != null) {
  //             widget.onDescriptionChanged(value);
  //           }

  //           if (mounted) setState(() {});
  //         },
  //         maxLength: 24,
  //         initialValue: _description,
  //         subTitle:
  //             "Enter a description that would describe the sale you are about to make",
  //         title: "Sale Description",
  //       ),
  //     ),
  //   );
  // }

  Row keypadRow(Iterable<KeyPadItem> keys, BuildContext context) {
    List<Widget> items = [];

    for (var k in keys) {
      items.add(keypadItem(k, context));
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items,
    );
  }

  Expanded keypadItem(KeyPadItem key, BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(2.5),
        child: Material(
          elevation:
              key.type == KeyPadItemType.backspace ||
                  key.type == KeyPadItemType.clear
              ? 0
              : 1,
          borderRadius: BorderRadius.circular(4),
          color:
              key.type == KeyPadItemType.backspace ||
                  key.type == KeyPadItemType.clear
              ? const Color(0xfdd1d2d8)
              : Colors.white,
          child: InkWell(
            child: key.type == KeyPadItemType.backspace
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Icon(
                      Icons.backspace_outlined,
                      size: 16,
                      color: Colors.grey.shade700,
                    ),
                  )
                : DecoratedText(
                    key.displayText ?? key.value,
                    fontSize: 24,

                    alignment: Alignment.center,
                    textColor: key.type == KeyPadItemType.normal
                        ? Colors.grey.shade700
                        : Colors.grey.shade700,
                    // fontWeight: key.type == KeyPadItemType.normal
                    //     ? FontWeight.normal
                    //     : FontWeight.bold,
                  ),
            onTap: () {
              switch (key.type) {
                case KeyPadItemType.normal:
                  //we cannot append more
                  if (_textValue.length >= 12) return;

                  setState(() {
                    _textValue += key.value!;

                    // _displayValue = TextFormatter.formatCurrency(
                    //   _textValue.isEmpty ? '0' : _textValue,
                    //   displayCurrency: false,
                    // );

                    // _editingController!.text = _displayValue!;
                  });

                  widget.onValueChanged(double.tryParse(_textValue)! / 100);
                  break;
                case KeyPadItemType.backspace:
                  setState(() {
                    _textValue = _textValue.substring(0, _textValue.length - 1);
                    // _displayValue = TextFormatter.formatCurrency(
                    //   _textValue.isEmpty ? '0' : _textValue,
                    //   displayCurrency: false,
                    // );

                    // _editingController!.text = _displayValue!;
                  });
                  break;
                case KeyPadItemType.clear:
                  setState(() {
                    _description = '';
                    _textValue = '';
                    // _displayValue = TextFormatter.formatCurrency(
                    //   _textValue.isEmpty ? '0' : _textValue,
                    //   displayCurrency: false,
                    // );

                    // _editingController!.text = _displayValue!;
                  });

                  widget.onValueChanged(0.0);
                  break;
                case KeyPadItemType.submit:
                  if (_textValue.isEmpty) {
                    return;
                  }

                  var amount = widget.vm.customAmount;

                  if (amount == null || amount <= Decimal.zero) return;

                  widget.onValueChanged(amount.toDouble());

                  double textValueDouble =
                      double.parse(_textValue.toString()) / 100;
                  widget.onSubmit(textValueDouble, _description);

                  setState(() {
                    _description = '';
                    _textValue = '';
                    // _displayValue = TextFormatter.formatCurrency(
                    //   _textValue.isEmpty ? '0' : _textValue,
                    //   displayCurrency: false,
                    // );

                    // _editingController!.text = _displayValue!;
                  });

                  widget.onValueChanged(0.0);
                  if (widget.animateCallback != null) widget.animateCallback!();
                  break;
                default:
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  List<KeyPadItem> keys() {
    return [
      KeyPadItem(
        order: 3,
        type: KeyPadItemType.normal,
        value: '1',
        displayText: '1',
      ),
      KeyPadItem(
        order: 4,
        type: KeyPadItemType.normal,
        value: '2',
        displayText: '2',
      ),
      KeyPadItem(
        order: 5,
        type: KeyPadItemType.normal,
        value: '3',
        displayText: '3',
      ),
      KeyPadItem(
        order: 6,
        type: KeyPadItemType.normal,
        value: '4',
        displayText: '4',
      ),
      KeyPadItem(
        order: 7,
        type: KeyPadItemType.normal,
        value: '5',
        displayText: '5',
      ),
      KeyPadItem(
        order: 8,
        type: KeyPadItemType.normal,
        value: '6',
        displayText: '6',
      ),
      KeyPadItem(
        order: 9,
        type: KeyPadItemType.normal,
        value: '7',
        displayText: '7',
      ),
      KeyPadItem(
        order: 9,
        type: KeyPadItemType.normal,
        value: '8',
        displayText: '8',
      ),
      KeyPadItem(
        order: 9,
        type: KeyPadItemType.normal,
        value: '9',
        displayText: '9',
      ),
      KeyPadItem(
        order: 2,
        type: KeyPadItemType.clear,
        value: 'C',
        displayText: 'C',
      ),
      KeyPadItem(
        order: 1,
        type: KeyPadItemType.normal,
        value: '0',
        displayText: '0',
      ),
      KeyPadItem(
        order: 0,
        type: KeyPadItemType.backspace,
        value: '00',
        displayText: '00',
      ),
    ];
  }
}

class KeyPadItem {
  int? order;
  String? displayText;
  String? value;
  KeyPadItemType? type;

  KeyPadItem({this.order, this.value, this.type, this.displayText});
}

enum KeyPadItemType { normal, clear, backspace, submit }

// cashPayment only has a change variable  so we display amount , change, button and keypad; Relates to cash type payment in pre sale pages
// quickPayment only displays  amount display, description, button and keypad; Relates to quick payment in product sales.
// quickSale displays amount display, description, payment type, button and keypad; Relates to a quick sale.
enum KeyPadType { cashPayment, quickPayment, quickSale }
