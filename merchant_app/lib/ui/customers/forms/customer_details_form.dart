// Dart imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/common/presentaion/pages/address_screen_dynamic.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../injector.dart';
import '../../../providers/locale_provider.dart';
import '../../../common/presentaion/components/buttons/button_secondary.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/form_fields/email_form_field.dart';
import '../../../common/presentaion/components/form_fields/mobile_number_form_field.dart';
import '../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../common/presentaion/components/long_text.dart';
import '../../../tools/network_image/flutter_network_image.dart';

class CustomerDetailsForm extends StatefulWidget {
  const CustomerDetailsForm({Key? key, required this.vm}) : super(key: key);

  final CustomerViewModel vm;

  @override
  State<CustomerDetailsForm> createState() => _CustomerDetailsFormState();
}

class _CustomerDetailsFormState extends State<CustomerDetailsForm> {
  late CustomerViewModel vm;

  @override
  Widget build(BuildContext context) {
    vm = widget.vm;

    return KeyboardDismissalUtility(content: form(context));
  }

  Widget form(BuildContext context) {
    var imageIsNotBlank = isNotBlank(vm.item!.profileImageUri);
    final iconColor = Theme.of(context).extension<AppliedTextIcon>()?.brand;
    var formFields = <Widget>[
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Material(
            color: Theme.of(context).colorScheme.secondary,
            elevation: 1,
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => uploadImage(context, vm.item),
              child: Container(
                decoration: BoxDecoration(
                  color: imageIsNotBlank ? Colors.transparent : iconColor,
                  borderRadius: BorderRadius.circular(4),
                  image: imageIsNotBlank
                      ? DecorationImage(
                          image: getIt<FlutterNetworkImage>()
                              .asImageProviderById(
                                id: vm.item!.id!,
                                category: 'customers',
                                legacyUrl: vm.item!.profileImageUri!,
                                height: AppVariables.listImageHeight,
                                width: AppVariables.listImageWidth,
                              ),
                        )
                      : null,
                ),
                height: 80,
                width: 120,
                child: imageIsNotBlank
                    ? const SizedBox.shrink()
                    : const Icon(
                        Icons.camera_alt,
                        size: 48,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      StringFormField(
        enforceMaxLength: true,
        useOutlineStyling: true,
        maxLength: 50,
        minLength: 2,
        hintText: 'Enter First Name',
        key: const Key('firstname'),
        labelText: 'Name',
        labelStyle: context.styleParagraphSmallRegular,
        focusNode: vm.form!.setFocusNode('firstname'),
        nextFocusNode: vm.form!.setFocusNode('lastname'),
        onFieldSubmitted: (value) {
          vm.item!.firstName = value;
        },
        inputAction: TextInputAction.next,
        initialValue: vm.item!.firstName,
        isRequired: true,
        onSaveValue: (value) {
          vm.item!.firstName = value;
        },
        onChanged: (value) {
          if (isNotBlank(value)) vm.item!.firstName = value;
        },
      ),
      const SizedBox(height: 8),
      StringFormField(
        enforceMaxLength: true,
        maxLength: 50,
        useOutlineStyling: true,
        minLength: 2,
        hintText: 'Enter Last Name',
        key: const Key('lastname'),
        labelText: 'Last Name',
        labelStyle: context.styleParagraphSmallRegular,
        focusNode: vm.form!.setFocusNode('lastname'),
        nextFocusNode: vm.form!.setFocusNode('mobilenumber'),
        onFieldSubmitted: (value) {
          vm.item!.lastName = value;
        },
        inputAction: TextInputAction.next,
        initialValue: vm.item!.lastName,
        isRequired: true,
        onSaveValue: (value) {
          vm.item!.lastName = value;
        },
        onChanged: (value) {
          if (isNotBlank(value)) vm.item!.lastName = value;
        },
      ),
      const SizedBox(height: 8),
      MobileNumberFormField(
        useOutlineStyling: true,
        hintText: 'Mobile Number',
        country: CountryStub(
          countryCode: LocaleProvider.instance.currentLocale!.countryCode,
          diallingCode: LocaleProvider.instance.currentLocale!.diallingCode,
        ),
        key: const Key('mobilenumber'),
        labelText: 'Mobile Number',
        labelStyle: context.styleParagraphSmallRegular,
        focusNode: vm.form!.setFocusNode('mobilenumber'),
        nextFocusNode: vm.form!.setFocusNode('email'),
        initialValue: vm.item!.mobileNumber,
        onFieldSubmitted: (value) {
          vm.item!.mobileNumber = value;
        },
        inputAction: TextInputAction.next,
        isRequired: false,
        onSaveValue: (value) {
          vm.item!.mobileNumber = value;
        },
        onChanged: (value) {
          vm.item!.mobileNumber = value;
        },
      ),
      const SizedBox(height: 8),
      EmailFormField(
        textColor: Theme.of(context).colorScheme.onBackground,
        iconColor: Theme.of(context).colorScheme.onBackground,
        hintColor: Theme.of(context).colorScheme.onBackground,
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 50,
        hintText: 'Email address',
        key: const Key('email'),
        labelText: 'Email Address',
        focusNode: vm.form!.setFocusNode('email'),
        nextFocusNode: vm.form!.setFocusNode('id'),
        onFieldSubmitted: (value) {
          vm.item!.email = value;
        },
        inputAction: TextInputAction.next,
        initialValue: vm.item!.email,
        isRequired: false,
        onSaveValue: (value) {
          if (vm.item != null) {
            vm.item!.email = value;
          }
        },
        onChanged: (value) {
          if (isNotBlank(value)) vm.item!.email = value;
        },
      ),
      Container(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(vertical: 12),
        child:
            vm.item!.address != null && vm.item!.address!.friendlyName != null
            ? ButtonBar(
                buttonMinWidth: MediaQuery.of(context).size.width,
                alignment: MainAxisAlignment.start,
                buttonPadding: EdgeInsets.zero,
                children: [
                  ElevatedButton(
                    // TODO(lampian): fix 229 to 230
                    // padding: EdgeInsets.zero,
                    // color: Theme.of(context).colorScheme.secondary,
                    child: context.paragraphSmall(
                      '${vm.item?.address?.friendlyName} '
                      '${vm.item?.address?.addressLine1} '
                      '${vm.item?.address?.addressLine2}',
                      isSemiBold: true,
                    ),
                    onPressed: () async {
                      await showPopupDialog(
                        context: context,
                        content: AddressScreenDynamic(
                          vm: vm,
                          addressId: 'cust',
                          storeAddress: vm.item!.address,
                          modalTitle: 'Customer Address',
                        ),
                      );
                      setState(() {});
                    },
                  ),
                ],
              )
            : ButtonSecondary(
                onTap: (c) async {
                  setState(() {});
                  await showPopupDialog(
                    context: context,
                    content: AddressScreenDynamic(
                      vm: vm,
                      addressId: 'cust',
                      storeAddress: vm.item!.address,
                      modalTitle: 'Customer Address',
                    ),
                  );
                  setState(() {});
                },
                text: 'Customer Address',
              ),
      ),
      companyDetailsExpanded(vm, context, true),
    ];

    return Form(
      key: vm.form!.key,
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

  Future<void> uploadImage(BuildContext context, Customer? customer) async {
    var imageSource = await FileManager().selectFileSource(context);

    if (imageSource == null) return;
    var imgPicker = ImagePicker();
    var selectedImage = await imgPicker.pickImage(source: imageSource);

    if (selectedImage == null) return;

    if (!await FileManager().isFileTypeAllowed(selectedImage, context)) {
      return;
    }

    showProgress(context: context);

    try {
      var state = StoreProvider.of<AppState>(context).state;

      var downloadUrl = await FileManager().uploadFile(
        file: File(selectedImage.path),
        businessId: state.businessId!,
        category: 'customers',
        id: customer!.id ?? const Uuid().v4(),
        businessName: 'business-tag',
      );

      customer.profileImageUri = downloadUrl.downloadUrl;

      hideProgress(context);
      //we should change the image to the new one
      if (mounted) setState(() {});
    } on PlatformException catch (e) {
      hideProgress(context);

      showMessageDialog(
        context,
        '${e.code}: ${e.message}',
        LittleFishIcons.warning,
      );
    } catch (e) {
      hideProgress(context);

      reportCheckedError(e, trace: StackTrace.current);

      showMessageDialog(
        context,
        'Something went wrong, please try again later',
        LittleFishIcons.error,
      );
    }
  }

  ExpansionTile companyDetailsExpanded(
    CustomerViewModel vm,
    BuildContext context,
    bool enabled,
  ) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: const Text('Company Details'),
      subtitle: const LongText("Customer's Company Details"),
      children: <Widget>[
        const SizedBox(height: 8),
        StringFormField(
          enabled: enabled,
          maxLength: 40,
          useOutlineStyling: true,
          hintText: 'Company Name',
          key: const Key('compName'),
          labelText: 'Company Name',
          labelStyle: context.styleParagraphSmallRegular,
          focusNode: vm.form!.setFocusNode('compName'),
          nextFocusNode: vm.form!.setFocusNode('compRegNo'),
          onFieldSubmitted: (value) {
            vm.item!.companyName = value;
          },
          inputAction: TextInputAction.next,
          initialValue: vm.item!.companyName,
          isRequired: false,
          onSaveValue: (value) {
            vm.item!.companyName = value;
          },
          onChanged: (value) {
            vm.item!.companyName = value;
          },
        ),
        const SizedBox(height: 8),
        StringFormField(
          enabled: enabled,
          maxLength: 40,
          useOutlineStyling: true,
          hintText: 'Company VAT/Registration No.',
          key: const Key('compRegNo'),
          labelText: 'Company VAT/Registration No.',
          labelStyle: context.styleParagraphSmallRegular,
          focusNode: vm.form!.setFocusNode('compRegNo'),
          nextFocusNode: vm.form!.setFocusNode('compContactNum'),
          onFieldSubmitted: (value) {
            vm.item!.companyRegVatNumber = value;
          },
          inputAction: TextInputAction.next,
          initialValue: vm.item!.companyRegVatNumber,
          isRequired: false,
          onSaveValue: (value) {
            vm.item!.companyRegVatNumber = value;
          },
          onChanged: (value) {
            vm.item!.companyRegVatNumber = value;
          },
        ),
        const SizedBox(height: 8),
        MobileNumberFormField(
          enabled: enabled,
          hintText: 'Company Contact Number',
          useOutlineStyling: true,
          country: CountryStub(
            countryCode: LocaleProvider.instance.currentLocale!.countryCode,
            diallingCode: LocaleProvider.instance.currentLocale!.diallingCode,
          ),
          key: const Key('compContactNum'),
          labelText: 'Company Contact Number',
          labelStyle: context.styleParagraphSmallRegular,
          focusNode: vm.form!.setFocusNode('compContactNum'),
          nextFocusNode: vm.form!.setFocusNode('compContactNum'),
          initialValue: vm.item!.companyContactNumber,
          onFieldSubmitted: (value) {
            if (isNotBlank(value)) {
              vm.item!.companyContactNumber = value;
            }
          },
          inputAction: TextInputAction.next,
          isRequired: false,
          onSaveValue: (value) {
            if (isNotBlank(value)) vm.item!.companyContactNumber = value;
          },
          onChanged: (value) {
            if (isNotBlank(value)) {
              vm.item!.companyContactNumber = value;
            }
          },
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child:
              vm.item!.companyAddress != null &&
                  vm.item!.companyAddress!.friendlyName != null
              ? ButtonBar(
                  buttonMinWidth: MediaQuery.of(context).size.width - 8,
                  alignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      child: context.paragraphSmall(
                        '${vm.item?.companyAddress?.friendlyName} '
                        '${vm.item?.companyAddress?.addressLine1} '
                        '${vm.item?.companyAddress?.addressLine2}',
                        isSemiBold: true,
                      ),
                      onPressed: () async {
                        await showPopupDialog(
                          context: context,
                          content: AddressScreenDynamic(
                            vm: vm,
                            addressId: 'comp',
                            storeAddress: vm.item!.companyAddress,
                            modalTitle: 'Company Address',
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  ],
                )
              : ButtonSecondary(
                  onTap: (c) async {
                    await showPopupDialog(
                      context: context,
                      content: AddressScreenDynamic(
                        vm: vm,
                        addressId: 'comp',
                        storeAddress: vm.item!.companyAddress,
                        modalTitle: 'Company Address',
                      ),
                    );
                    setState(() {});
                  },
                  text: 'Company Address',
                ),
        ),
      ],
    );
  }

  updateLocalVM(CustomerViewModel vm) {
    vm.item?.address = vm.item?.address;
    vm.item?.companyAddress = vm.item?.companyAddress;
  }
}
