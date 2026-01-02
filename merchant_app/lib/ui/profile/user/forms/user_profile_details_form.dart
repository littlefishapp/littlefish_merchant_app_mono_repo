// remove ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/models/shared/country.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/locale/locale_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/app/app.dart';

import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../injector.dart';
import '../../../../tools/network_image/flutter_network_image.dart';

class UserProfileDetailsForm extends StatefulWidget {
  final UserProfile? profile;
  final GlobalKey? formKey;
  final bool enableEmail;
  final bool showEmail;
  final bool isCreateMode;
  final bool showCountryPicker;
  final bool isFormEditable;

  const UserProfileDetailsForm({
    Key? key,
    required this.profile,
    required this.formKey,
    this.isFormEditable = true,
    this.isCreateMode = false,
    this.enableEmail = true,
    this.showEmail = true,
    this.showCountryPicker = true,
  }) : super(key: key);

  @override
  State<UserProfileDetailsForm> createState() => _UserProfileDetailsFormState();
}

class _UserProfileDetailsFormState extends State<UserProfileDetailsForm> {
  late UserProfile? profile;

  BasicFormModel? model;

  GlobalKey<AutoCompleteTextFieldState<CountryStub>>? countryKey;

  @override
  void initState() {
    profile = widget.profile ?? UserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    countryKey = GlobalKey<AutoCompleteTextFieldState<CountryStub>>();
    return form(context);
  }

  refresh() {
    if (mounted) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  Form form(BuildContext context) {
    model ??= BasicFormModel(widget.formKey as GlobalKey<FormState>?);

    var store = StoreProvider.of<AppState>(context);

    profile?.countryCode = 'ZA';
    var cCode = CountryHelper.getCountryByIsoCode('ZA');
    var cStub = CountryStub(
      countryCode: 'ZA',
      countryName: 'South Africa',
      diallingCode: '27',
      currencyCode: cCode.currencyCode,
      countryCodeFull: cCode.iso3Code,
      enabled: true,
      shortCurrencyCode: cCode.currencyCode,
    );
    store.dispatch(SetLocaleAction(cStub));

    var currentLocale = store.state.localeState.currentLocale;

    var formFields = <Widget>[
      Visibility(visible: !widget.isCreateMode, child: avatar(context)),
      Visibility(
        visible: !widget.isCreateMode,
        child: const SizedBox(height: 16),
      ),
      if (widget.isCreateMode && widget.showCountryPicker)
        Visibility(
          visible:
              widget.isCreateMode ||
              currentLocale == null && widget.isFormEditable,
          child: CountryCodePicker(
            onChanged: (value) {
              profile?.countryCode = value.code!;
              var cCode = CountryHelper.getCountryByIsoCode(value.code ?? 'ZA');
              var cStub = CountryStub(
                countryCode: value.code,
                countryName: value.name,
                diallingCode: value.dialCode!.substring(1),
                currencyCode: cCode.currencyCode,
                countryCodeFull: cCode.iso3Code,
                enabled: true,
                shortCurrencyCode: cCode.currencyCode,
              );
              store.dispatch(SetLocaleAction(cStub));
              refresh();
            },
            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            initialSelection:
                LocaleProvider.instance.currentLocale?.countryCode,
            favorite: const ['+27', 'ZA'],
            // optional. Shows only country name and flag
            showCountryOnly: false,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: false,
            // optional. aligns the flag and the Text left
            alignLeft: false,
          ),
        ),
      // Visibility(
      //   visible: widget.isCreateMode || currentLocale == null,
      //   child: CountrySelectFormField(
      //     onSelected: (value) {
      //       profile?.countryCode = value?.countryCode;
      //       refresh();
      //     },
      //     initialValue: LocaleProvider.instance.currentLocale,
      //   ),
      // ),
      _spacing(),
      DropdownFormField(
        useOutlineStyling: true,
        hintText: 'Your title',
        labelText: 'Title',
        enabled: widget.isFormEditable,
        isRequired: false,
        inputAction: TextInputAction.next,
        nextFocusNode: model!.setFocusNode('firstname'),
        key: const Key('title'),
        onFieldSubmitted: (value) {
          profile?.prefix = value?.value;
          refresh();
        },
        onSaveValue: (value) {
          profile?.prefix = value?.value;
          refresh();
        },
        initialValue: profile?.prefix,
        values: widget.isFormEditable
            ? [
                DropDownValue(displayValue: 'Mr', index: 0, value: 'Mr'),
                DropDownValue(displayValue: 'Ms', index: 1, value: 'Ms'),
                DropDownValue(displayValue: 'Mrs', index: 2, value: 'Mrs'),
                DropDownValue(displayValue: 'Sir', index: 3, value: 'Sir'),
                DropDownValue(displayValue: 'Dr', index: 4, value: 'Dr'),
                DropDownValue(displayValue: 'Prof', index: 5, value: 'Prof'),
              ]
            : [],
      ),
      _spacing(spacing: 16),
      StringFormField(
        useOutlineStyling: true,
        enabled: currentLocale != null && widget.isFormEditable,
        enforceMaxLength: true,
        maxLength: 50,
        hintText: 'Your First Name',
        suffixIcon: Icons.person,
        key: const Key('firstname'),
        labelText: 'First Name',
        focusNode: model!.setFocusNode('firstname'),
        nextFocusNode: model!.setFocusNode('lastname'),
        asyncValidator: (value) {
          // if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value))
          if (value == null) return null;
          // Name allows for letters, accented letters, spaces, hyphens and apostrophes
          if (!RegExp(r"^[a-zA-ZÀ-ÖØ-öø-ÿ '-]+$").hasMatch(value)) {
            return 'Name cannot contain special characters.';
          }
          // if (!RegExp(r'^(\d|\w)+$').hasMatch(value))
          //   return 'Name cannot have special characters or spaces';
        },
        onFieldSubmitted: (value) {
          profile?.firstName = value;
          refresh();
        },
        inputAction: TextInputAction.next,
        initialValue: profile?.firstName,
        isRequired: true,
        onSaveValue: (value) {
          profile?.firstName = value;
          refresh();
        },
      ),
      _spacing(),
      StringFormField(
        useOutlineStyling: true,
        enabled: currentLocale != null && widget.isFormEditable,
        enforceMaxLength: true,
        maxLength: 50,
        suffixIcon: Icons.person,
        asyncValidator: (value) {
          if (value == null) return null;
          // Last name allows for letters, accented letters, spaces, hyphens and apostrophes
          if (!RegExp(r"^[a-zA-ZÀ-ÖØ-öø-ÿ '-]+$").hasMatch(value)) {
            return 'Last Name cannot contain special characters.';
          }
        },
        hintText: 'Last Name',
        key: const Key('lastname'),
        labelText: 'Last Name',
        focusNode: model!.setFocusNode('lastname'),
        nextFocusNode: model!.setFocusNode('mobilenumber'),
        onFieldSubmitted: (value) {
          profile?.lastName = value;
          refresh();
        },
        inputAction: TextInputAction.next,
        initialValue: profile?.lastName,
        isRequired: true,
        onSaveValue: (value) {
          profile?.lastName = value;
          refresh();
        },
      ),
      _spacing(),
      MobileNumberFormField(
        useOutlineStyling: true,
        enabled: currentLocale != null && widget.isFormEditable,
        country: currentLocale,
        hintText: 'Your mobile number',
        key: const Key('mobilenumber'),
        labelText: 'Mobile Number',
        focusNode: model!.setFocusNode('mobilenumber'),
        nextFocusNode: model!.setFocusNode('email'),
        onFieldSubmitted: (value) {
          value.toString().substring('+27'.length);
          profile?.mobileNumber = value;
        },
        inputAction: TextInputAction.next,
        initialValue: isBlank(profile?.mobileNumber?.toString())
            ? profile?.mobileNumber?.toString()
            : profile?.mobileNumber?.toString().substring('277'.length),
        isRequired: true,
        onSaveValue: (value) {
          value.toString().substring('+27'.length);
          profile?.mobileNumber = value;
        },
      ),
      if (widget.showEmail) ...[
        _spacing(),
        EmailFormField(
          useOutlineStyling: true,
          widgetOnBrandedSurface: isSBSA ? true : false,
          hintText: 'Email address',
          key: const Key('email'),
          focusNode: model!.setFocusNode('email'),
          nextFocusNode: model!.setFocusNode('nationality'),
          prefixIcon: Icons.email,
          isRequired: false,
          initialValue: profile?.email,
          inputAction: TextInputAction.next,
          labelText: 'Email Address',
          onSaveValue: (value) {
            profile?.email = value;
            refresh();
          },
          onFieldSubmitted: (value) {
            profile?.email = value;
            refresh();
          },
          enabled: widget.enableEmail && widget.isFormEditable,
          enforceMaxLength: true,
          maxLength: 50,
        ),
      ],
      _spacing(),
      DropdownFormField(
        enabled: currentLocale != null && widget.isFormEditable,
        hintText: 'Your Gender',
        useOutlineStyling: true,
        labelText: 'Gender',
        isRequired: false,
        inputAction: TextInputAction.next,
        key: const Key('gender'),
        onFieldSubmitted: (value) {
          profile?.gender = value?.value;
          refresh();
        },
        onSaveValue: (value) {
          profile?.gender = value?.value;
          refresh();
        },
        initialValue: profile?.gender,
        values: currentLocale != null && widget.isFormEditable
            ? [
                DropDownValue(
                  displayValue: 'Not specified',
                  index: 3,
                  value: Gender.notSpecified,
                ),
                DropDownValue(
                  displayValue: 'Male',
                  index: 0,
                  value: Gender.male,
                ),
                DropDownValue(
                  displayValue: 'Female',
                  index: 1,
                  value: Gender.female,
                ),
                DropDownValue(
                  displayValue: 'Other',
                  index: 2,
                  value: Gender.other,
                ),
              ]
            : [], // Empty list when currentLocale is null
      ),
    ];

    return Form(
      key: model!.formKey,
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

  GestureDetector avatar(BuildContext context) => GestureDetector(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(48)),
      alignment: Alignment.center,
      child: OutlineGradientAvatar(
        radius: 48,
        child: isNotBlank(profile!.profileImageUri)
            ? ClipOval(
                child: SizedBox(
                  width: 96, // Set the width and height to the same value
                  height: 96,
                  child: FadeInImage(
                    image: getIt<FlutterNetworkImage>().asImageProviderById(
                      id: profile!.userId ?? const Uuid().v4(),
                      category: 'users',
                      legacyUrl: profile!.profileImageUri!,
                      height: AppVariables.listImageHeight,
                      width: AppVariables.listImageWidth,
                    ),
                    placeholder: AssetImage(UIStateData().appLogo),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Icon(Icons.person, color: Colors.grey.shade700, size: 48.0),
      ),
    ),
    onTap: () => uploadImage(
      context,
      profile,
      // source: ImageSource.camera,
    ),
  );

  Future<void> uploadImage(BuildContext context, UserProfile? profile) async {
    // Choose to take image with camera or upload from gallery
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
      // Upload image to 'users' folder in Firebase Storage
      var downloadUrl = await FileManager().uploadFile(
        file: File(selectedImage.path),
        businessId: state.businessId!,
        category: 'users',
        id: profile!.userId ?? const Uuid().v4(),
        businessName: 'business-tag',
      );

      // Set profile image Uri to the firebase storage download url
      profile.profileImageUri = downloadUrl.downloadUrl;

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

  Widget _spacing({double spacing = 8}) => SizedBox(height: spacing);
}
