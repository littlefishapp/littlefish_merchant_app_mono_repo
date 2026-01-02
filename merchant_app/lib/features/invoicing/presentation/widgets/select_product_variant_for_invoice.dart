import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottom_sheet_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_image_with_badge.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/models/stock/single_option_attribute.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_merchant/tools/helpers/product_variant_helper.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:redux/redux.dart';

import '../../../../ui/checkout/widgets/select_product_attributes.dart';

class SelectProductVariantForInvoice extends StatefulWidget {
  final StockProduct parentProduct;

  const SelectProductVariantForInvoice({
    super.key,
    required this.parentProduct,
  });

  @override
  State<SelectProductVariantForInvoice> createState() =>
      _SelectProductVariantForInvoiceState();
}

class _SelectProductVariantForInvoiceState
    extends State<SelectProductVariantForInvoice> {
  late String _parentProductDisplayName;
  late double _parentProductSellingPrice;
  late String _parentProductImageUri;

  late String _displayName;
  late double _sellingPrice;
  late int _quantity;
  late String _imageUri;
  late List<SingleOptionAttribute> _selectedOptionAttributes;
  StockProduct? _productVariant;

  final Map<String, StockProduct> _cachedVariants = {};

  @override
  void initState() {
    super.initState();
    final product = widget.parentProduct;
    _parentProductDisplayName = product.displayName ?? '';
    _parentProductSellingPrice = product.regularSellingPrice ?? 0.0;
    _parentProductImageUri = product.imageUri ?? '';

    _displayName = product.displayName ?? '';
    _sellingPrice = product.regularSellingPrice ?? 0.0;
    _quantity = 1;
    _imageUri = product.imageUri ?? '';
    _selectedOptionAttributes = [];
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store<AppState> store) => CheckoutVM.fromStore(store),
      builder: (BuildContext context, CheckoutVM vm) {
        final bool isLoading =
            vm.isLoading == true || vm.productVariantIsLoading;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: BottomSheetIndicator()),
              const SizedBox(height: 16),
              Flexible(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _buildScrollableContent(vm),
                    ),
                    if (isLoading)
                      Positioned.fill(
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: const Center(child: AppProgressIndicator()),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _confirmButton(vm),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScrollableContent(CheckoutVM vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _productTile(
          displayName: _displayName,
          sellingPrice: _sellingPrice,
          quantity: _quantity,
          imageUri: _imageUri,
        ),
        const SizedBox(height: 16),
        _quantityField(),
        const SizedBox(height: 16),
        _buildOptions(vm),
      ],
    );
  }

  Widget _confirmButton(CheckoutVM vm) {
    final bool isLoading = vm.isLoading == true || vm.productVariantIsLoading;
    final bool isEnabled =
        !isLoading && _quantity > 0 && _productVariant != null;

    return SafeArea(
      bottom: true,
      child: ButtonPrimary(
        text: 'Use this option',
        disabled: !isEnabled,
        onTap: (ctx) {
          if (_productVariant == null) return;
          Navigator.of(
            ctx,
          ).pop({'variant': _productVariant!, 'quantity': _quantity});
        },
      ),
    );
  }

  void _onAttributeSelected(
    CheckoutVM vm,
    String option,
    String attribute,
  ) async {
    // prevent duplicates
    final already = _selectedOptionAttributes.any(
      (attr) => attr.option == option && attr.attribute == attribute,
    );
    if (already) return;

    setState(() {
      _updateSelectedAttributes(option, attribute);
    });

    final allOptionsSelected =
        ProductVariantHelper.hasSelectedAnAttributeForEachOption(
          availableOptionAttributes:
              widget.parentProduct.productOptionAttributes ?? [],
          selectedOptionAttributes: _selectedOptionAttributes,
        );

    if (allOptionsSelected) {
      final variantDisplayName =
          ProductVariantHelper.constructVariantDisplayName(
            parentProductDisplayName: widget.parentProduct.displayName ?? '',
            availableOptionAttributes:
                widget.parentProduct.productOptionAttributes ?? [],
            selectedOptionAttributes: _selectedOptionAttributes,
          );

      if (_cachedVariants.containsKey(variantDisplayName)) {
        _productVariant = _cachedVariants[variantDisplayName];
      } else {
        final fetched = await vm.getProductVariant(
          widget.parentProduct,
          _selectedOptionAttributes,
        );
        if (fetched != null) {
          _cachedVariants[variantDisplayName] = fetched;
        }
        _productVariant = fetched;
      }
    } else {
      _productVariant = null;
    }

    if (mounted) {
      setState(() {
        _displayName =
            _productVariant?.displayName ?? _parentProductDisplayName;
        _sellingPrice =
            _productVariant?.regularSellingPrice ?? _parentProductSellingPrice;
        _imageUri = _productVariant?.imageUri ?? _parentProductImageUri;
      });
    }
  }

  void _updateSelectedAttributes(String option, String attribute) {
    final newAttribute = SingleOptionAttribute(
      option: option,
      attribute: attribute,
    );
    _selectedOptionAttributes.upsertWhere(
      newAttribute,
      (attr) => attr.option == option,
    );
  }

  Widget _productTile({
    required String displayName,
    required double sellingPrice,
    required int quantity,
    String imageUri = '',
  }) {
    final String subtitleText =
        ProductVariantHelper.getAttributeCombinationString(
          availableOptionAttributes:
              widget.parentProduct.productOptionAttributes ?? [],
          selectedOptionAttributes: _selectedOptionAttributes,
        );

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ButtonImageWithBadge(
        leading: imageUri.isNotEmpty
            ? ListLeadingImageTile(url: imageUri)
            : Container(
                width: AppVariables.appDefaultlistItemSize,
                height: AppVariables.appDefaultlistItemSize,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).extension<AppliedSurface>()?.brandSubTitle,
                  borderRadius: BorderRadius.circular(
                    AppVariables.appDefaultButtonRadius,
                  ),
                ),
                child: Center(
                  child: context.labelLarge(
                    _getDisplayNameSubstring(displayName),
                    isSemiBold: true,
                  ),
                ),
              ),
        isSelected: quantity > 0,
        textValue: quantity.toString(),
      ),
      subtitle: context.paragraphSmall(subtitleText, alignLeft: true),
      trailing: context.labelSmall(
        TextFormatter.toStringCurrency(sellingPrice, currencyCode: ''),
      ),
      title: context.labelSmall(
        displayName,
        isBold: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _quantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.labelLarge('Quantity', isBold: true),
        const SizedBox(height: 16),
        Row(
          children: [
            NumberFormField(
              minValue: 0,
              buttonSize: 40,
              textFieldWidth: 40,
              useDecorator: false,
              enabled: true,
              hintText: 'How many?',
              key: Key('${widget.key} variant-qty'),
              labelText: '',
              onSaveValue: (value) => setState(() => _quantity = value),
              onChanged: (value) => _quantity = value?.toInt() ?? 1,
              inputAction: TextInputAction.done,
              initialValue: _quantity,
              onFieldSubmitted: (value) {
                setState(() {
                  if (value == null) {
                    _quantity = 1;
                    return;
                  }
                  final diff = value.toDouble() - _quantity;
                  _quantity += diff.toInt();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptions(CheckoutVM vm) {
    final options = widget.parentProduct.productOptionAttributes;
    if (options == null || options.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        if (option.option == null) return const SizedBox.shrink();

        final selectedValue = _selectedOptionAttributes
            .firstWhereOrNull((soa) => soa.option == option.option)
            ?.attribute;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SelectProductAttributes(
            optionAttribute: option,
            selectedAttribute: selectedValue,
            onAttributeSelected: (attribute) {
              _onAttributeSelected(vm, option.option!, attribute);
            },
          ),
        );
      }).toList(),
    );
  }

  String _getDisplayNameSubstring(String displayName, {int maxLength = 2}) {
    if (displayName.isEmpty) return '';
    return (displayName.length > maxLength
            ? displayName.substring(0, maxLength)
            : displayName)
        .toUpperCase();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
