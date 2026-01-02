// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

import '../../../features/ecommerce_shared/models/store/store.dart';

class ExpandableStoreAddress extends StatefulWidget {
  final bool isRequired;

  final StoreAddress? details;

  final bool isExpanded;

  final bool fieldsEnabled;

  const ExpandableStoreAddress({
    Key? key,
    this.isRequired = false,
    this.isExpanded = false,
    this.fieldsEnabled = true,
    required this.details,
  }) : super(key: key);

  @override
  State<ExpandableStoreAddress> createState() => _ExpandableStoreAddressState();
}

class _ExpandableStoreAddressState extends State<ExpandableStoreAddress> {
  TextEditingController? _friendlyNameController;
  TextEditingController? _addressLine1Controller;
  TextEditingController? _addressLine2Controller;
  TextEditingController? _cityController;
  TextEditingController? _stateController;
  TextEditingController? _postalCodeController;

  List<TextEditingController?> _controllers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    if (_friendlyNameController == null) {
      _friendlyNameController = TextEditingController();
      _addressLine1Controller = TextEditingController();
      _addressLine2Controller = TextEditingController();
      _cityController = TextEditingController();
      _stateController = TextEditingController();
      _postalCodeController = TextEditingController();
    }

    _controllers = [
      _friendlyNameController,
      _addressLine1Controller,
      _addressLine2Controller,
      _cityController,
      _stateController,
      _postalCodeController,
    ];

    for (var controller in _controllers) {
      if (controller != null) {
        controller.removeListener(_onChanged);
      }
    }
    _friendlyNameController!.text = widget.details!.friendlyName ?? '';
    _addressLine2Controller!.text = widget.details!.addressLine2 ?? '';
    _addressLine1Controller!.text = widget.details!.addressLine1 ?? '';
    _addressLine2Controller!.text = widget.details!.addressLine2 ?? '';
    _cityController!.text = widget.details!.city ?? '';
    _stateController!.text = widget.details!.state ?? '';
    _postalCodeController!.text = widget.details!.postalCode ?? '';

    for (var controller in _controllers) {
      controller!.addListener(_onChanged);
    }

    super.didUpdateWidget(oldWidget as ExpandableStoreAddress);
  }

  void _onChanged() {
    widget.details!.addressLine1 = _addressLine1Controller!.text.trim();
    widget.details!.addressLine2 = _addressLine2Controller!.text.trim();
    widget.details!.city = _cityController!.text.trim();
    widget.details!.state = _stateController!.text.trim();
    widget.details!.postalCode = _postalCodeController!.text.trim();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      if (controller != null) {
        controller.removeListener(_onChanged);
        controller.dispose();
      }
    }

    _controllers.clear();

    _addressLine1Controller = null;
    _addressLine2Controller = null;
    _cityController = null;
    _stateController = null;
    _postalCodeController = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return addressPanel(context);
  }

  ExpansionTile addressPanel(context) {
    return ExpansionTile(
      //leading: Icon(Icons.map),
      tilePadding: EdgeInsets.zero,
      title: Text(
        widget.details!.friendlyName != null
            ? widget.details!.friendlyName!
            : 'No Address Information',
      ),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: StringFormField(
            enabled: widget.fieldsEnabled,
            useOutlineStyling: true,
            enforceMaxLength: true,
            maxLength: 50,
            hintText: 'Personalized Address Name',
            // controller: this._addressLine1Controller,
            //suffixIcon: Icons.map,
            key: const Key('friendlyName'),
            labelText: 'Friendly Address Name',
            onFieldSubmitted: (value) {
              widget.details!.friendlyName = value.trim();

              FocusScope.of(context).requestFocus(FocusNode());
            },
            inputAction: TextInputAction.done,
            initialValue: widget.details!.friendlyName,
            isRequired: false,
            onSaveValue: (value) {
              widget.details!.addressLine1 = value;
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: StringFormField(
            useOutlineStyling: true,
            enabled: widget.fieldsEnabled,
            enforceMaxLength: true,
            maxLength: 50,
            hintText: 'Street Address',
            // controller: this._addressLine1Controller,
            //suffixIcon: Icons.map,
            key: const Key('addressLine1'),
            labelText: 'Address Line 1',
            onFieldSubmitted: (value) {
              widget.details!.addressLine1 = value.trim();

              FocusScope.of(context).requestFocus(FocusNode());
            },
            inputAction: TextInputAction.done,
            initialValue: widget.details!.addressLine1,
            isRequired: false,
            onSaveValue: (value) {
              widget.details!.addressLine1 = value;
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: StringFormField(
            useOutlineStyling: true,
            enabled: widget.fieldsEnabled,
            enforceMaxLength: true,
            maxLength: 50,
            hintText: 'apartment, suite, unit, office',
            //suffixIcon: Icons.map,
            key: const Key('addressLine2'),
            labelText: 'Address Line 2',
            onFieldSubmitted: (value) {
              widget.details!.addressLine2 = value.trim();

              FocusScope.of(context).requestFocus(FocusNode());
            },
            inputAction: TextInputAction.done,
            initialValue: widget.details!.addressLine2,
            isRequired: false,
            onSaveValue: (value) {
              widget.details!.addressLine2 = value;
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: StringFormField(
            useOutlineStyling: true,
            enabled: widget.fieldsEnabled,
            enforceMaxLength: true,
            maxLength: 50,
            hintText: 'Johannesburg, Pretoria, etc.',
            //suffixIcon: Icons.map,
            key: const Key('city'),
            labelText: 'City',
            onFieldSubmitted: (value) {
              widget.details!.city = value.trim();

              FocusScope.of(context).requestFocus(FocusNode());
            },
            inputAction: TextInputAction.done,
            initialValue: widget.details!.city,
            isRequired: false,
            onSaveValue: (value) {
              widget.details!.city = value;
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: StringFormField(
            useOutlineStyling: true,
            enabled: widget.fieldsEnabled,
            enforceMaxLength: true,
            maxLength: 50,
            hintText: 'state, province',
            //suffixIcon: Icons.map,
            key: const Key('state'),
            labelText: 'State',
            onFieldSubmitted: (value) {
              widget.details!.state = value.trim();

              FocusScope.of(context).requestFocus(FocusNode());
            },
            inputAction: TextInputAction.done,
            initialValue: widget.details!.state,
            isRequired: false,
            onSaveValue: (value) {
              widget.details!.state = value;
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: StringFormField(
            useOutlineStyling: true,
            enabled: widget.fieldsEnabled,
            enforceMaxLength: true,
            maxLength: 8,
            hintText: 'Postal Code',
            //suffixIcon: Icons.map,
            key: const Key('postalcode'),
            labelText: 'Postal Code',
            onFieldSubmitted: (value) {
              widget.details!.postalCode = value.trim();

              FocusScope.of(context).requestFocus(FocusNode());
            },
            inputAction: TextInputAction.done,
            initialValue: widget.details!.postalCode,
            isRequired: false,
            onSaveValue: (value) {
              widget.details!.postalCode = value;
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
