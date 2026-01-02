import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/google_address_form_field.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart';
import 'package:littlefish_merchant/models/shared/data/address.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/app.dart';
import '../../../../app/theme/ui_state_data.dart';
import '../../../../common/presentaion/components/circle_gradient_avatar.dart';
import '../../../../injector.dart';
import '../../../../redux/app/app_state.dart';
import '../../../../redux/business/business_actions.dart';
import '../../../../tools/file_manager.dart';
import '../../../../tools/helpers.dart';
import '../../../../tools/network_image/flutter_network_image.dart';

class BusinessDetailsForm extends StatefulWidget {
  final BusinessProfile? profile;

  final GlobalKey formKey;

  const BusinessDetailsForm({
    Key? key,
    required this.profile,
    required this.formKey,
  }) : super(key: key);

  @override
  State<BusinessDetailsForm> createState() => _BusinessDetailsFormState();
}

class _BusinessDetailsFormState extends State<BusinessDetailsForm> {
  final List<FocusNode> _nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  late Address _address;

  @override
  initState() {
    super.initState();
    _address = widget.profile?.address ?? Address();
  }

  @override
  Widget build(BuildContext context) {
    return form(context);
  }

  Form form(BuildContext context) {
    final BasicFormModel formModel = BasicFormModel(
      widget.formKey as GlobalKey<FormState>?,
    );

    var formFields = <Widget>[
      avatar(context),
      const CommonDivider(),
      _spacer(),
      StringFormField(
        useOutlineStyling: true,
        textStyle: context.appThemeTextFormText,
        labelStyle: context.appThemeTextFormLabel,
        enforceMaxLength: true,
        maxLength: 50,
        hintText: 'What is your business name?',
        suffixIcon: Icons.store,
        key: const Key('businessname'),
        labelText: 'Business Name',
        focusNode: _nodes[0],
        nextFocusNode: _nodes[1],
        onFieldSubmitted: (value) {
          widget.profile!.name = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.profile!.name,
        isRequired: true,
        onSaveValue: (value) {
          widget.profile!.name = value;
        },
      ),
      _spacer(),
      StringFormField(
        useOutlineStyling: true,
        textStyle: context.appThemeTextFormText,
        labelStyle: context.appThemeTextFormLabel,
        enforceMaxLength: false,
        maxLength: 255,
        hintText: 'Describe your business?',
        suffixIcon: Icons.store,
        key: const Key('description'),
        labelText: 'Description',
        focusNode: _nodes[1],
        nextFocusNode: _nodes[2],
        onFieldSubmitted: (value) {
          widget.profile!.description = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.profile!.description,
        isRequired: false,
        onSaveValue: (value) {
          widget.profile!.description = value;
        },
      ),
      _spacer(),
      StringFormField(
        useOutlineStyling: true,
        textStyle: context.appThemeTextFormText,
        labelStyle: context.appThemeTextFormLabel,
        enforceMaxLength: false,
        maxLength: 255,
        hintText: '@your-business',
        suffixIcon: FontAwesomeIcons.instagram,
        key: const Key('instahandle'),
        labelText: 'Instagram Handle',
        focusNode: _nodes[2],
        nextFocusNode: _nodes[3],
        onFieldSubmitted: (value) {
          widget.profile!.instagramHandle = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.profile!.instagramHandle,
        isRequired: false,
        onSaveValue: (value) {
          widget.profile!.instagramHandle = value;
        },
      ),
      _spacer(),
      MobileNumberFormField(
        useOutlineStyling: true,
        textStyle: context.appThemeTextFormText,
        labelStyle: context.appThemeTextFormLabel,
        hintText: 'Whatsapp Line',
        key: const Key('whatsappLine'),
        labelText: 'Whatsapp Line',
        suffixIcon: FontAwesomeIcons.whatsapp,
        country: LocaleProvider.instance.currentLocale,
        focusNode: _nodes[3],
        nextFocusNode: _nodes[4],
        initialValue: tryTrimMobileNumber(widget.profile!.whatsappLine),
        onFieldSubmitted: (value) {
          widget.profile!.whatsappLine = value;
        },
        inputAction: TextInputAction.next,
        isRequired: false,
        onSaveValue: (value) {
          widget.profile!.whatsappLine = value;
        },
      ),
      _spacer(),
      MobileNumberFormField(
        useOutlineStyling: true,
        textStyle: context.appThemeTextFormText,
        labelStyle: context.appThemeTextFormLabel,
        hintText: 'Primary Telephone Number',
        key: const Key('telnumber'),
        labelText: 'Telephone Number',
        country: LocaleProvider.instance.currentLocale,
        focusNode: _nodes[4],
        nextFocusNode: _nodes[5],
        initialValue: tryTrimMobileNumber(
          widget.profile!.contactDetails!.value,
        ),
        onFieldSubmitted: (value) {
          widget.profile!.contactDetails!.value = value;
        },
        inputAction: TextInputAction.next,
        isRequired: false,
        onSaveValue: (value) {
          widget.profile!.contactDetails!.value = value;
        },
      ),
      _spacer(),
      StringFormField(
        useOutlineStyling: true,
        textStyle: context.appThemeTextFormText,
        labelStyle: context.appThemeTextFormLabel,
        enforceMaxLength: true,
        maxLength: 50,
        maxLines: 1,
        // suffixIcon: Icons.person,
        hintText: 'Tax / Vat Number',
        key: const Key('taxnumber'),
        labelText: 'Tax Number',
        focusNode: _nodes[5],
        nextFocusNode: _nodes[6],
        onFieldSubmitted: (value) {
          widget.profile!.taxNumber = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.profile!.taxNumber,
        isRequired: false,
        onSaveValue: (value) {
          widget.profile!.taxNumber = value;
        },
      ),
      _spacer(),
      StringFormField(
        useOutlineStyling: true,
        textStyle: context.appThemeTextFormText,
        labelStyle: context.appThemeTextFormLabel,
        enforceMaxLength: true,
        maxLength: 50,
        suffixIcon: Icons.web,
        // controller: TextEditingController(text: widget.employee.email),
        hintText: 'www.amazingsupplier.com',
        key: const Key('website'),
        labelText: 'Website',
        focusNode: _nodes[6],
        onFieldSubmitted: (value) {
          widget.profile!.website = value;
          // FocusScope.of(context).requestFocus(formModel.setFocusNode(""));
        },
        inputAction: TextInputAction.done,
        initialValue: widget.profile!.website,
        isRequired: false,
        onSaveValue: (value) {
          widget.profile!.website = value;
        },
      ),
      _spacer(),
      GoogleAddressFormField(
        useOutlineStyling: true,
        isRequired: false,
        maxLines: 3,
        key: const Key('businessdetailsAddress'),
        initialValue: _address.isAddressEmpty ? null : _address.address,
        onFieldSubmitted: (addressText, address) {
          if (mounted) {
            FocusScope.of(context).unfocus();
            setState(() {
              _address = _mapToBasicAddress(addressText, address);
            });
            FocusScope.of(context).unfocus();
          }
        },
        onSaveValue: (value) {
          if (mounted) {
            setState(() {
              widget.profile!.address = _address;
            });
          }
        },
        hintText: 'Business Address',
        labelText: 'Business Address',
      ),
      _spacer(),
    ];

    return Form(
      key: formModel.formKey,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }

  Widget _spacer({double height = 8}) => SizedBox(height: height);

  Address _mapToBasicAddress(String addressText, StoreAddress address) {
    return Address(
      address1: address.addressLine1,
      address2: address.addressLine2,
      city: address.city,
      country: address.country,
      postalCode: address.postalCode,
      state: address.state,
    );
  }

  GestureDetector avatar(BuildContext context) => GestureDetector(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(48)),
      alignment: Alignment.center,
      child: OutlineGradientAvatar(
        radius: 48,
        child: isNotBlank(widget.profile!.logoUri)
            ? ClipOval(
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: FadeInImage(
                    image: getIt<FlutterNetworkImage>().asImageProviderById(
                      id: widget.profile!.id ?? const Uuid().v4(),
                      category: 'businesses',
                      legacyUrl: widget.profile!.logoUri!,
                      height: AppVariables.listImageHeight,
                      width: AppVariables.listImageWidth,
                    ),
                    placeholder: AssetImage(UIStateData().appLogo),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Icon(Icons.store, color: Colors.grey.shade700, size: 48.0),
      ),
    ),
    onTap: () => uploadImage(context, widget.profile),
  );

  Future<void> uploadImage(
    BuildContext context,
    BusinessProfile? profile,
  ) async {
    var imageSource = await FileManager().selectFileSource(context);
    if (imageSource == null) return;

    var imgPicker = ImagePicker();
    var selectedImage = await imgPicker.pickImage(source: imageSource);
    if (selectedImage == null) return;

    if (!await FileManager().isFileTypeAllowed(selectedImage, context)) return;

    StoreProvider.of<AppState>(context).dispatch(
      uploadBusinessLogo(
        file: File(selectedImage.path),
        profileId: profile?.id,
        context: context,
        onComplete: (String url) {
          profile?.logoUri = url;
          if (mounted) setState(() {});
        },
      ),
    );
  }
}
