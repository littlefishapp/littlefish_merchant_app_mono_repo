// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/google_address_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';

class AddressScreenDynamic extends StatefulWidget {
  final dynamic vm;
  final String? addressId;
  final StoreAddress? storeAddress;
  final String? modalTitle;

  const AddressScreenDynamic({
    Key? key,
    this.vm,
    this.addressId,
    this.storeAddress,
    this.modalTitle,
  }) : super(key: key);

  @override
  State<AddressScreenDynamic> createState() => _AddressScreenDynamicState();
}

class _AddressScreenDynamicState extends State<AddressScreenDynamic> {
  dynamic _vm;
  StoreAddress? localAddress;

  FlutterGooglePlacesSdk placesAPI = FlutterGooglePlacesSdk(
    kGoogleApiKey ?? '',
  );

  final expandedMargin = const EdgeInsets.only(
    top: 4,
    bottom: 4,
    left: 16,
    right: 12,
  );

  void setLoading(bool value) {
    if (mounted) {
      setState(() {
        _vm!.isLoading = value;
      });
    } else {
      _vm!.isLoading = value;
    }
  }

  final formKey = GlobalKey<FormState>();

  final List<FocusNode> _nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    _vm = widget.vm;
    localAddress = widget.storeAddress ?? StoreAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
            context.paragraphMedium(
              widget.modalTitle ?? 'Address',
              alignLeft: true,
              isBold: true,
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
      bottomNavigationBar: _vm!.isLoading!
          ? null
          : Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: ButtonPrimary(
                text: 'SAVE',
                onTap: (ctx) async {
                  if (!(formKey.currentState?.validate() ?? false)) return;

                  formKey.currentState!.save();

                  try {
                    setLoading(true);

                    await _vm!.saveAddress(
                      localAddress,
                      formKey,
                      context,
                      widget.addressId,
                    );

                    Navigator.of(context).pop(_vm);
                    // Navigator.of(ctx).pop();
                    showMessageDialog(
                      ctx,
                      'Address saved successfully!',
                      LittleFishIcons.info,
                    );
                  } catch (e) {
                    reportCheckedError(e);
                  } finally {
                    setLoading(false);
                  }
                },
              ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (_vm!.isLoading!) const LinearProgressIndicator(),
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 4,
                  bottom: 12,
                ),
                child: context.paragraphMedium(
                  'Select a method to search for an address.',
                  alignLeft: true,
                  isBold: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GoogleAddressFormField(
                  useOutlineStyling: true,
                  isRequired: false,
                  maxLines: 3,
                  key: const Key('businessdetailsAddress'),
                  initialValue: localAddress?.addressLine1 ?? '',
                  onFieldSubmitted: (addressText, address) {
                    if (mounted) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        localAddress = address;
                      });
                      FocusScope.of(context).unfocus();
                    }
                  },
                  onSaveValue: (value) {
                    if (mounted) {
                      setState(() {
                        localAddress?.addressLine1 = value;
                      });
                    }
                  },
                  hintText: 'Business Address',
                  labelText: 'Business Address',
                ),
              ),
              Visibility(
                // temporary removing Visiblity from End User to avoid Permission Issues
                visible: false,
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: const Text('Use Current Location'),
                  trailing: const Icon(Icons.location_on),
                  onTap: () async {
                    try {
                      setLoading(true);

                      var currentLocation =
                          await Geolocator.getCurrentPosition();

                      var result = (await placemarkFromCoordinates(
                        currentLocation.latitude,
                        currentLocation.longitude,
                      )).first;

                      localAddress!.addressLine1 =
                          '${result.name} ${result.thoroughfare}';

                      localAddress!.addressLine2 = result.subLocality;

                      localAddress!.city = result.locality;

                      localAddress!.state = result.administrativeArea;

                      localAddress!.postalCode = result.postalCode;

                      localAddress!.country = result.country;

                      if (mounted) setState(() {});
                    } catch (e) {
                      showMessageDialog(context, 'Error', Icons.location_off);
                      reportCheckedError(e);
                    } finally {
                      setLoading(false);
                    }
                  },
                ),
              ),
              form(context),
            ],
          ),
        ),
      ),
    );
  }

  Form form(context) {
    var formFields = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: <Widget>[
              if (localAddress!.isPartiallyPopulated)
                Material(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(localAddress!.toStringAddress()),
                  ),
                ),
              StringFormField(
                enforceMaxLength: true,
                useOutlineStyling: true,
                maxLength: 75,
                focusNode: _nodes[0],
                nextFocusNode: _nodes[1],
                hintText: 'Name',
                key: const Key('friendlyName'),
                labelText: 'Name',
                onFieldSubmitted: (value) {
                  localAddress!.friendlyName = value;
                },
                inputAction: TextInputAction.next,
                initialValue: localAddress!.friendlyName,
                isRequired: true,
                onSaveValue: (value) {
                  localAddress!.friendlyName = value;
                },
              ),
              const SizedBox(height: 8),
              StringFormField(
                enforceMaxLength: true,
                useOutlineStyling: true,
                maxLength: 255,
                hintText: 'Address Line 1',
                key: const Key('address1'),
                labelText: 'Address Line 1',
                focusNode: _nodes[1],
                nextFocusNode: _nodes[2],
                inputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  localAddress!.addressLine1 = value;
                },
                initialValue: localAddress!.addressLine1,
                isRequired: true,
                onSaveValue: (value) {
                  localAddress!.addressLine1 = value;
                },
              ),
              const SizedBox(height: 8),
              StringFormField(
                enforceMaxLength: true,
                useOutlineStyling: true,
                maxLength: 255,
                hintText: 'Address Line 2',
                key: const Key('address2'),
                labelText: 'Address Line 2',
                focusNode: _nodes[2],
                nextFocusNode: _nodes[3],
                onFieldSubmitted: (value) {
                  localAddress!.addressLine2 = value;
                },
                inputAction: TextInputAction.next,
                initialValue: localAddress!.addressLine2,
                isRequired: false,
                onSaveValue: (value) {
                  localAddress!.addressLine2 = value;
                },
              ),
            ],
          ),
        ],
      ),
    ];

    return Form(
      key: formKey,
      child: MediaQuery.removePadding(
        removeTop: true,
        removeBottom: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }
}
