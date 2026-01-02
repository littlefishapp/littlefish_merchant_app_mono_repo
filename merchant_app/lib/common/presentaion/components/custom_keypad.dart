import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_discard.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:quiver/strings.dart';
import '../pages/scaffolds/app_scaffold.dart';
import 'app_progress_indicator.dart';
import 'form_fields/string_form_field.dart';

class CustomKeyPad extends StatefulWidget {
  final Function(double value, String? description) onSubmit;

  final double? initialValue, minChargeAmount;

  final BuildContext? parentContext;
  final String? title,
      heading,
      confirmButtonText,
      confirmErrorMessage,
      discardTitle,
      discardDescription,
      discardAcceptText,
      discardCancelText;

  final bool isAmountCapture, isNoDecimalAmountCapture;

  final bool showConfirmButton;

  final bool? enableAppBar, enableProfileAction, enableNavBar, isLoading;
  final bool enableDescription, enableChange, isFullPage, enableDiscardButton;
  final bool isDescriptionRequired;

  final Future<void> Function()? animateCallback;

  final Function(double amount) onValueChanged;
  final Function(bool)? onDiscard;

  final Function(String description)? onDescriptionChanged;
  final String? initialDescriptionValue;

  final List<Widget> additionalActions;

  const CustomKeyPad({
    Key? key,
    required this.onSubmit,
    this.initialValue = 0,
    required this.onValueChanged,
    required this.onDescriptionChanged,
    this.onDiscard,
    this.showConfirmButton = true,
    this.discardTitle,
    this.discardDescription,
    this.discardAcceptText,
    this.discardCancelText,
    this.isLoading = false,
    this.enableDiscardButton = false,
    this.minChargeAmount = 0,
    this.confirmErrorMessage,
    this.enableDescription = false,
    this.enableProfileAction,
    this.enableNavBar,
    this.enableChange = false,
    this.isFullPage = false,
    this.enableAppBar,
    this.title,
    this.confirmButtonText,
    this.heading,
    this.animateCallback,
    this.parentContext,
    this.initialDescriptionValue,
    this.additionalActions = const [],
    this.isDescriptionRequired = true,
    this.isAmountCapture = true,
    this.isNoDecimalAmountCapture = false,
  }) : super(key: key);

  @override
  State<CustomKeyPad> createState() => _CustomKeyPadState();
}

class _CustomKeyPadState extends State<CustomKeyPad> {
  late String _textValue;

  String? _description;

  GlobalKey<FormState> descKey = GlobalKey<FormState>();

  bool _hasStartedTyping = false;

  @override
  void initState() {
    _textValue = '0';
    if (widget.initialValue != null) {
      if (widget.isNoDecimalAmountCapture) {
        _textValue = widget.initialValue!.toInt().toString();
      } else {
        _textValue = widget.initialValue!.toStringAsFixed(2);
      }
    }

    _description = widget.initialDescriptionValue;

    super.initState();
  }

  @override
  void didUpdateWidget(CustomKeyPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      if (widget.initialValue == null) {
        _textValue = '0';
      } else {
        if (widget.isNoDecimalAmountCapture) {
          _textValue = widget.initialValue!.toInt().toString();
        } else {
          _textValue = widget.initialValue!.toStringAsFixed(2);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAmountCapture && !widget.isNoDecimalAmountCapture) {
      if (_textValue.contains('.')) {
        _textValue = _textValue.replaceAll('.', '');
      }
    }

    if (isBlank(_description)) {
      _description = widget.initialDescriptionValue ?? '';
    }

    return AppScaffold(
      resizeToAvoidBottomPadding: false,
      displayAppBar: widget.enableAppBar ?? true,
      displayNavDrawer: widget.enableNavBar ?? false,
      enableProfileAction: widget.enableProfileAction ?? false,
      hasDrawer: widget.enableNavBar ?? false,
      title: widget.title ?? '',
      body: widget.isLoading! ? const AppProgressIndicator() : layout(context),
      actions: [
        if (widget.enableDiscardButton) discardTileButton(),
        ...widget.additionalActions,
      ],
    );
  }

  Widget descriptionText(BuildContext context) {
    if (widget.enableDescription) {
      return StringFormField(
        useOutlineStyling: true,
        focusOutLineInputBorderStyle: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        outLineInputBorderStyle: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        isRequired: false,
        hintText: 'Enter description',
        labelText: 'Description',
        initialValue: _description,
        maxLines: 1, // Set the number of lines you want to allow
        onSaveValue: (value) {
          _description = value;
        },
        onChanged: (desc) {
          _description = desc;
        },
      );
    } else {
      return Container();
    }
  }

  Widget layout(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Expanded(
        flex: 4,
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          margin: const EdgeInsets.only(top: 16),
          alignment: Alignment.center,
          child: keypadDisplay(context),
        ),
      ),
      if (double.parse(_textValue) > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: changeWidget(context),
        ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: descriptionText(context),
      ),
      const CommonDivider(),
      Expanded(
        flex: 8,
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: keypad(context),
        ),
      ),
      if (widget.showConfirmButton)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 64,
          child: keypadButton(context),
        ),
    ],
  );

  Widget keypadDisplay(BuildContext context) {
    var textAsDecimal = double.tryParse(_textValue) ?? 0;
    var amountCaptureDisplay = widget.isNoDecimalAmountCapture
        ? TextFormatter.toStringCurrencyNoDecimal(textAsDecimal)
        : TextFormatter.formatCurrency(_textValue);

    var chargeText = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        context.labelXSmall(
          widget.heading?.toUpperCase() ?? 'Enter Amount'.toUpperCase(),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          alignment: Alignment.center,
          child: widget.isFullPage
              ? widget.isAmountCapture
                    ? FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          '$amountCaptureDisplay',
                          style: TextStyle(
                            fontSize: 76,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(
                              context,
                            ).extension<AppliedTextIcon>()?.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : context.headingLarge(
                        TextFormatter.toFlatNumber(double.parse(_textValue)),
                        isBold: true,
                      )
              : context.headingLarge(
                  widget.isAmountCapture
                      ? '$amountCaptureDisplay'
                      : TextFormatter.toFlatNumber(double.parse(_textValue)),
                  isBold: true,
                ),
        ),
      ],
    );

    return chargeText;
  }

  Widget changeWidget(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppliedTextIcon>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //Change Amount
        Visibility(
          visible: widget.enableChange,
          child: Text(
            'Change: ${TextFormatter.formatCurrency((double.parse(_textValue) - widget.minChargeAmount! * 100).toString())}',
            style: TextStyle(
              color:
                  (double.parse(_textValue) - widget.minChargeAmount! * 100) < 0
                  ? textTheme?.error
                  : textTheme?.secondary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        //Related to payment types
      ],
    );
  }

  Widget keypadButton(BuildContext context) {
    // Determine if we are in the standard "cents" mode.
    final bool isCentsMode =
        widget.isAmountCapture && !widget.isNoDecimalAmountCapture;

    // Calculate the final numeric value based on the mode.
    final double finalValue;
    if (isCentsMode) {
      // For standard currency, treat _textValue as cents and divide by 100.
      finalValue = (double.tryParse(_textValue) ?? 0) / 100.0;
    } else {
      // For no-decimal amounts OR simple quantities, use the value directly.
      finalValue = double.tryParse(_textValue) ?? 0;
    }

    final bool enabled =
        finalValue > 0 && finalValue >= (widget.minChargeAmount ?? 0);

    final String buttonText;
    if (widget.isAmountCapture) {
      // For amount capture, format the value for the button.
      final String buttonValueDisplay = isCentsMode
          ? TextFormatter.formatCurrency(_textValue)!
          : TextFormatter.toStringCurrencyNoDecimal(finalValue);
      buttonText =
          '${widget.confirmButtonText ?? 'Confirm'} - $buttonValueDisplay';
    } else {
      // For simple quantities, just show the confirm text.
      buttonText = widget.confirmButtonText ?? 'Confirm';
    }

    return ButtonPrimary(
      disabled: !enabled,
      text: buttonText,
      onTap: enabled
          ? (context) {
              widget.onSubmit(finalValue, _description);
            }
          : null,
    );
  }

  Widget keypad(BuildContext context) {
    var keypadOptions = keys();

    return Column(
      children: [
        keypadRow(keypadOptions.take(3), context),
        keypadRow(keypadOptions.getRange(3, 6), context),
        keypadRow(keypadOptions.getRange(6, 9), context),
        keypadRow(keypadOptions.getRange(9, 12), context),
      ],
    );
  }

  Widget keypadRow(Iterable<KeyPadItem> keys, BuildContext context) {
    List<Widget> items = [];

    for (var k in keys) {
      items.add(keypadItem(k, context));
    }

    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      ),
    );
  }

  Expanded keypadItem(KeyPadItem key, BuildContext context) {
    return Expanded(
      child: Material(
        elevation: 1,
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          child:
              (key.type == KeyPadItemType.clear ||
                  key.type == KeyPadItemType.backspace)
              ? Semantics(
                  identifier: SemanticsConstants.kClear,
                  label: SemanticsConstants.kClear,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.backspace_outlined,
                      size: 24,
                      color: Colors.red,
                    ),
                  ),
                )
              : DecoratedText(
                  key.displayText ?? key.value,
                  fontSize: 28,
                  alignment: Alignment.center,
                  fontWeight: FontWeight.bold,
                ),
          onTap: () {
            switch (key.type) {
              case KeyPadItemType.normal:
                if (_textValue.length >= 12) return;

                if (widget.isNoDecimalAmountCapture) {
                  setState(() {
                    if (_textValue == '0' && key.value != '00') {
                      _textValue = key.value!;
                    } else if (_textValue != '0') {
                      _textValue += key.value!;
                    }
                  });
                  widget.onValueChanged(double.tryParse(_textValue)!);
                } else if (!widget.isAmountCapture) {
                  int currentValue = double.parse(_textValue).toInt();

                  String currentValueString = currentValue.toString();

                  // String keyValueString = (double.parse(key.value!)).toString();
                  String keyValueString = key.value!;

                  if (!_hasStartedTyping) {
                    setState(() {
                      _textValue = keyValueString;
                      _hasStartedTyping = true;
                    });

                    widget.onValueChanged(double.tryParse(_textValue)!);
                  } else {
                    setState(() {
                      _textValue = '$currentValueString$keyValueString';
                    });

                    widget.onValueChanged(double.tryParse(_textValue)!);
                  }
                } else {
                  setState(() {
                    _textValue += key.value!;
                  });
                  widget.onValueChanged(double.tryParse(_textValue)! / 100);
                }

                break;
              case KeyPadItemType.backspace:
                setState(() {
                  _textValue = _textValue.substring(0, _textValue.length - 1);
                  if (_textValue == '') _textValue = '0';
                });
                break;
              case KeyPadItemType.clear:
                setState(() {
                  _description = '';
                  _textValue = '0';
                });

                widget.onValueChanged(0.0);
                break;
              case KeyPadItemType.submit:
                if (_textValue.isEmpty) {
                  return;
                }

                var amount = widget.initialValue;

                if (amount == null || amount <= 0) return;

                widget.onValueChanged(amount);

                double textValueDouble =
                    double.parse(_textValue.toString()) / 100;

                widget.onSubmit(textValueDouble, _description);

                _description = '';
                _textValue = '';
                setState(() {});

                widget.onValueChanged(0.0);
                break;
              default:
                break;
            }
          },
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
        order: 0,
        type: KeyPadItemType.normal,
        value: '00',
        displayText: '00',
      ),
      KeyPadItem(
        order: 1,
        type: KeyPadItemType.normal,
        value: '0',
        displayText: '0',
      ),
      KeyPadItem(
        order: 2,
        type: KeyPadItemType.clear,
        value: 'C',
        displayText: 'C',
      ),
    ];
  }

  Widget discardTileButton() {
    return ButtonDiscard(
      isIconButton: true,
      enablePopPage: true,
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      modalTitle: widget.discardTitle ?? 'Discard',
      modalDescription:
          widget.discardDescription ??
          'Would you like to discard your current progress/'
              '\n\nThis will clear all changes made and you will'
              'lose your progress.',
      modalAcceptText: widget.discardAcceptText ?? 'Yes, Discard',
      modalCancelText: widget.discardCancelText ?? 'No, Cancel',
      onDiscard: (ctx) async {
        if (widget.onDiscard != null) {
          widget.onDiscard!(true);
        }
      },
    );
    // return InkWell(
    //   child: const DeleteIcon(),
    //   onTap: () async {
    //     discardFunction();
    //   },
    // );
  }

  discardFunction() async {
    final modalService = getIt<ModalService>();
    bool? isAccepted = await modalService.showActionModal(
      status: StatusType.destructive,
      context: context,
      title: widget.discardTitle ?? 'Discard',
      description:
          widget.discardDescription ??
          'Would you like to discard your current progress/'
              '\n\nThis will clear all changes made and you will'
              'lose your progress.',
      acceptText: 'Yes, Discard',
      cancelText: 'No, Cancel',
    );

    widget.onDiscard!(isAccepted ?? false);
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
