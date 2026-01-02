// remove ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/ensure_visible_focused.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../features/ecommerce_shared/models/store/store.dart';

class GoogleAddressFormField extends StatefulWidget {
  final String? hintText, labelText, initialValue;
  final bool autoValidate;
  final Function(String? value) onSaveValue;
  final Function(String value, StoreAddress address)? onFieldSubmitted;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final bool isRequired;
  final bool obscureText;
  final int? maxLength;
  final int minLength;
  final int minLines;
  final bool enforceMaxLength;
  final TextAlign textAlign;
  final TextEditingController? controller;
  final int maxLines;
  final bool useOutlineStyling;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final OutlineInputBorder? outLineInputBorderStyle;
  final OutlineInputBorder? focusOutLineInputBorderStyle;
  final Function(String? value)? asyncValidator;

  final bool? enabled;

  const GoogleAddressFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.inputAction = TextInputAction.done,
    this.textAlign = TextAlign.left,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.isRequired = true,
    this.obscureText = false,
    this.maxLength,
    this.minLength = 0,
    this.enforceMaxLength = false,
    this.controller,
    this.minLines = 1,
    this.enabled = true,
    this.useOutlineStyling = false,
    this.asyncValidator,
    this.maxLines = 1,
    this.hintStyle,
    this.textStyle,
    this.labelStyle,
    this.outLineInputBorderStyle,
    this.focusOutLineInputBorderStyle,
  }) : super(key: key);

  @override
  State<GoogleAddressFormField> createState() => _GoogleAddressFormFieldState();
}

class _GoogleAddressFormFieldState extends State<GoogleAddressFormField> {
  bool _isLoading = false;
  late TextEditingController controller;
  late String initialValue;
  final FlutterGooglePlacesSdk _placesApi = FlutterGooglePlacesSdk(
    kGoogleApiKey ?? '',
  );
  List<AutocompletePrediction> predictions = [];
  Timer? _predictionTimer;

  FocusNode? _focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initialValue = widget.initialValue ?? '';
    controller.text = initialValue;
    _focusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GoogleAddressFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null &&
        (widget.controller != oldWidget.controller)) {
      controller = widget.controller ?? TextEditingController();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      controller = TextEditingController(text: widget.initialValue ?? '');
    }

    if (oldWidget.controller == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textIconColours =
        Theme.of(context).extension<AppliedTextIcon>() ??
        const AppliedTextIcon();
    final surfaceColors =
        Theme.of(context).extension<AppliedSurface>() ?? const AppliedSurface();
    final isFilled = !widget.useOutlineStyling;
    final fillColor = surfaceColors.primary;
    final iconColor = textIconColours.primary;
    final textColor = textIconColours.emphasized;
    final hintColor = textIconColours.deEmphasized;
    final labelColor = textIconColours.secondary;
    final errorColor = textIconColours.error;

    final textStyle = context.styleParagraphSmallRegular!.copyWith(
      color: textColor,
    );

    final config =
        AppVariables.store?.state.formFieldConfig ?? FormFieldConfig().config;
    final baseHintStyle =
        context.getTextStyle(config.hintTextStyle) ??
        context.styleParagraphSmallRegular;
    final hintStyle = baseHintStyle!.copyWith(color: hintColor);

    final labelStyle = baseHintStyle.copyWith(color: labelColor);

    final enabledBorder = widget.useOutlineStyling
        ? context.inputBorderEnabled()
        : context.inputBorderUnderlineEnabled;

    final border = widget.useOutlineStyling
        ? context.inputBorderEnabled()
        : context.inputBorderUnderlineEnabled;

    final focussedBorder = widget.useOutlineStyling
        ? context.inputBorderFocus()
        : context.inputBorderUnderlineEnabled;

    final disabledBorder = widget.useOutlineStyling
        ? context.inputBorderDisabled()
        : context.inputBorderUnderlineDisabled;

    final errorBorder = widget.useOutlineStyling
        ? context.inputBorderError()
        : context.inputBorderUnderlineError;

    return Column(
      children: [
        EnsureVisibleWhenFocused(
          focusNode: _focusNode,
          child: TextFormField(
            enabled: _isLoading ? false : widget.enabled,
            controller: controller,
            focusNode: _focusNode,
            style: textStyle,
            cursorColor: textColor,
            cursorErrorColor: errorColor,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            key: widget.key,
            maxLength: widget.maxLength,
            textAlign: widget.textAlign,
            textCapitalization: widget.obscureText
                ? TextCapitalization.none
                : TextCapitalization.sentences,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              border: border,
              enabledBorder: enabledBorder,
              focusedBorder: focussedBorder,
              disabledBorder: disabledBorder,
              errorBorder: errorBorder,
              isDense: true,
              fillColor: fillColor,
              filled: isFilled,
              counter: const SizedBox(height: 0.0),
              prefixIconColor: iconColor,
              suffixIconColor: iconColor,
              suffixIcon: _isLoading
                  ? const AppProgressIndicator()
                  : InkWell(
                      child: const Icon(Icons.clear),
                      onTap: () async {
                        await widget.onFieldSubmitted!('', StoreAddress());
                        controller.text = '';
                        if (mounted) {
                          setState(() {
                            predictions = [];
                          });
                        }
                      },
                    ),
              prefixIcon: _isLoading
                  ? const AppProgressIndicator()
                  : const Icon(Icons.search_outlined),
              labelStyle: labelStyle,
              labelText: widget.isRequired
                  ? '${widget.labelText}*'
                  : widget.labelText,
              alignLabelWithHint: true,
              hintStyle: hintStyle,
              hintText: widget.hintText,
            ),
            enableInteractiveSelection: true,
            keyboardType: widget.maxLines <= 1
                ? TextInputType.text
                : TextInputType.multiline,
            textInputAction: widget.inputAction,
            onChanged: (value) {
              if (_predictionTimer?.isActive ?? false) {
                _predictionTimer?.cancel();
              }
              _predictionTimer = Timer(const Duration(milliseconds: 400), () {
                if (value.isNotEmpty) {
                  autoCompleteSearch(value);
                } else {
                  if (mounted) {
                    setState(() {
                      predictions = [];
                    });
                  }
                }
              });
            },
            readOnly: !widget.enabled!,
            validator: (value) {
              if (!validateValue(value)) {
                return 'Please enter a valid value for${widget.labelText}';
              }

              if (widget.asyncValidator != null) return asyncValidation(value);

              return null;
            },
            onSaved: (value) {
              if (validateValue(value)) {
                widget.onSaveValue(value);
              }
            },
          ),
        ),
        ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              const CommonDivider(),
          shrinkWrap: true,
          itemCount: predictions.length,
          itemBuilder: (context, index) {
            return ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              leading: Icon(
                Icons.place_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                '${predictions[index].primaryText.toString()} ${predictions[index].secondaryText.toString()}',
              ),
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  StoreAddress address = await getAddressFromPrediction(
                    context,
                    predictions[index],
                  );
                  await widget.onFieldSubmitted!(
                    '${predictions[index].primaryText.toString()} ${predictions[index].secondaryText.toString()}',
                    address,
                  );
                  predictions = [];
                } catch (e) {
                  debugPrint(e.toString());
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            );
          },
        ),
      ],
    );
  }

  autoCompleteSearch(String value) async {
    FindAutocompletePredictionsResponse result = await _placesApi
        .findAutocompletePredictions(
          value,
          countries: [LocaleProvider.instance.countryCode!],
        );
    if (mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }

  Future<StoreAddress> getAddressFromPrediction(
    BuildContext context,
    AutocompletePrediction prediction,
  ) async {
    var result = await locationFromAddress(prediction.fullText);
    if (result.isEmpty) {
      showMessageDialog(context, 'Address not Found', Icons.location_off);
      return StoreAddress();
    }

    var placeMark = await placemarkFromCoordinates(
      result.first.latitude,
      result.first.longitude,
    );

    return StoreAddress(
      location: StoreLocation(
        latitude: result.first.latitude,
        longitude: result.first.longitude,
      ),
      locationId: prediction.placeId,
      friendlyName: '${prediction.primaryText} ${prediction.secondaryText}',
      addressLine1: placeMark.first.street,
      addressLine2: placeMark.first.subLocality,
      city: placeMark.first.locality,
      country: placeMark.first.country,
      id: prediction.placeId,
      placeId: prediction.placeId,
      postalCode: placeMark.first.postalCode,
      state: placeMark.first.administrativeArea,
    );
  }

  String? asyncValidation(String? value) {
    setState(() {
      _isLoading = true;
    });

    try {
      var result = widget.asyncValidator!(value);
      return result;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
    }

    return null;
  }

  bool validateValue(String? value) {
    if (value == null || value.isEmpty) {
      if (!widget.isRequired) return true;
      return false;
    }

    if (widget.minLength > 0) {
      return value.length >= widget.minLength;
    }

    return true;
  }
}
