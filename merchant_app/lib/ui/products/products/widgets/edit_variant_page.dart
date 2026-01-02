import 'dart:math';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/toggle_switch.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/alphanumeric_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/models/stock/product_option.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/barcode_form_field.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_run_helper.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/helpers/sku_generator.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/products/products/helpers/product_helper.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/branded_info_container.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/margin_profit_row.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/stock_control_fields.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/upload_variant_image_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';

class EditVariantPage extends StatefulWidget {
  final ProductOption productOption;
  final void Function(ProductOption productOption) onSave;

  const EditVariantPage({
    Key? key,
    required this.productOption,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditVariantPage> createState() => _EditVariantPageState();
}

class _EditVariantPageState extends State<EditVariantPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _barcodeController;
  late final StockVariance _stockVariance;
  late ProductOption _productOption;

  late bool _isEnabled;
  String _newBarcode = '';
  String _orginalBarcode = '';
  bool hasScanBarcodePerm = false;

  @override
  void initState() {
    super.initState();
    _productOption = widget.productOption;
    _stockVariance = _productOption.variances.isNotEmpty
        ? _productOption.variances.first
        : StockVariance();
    _orginalBarcode = String.fromCharCodes(_productOption.barcode.codeUnits);

    _isEnabled = _productOption.enabled ?? true;
    _sellingPriceController = TextEditingController(
      text: (_stockVariance.sellingPrice ?? 0).toStringAsFixed(2),
    );
    _costPriceController = TextEditingController(
      text: (_stockVariance.costPrice ?? 0).toStringAsFixed(2),
    );
    _barcodeController = TextEditingController(text: _productOption.barcode);
    _newBarcode = _productOption.barcode;

    hasScanBarcodePerm = userHasPermission(allowScanBarcode);

    // Add listeners to recalculate metrics when prices change
    _sellingPriceController.addListener(() => setState(() {}));
    _costPriceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      displayAppBar: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              UploadVariantImageTile(
                title: widget.productOption.displayName ?? 'Variant',
                subtitle: 'Edit variant',
                productId: widget.productOption.id,
                imageUri: widget.productOption.imageUri,
                onUploaded: (String? imageUri) {
                  setState(() {
                    _productOption.imageUri = imageUri ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildStatusSection(),
              const SizedBox(height: 16),
              _buildPricingSection(),
              const SizedBox(height: 32),
              _buildBarcodeSection(),
              const SizedBox(height: 24),
              _buildStockTrackingInfo(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [_buildFooterButtons()],
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.labelMediumBold('Status'),
        _toggleEnabled(
          context: context,
          isEnabled: _isEnabled,
          onChanged: (isEnabled) {
            setState(() {
              _isEnabled = isEnabled;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.labelMediumBold('Price'),
        const SizedBox(height: 24),
        CurrencyFormField(
          key: const Key('sellingPrice'),
          isRequired: true,
          validator: (value) {
            var valueAsDouble = double.tryParse(value ?? '') ?? 0.0;
            if (valueAsDouble <= 0) {
              return 'Please enter a selling price greater than zero';
            }
            return null;
          },
          controller: _sellingPriceController,
          prefixIcon: Icons.sell_outlined,
          hintText: 'Selling Price',
          labelText: 'Selling Price',
          useOutlineStyling: true,
          enableCustomKeypad: true,
          customKeypadHeading: 'Selling Price :',
          initialValue: _stockVariance.sellingPrice,
          onSaveValue: (value) {
            final sellingPrice = double.tryParse(value.toString()) ?? 0.0;
            setState(() {
              _stockVariance.sellingPrice = sellingPrice;
              if (_productOption.variances.isNotEmpty) {
                _productOption.variances[0] = _stockVariance;
              } else {
                _productOption.variances = [_stockVariance];
              }
            });
          },
          inputAction: TextInputAction.next,
          showExtra: false,
        ),
        const SizedBox(height: 20),
        CurrencyFormField(
          key: const Key('costPrice'),
          controller: _costPriceController,
          initialValue: _stockVariance.costPrice,
          prefixIcon: Icons.sell_outlined,
          hintText: 'Cost Price',
          labelText: 'Cost Price',
          useOutlineStyling: true,
          enableCustomKeypad: true,
          customKeypadHeading: 'Cost Price :',
          onSaveValue: (value) {
            final costPrice = double.tryParse(value.toString()) ?? 0.0;
            setState(() {
              _stockVariance.costPrice = costPrice;
              if (_productOption.variances.isNotEmpty) {
                _productOption.variances[0] = _stockVariance;
              } else {
                _productOption.variances = [_stockVariance];
              }
            });
          },
          inputAction: TextInputAction.done,
          showExtra: false,
        ),
        const SizedBox(height: 16),
        MarginProfitRow(
          margin: _productChecker('margin'),
          profit: _productChecker('profit'),
          color: _productColourChecker(),
        ),
      ],
    );
  }

  Widget _buildBarcodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.labelMediumBold('Barcode'),
        const SizedBox(height: 16),
        BarcodeFormField(
          key: const Key('barcode'),
          controller: _barcodeController,
          isRequired: false,
          canScanBarcode: hasScanBarcodePerm,
          laserScannerAvailable: AppVariables.laserScanningSupported,
          hintText: hasScanBarcodePerm
              ? 'Enter or Scan Barcode'
              : 'Enter Barcode',
          labelText: 'Item Barcode',
          useOutlineStyling: true,
          initialValue: widget.productOption.barcode,
          onSaveValue: (value) {
            setState(() {
              _newBarcode = value;
              _productOption.regularBarCode = value;
            });
          },
          onChanged: (value) {
            _newBarcode = value;
            _productOption.regularBarCode = value;
          },
        ),
      ],
    );
  }

  Widget _buildStockTrackingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.labelMediumBold('Stock Details'),
        const SizedBox(height: 16),
        _productOption.isStockTrackable == false
            ? BrandedInfoContainer(
                title: 'Stock tracking disabled',
                description:
                    'Enable "Track per variant" in Options tab to manage individual stock.',
                icon: LittleFishIcons.info,
              )
            : Column(
                children: [
                  StockControlFields(
                    isStockTrackable: _productOption.isStockTrackable,
                    productType:
                        _productOption.productType ?? ProductType.physical,
                    unitType: _productOption.unitType ?? StockUnitType.byUnit,

                    // Pass display names and other info for quantity capture modal
                    productDisplayName: _productOption.displayName ?? '',
                    productId: _productOption.id,
                    imageUri: _productOption.imageUri,
                    productCategoryName: AppVariables.store?.state.productState
                        .getCategory(categoryId: _productOption.categoryId)
                        ?.displayName,

                    // Pass data for the form fields
                    unitOfMeasure: _productOption.unitOfMeasure,
                    stockCount:
                        _productOption.variances.first.quantityAsNonNegative,
                    lowStockValue:
                        _productOption.variances.first.lowQuantityValue ?? 10,

                    // Implement the callbacks for direct field changes
                    onUnitOfMeasureChanged: (value) {
                      setState(() {
                        _productOption.unitOfMeasure = value;
                      });
                    },
                    onStockCountChanged: (value) {
                      setState(() {
                        _productOption.variances.first.quantity = value;
                      });
                    },
                    onLowStockValueChanged: (value) {
                      setState(() {
                        _productOption.variances.first.lowQuantityValue = value;
                      });
                    },

                    onStockAdjusted: (difference, reason) async {
                      double diff = difference;
                      Navigator.of(context).pop();
                      if (StockRunHelper.isDecreaseByReason(reason)) {
                        diff = -diff;
                      }
                      setState(() {
                        double newValue =
                            (_productOption.variances.first.quantity ?? 0) +
                            diff;
                        _productOption.variances.first.quantity = max(
                          0,
                          newValue,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  AlphaNumericFormField(
                    isDense: true,
                    enforceMaxLength: true,
                    maxLines: 5,
                    maxLength: 255,
                    useOutlineStyling: true,
                    suffixIcon: MdiIcons.codeArray,
                    hintText: 'Product Variant SKU',
                    key: const Key('VariantskuCode'),
                    labelText: 'SKU',
                    onFieldSubmitted: (value) {},
                    inputAction: TextInputAction.next,
                    initialValue: _productOption.sku.isNotEmpty
                        ? _productOption.sku
                        : SkuGenerator.generateSKU(),
                    isRequired: true,
                    onSaveValue: (value) {
                      _productOption.sku = value ?? SkuGenerator.generateSKU();
                    },
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildFooterButtons() {
    return FooterButtonsSecondaryPrimary(
      primaryButtonText: 'Save',
      secondaryButtonText: 'Cancel',
      onPrimaryButtonPressed: (ctx) async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          if (isNotBlank(_newBarcode) && _newBarcode != _orginalBarcode) {
            var isUnique = ProductHelper.isBarcodeUnique(_newBarcode);

            if (!isUnique) {
              if (context.mounted) {
                await showMessageDialog(
                  context,
                  'The Item barcode is already assigned to a product',
                  LittleFishIcons.info,
                );
                return;
              }
            }
          }
          setState(() {
            _productOption.enabled = _isEnabled;
            _productOption.barcode = _newBarcode;
            _productOption.variances = [_stockVariance];
          });
          widget.onSave(_productOption);

          Navigator.of(ctx).pop();
        }
      },
      onSecondaryButtonPressed: (ctx) {
        Navigator.of(ctx).pop();
      },
    );
  }

  String _productChecker(String type) {
    final sellingPrice =
        double.tryParse(_sellingPriceController.text.replaceAll(',', '.')) ??
        0.0;
    final costPrice =
        double.tryParse(_costPriceController.text.replaceAll(',', '.')) ?? 0.0;

    if (type == 'profit') {
      final profit = sellingPrice - costPrice;
      return TextFormatter.toStringCurrency(profit);
    } else {
      // margin
      if (costPrice > 0) {
        final margin = ((sellingPrice - costPrice) / costPrice * 100);
        return '${margin.toStringAsFixed(2)}%';
      } else {
        return '0.00%';
      }
    }
  }

  Color _productColourChecker() {
    final sellingPrice =
        double.tryParse(_sellingPriceController.text.replaceAll(',', '.')) ??
        0.0;
    final costPrice =
        double.tryParse(_costPriceController.text.replaceAll(',', '.')) ?? 0.0;

    final defaultColor =
        Theme.of(context).extension<AppliedTextIcon>()?.emphasized ??
        Colors.red;
    final errorColor =
        Theme.of(context).extension<AppliedTextIcon>()?.error ?? Colors.red;

    if (sellingPrice >= costPrice) {
      return defaultColor;
    } else {
      return errorColor;
    }
  }

  Widget _toggleEnabled({
    required BuildContext context,
    required bool isEnabled,
    required void Function(bool) onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ToggleSwitch(
          initiallyEnabled: isEnabled,
          enabledColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          onChanged: onChanged,
        ),
        const SizedBox(width: 12),
        context.labelSmall(isEnabled ? 'Enabled' : 'Disabled'),
      ],
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
