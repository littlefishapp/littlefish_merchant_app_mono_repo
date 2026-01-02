import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/text_widgets.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_contact_info_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';

class OnlineStoreDetailsPage extends StatefulWidget {
  static const route = 'online-store/business-details-intro';

  final String? storeName;
  final String? description;
  final String? slogan;
  final bool showPageNumber;
  final int pageNumber, totalNumPages;

  const OnlineStoreDetailsPage({
    Key? key,
    this.storeName,
    this.description,
    this.slogan,
    this.showPageNumber = true,
    this.pageNumber = 1,
    this.totalNumPages = 5,
  }) : super(key: key);

  @override
  State<OnlineStoreDetailsPage> createState() => _OnlineStoreDetailsPageState();
}

class _OnlineStoreDetailsPageState extends State<OnlineStoreDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _storeName;
  String? _description;
  String? _slogan;
  String? _initialSlogan;
  String? _initialName;
  String? _initialDescription;

  @override
  void initState() {
    if (isNotBlank(widget.storeName)) {
      _storeName = widget.storeName;
      _initialName = widget.storeName;
    }
    if (isNotBlank(widget.description)) {
      _description = widget.description;
      _initialDescription = widget.description;
    }
    if (isNotBlank(widget.slogan)) {
      _slogan = widget.slogan;
      _initialSlogan = widget.slogan;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      onInit: (store) {
        if (store.state.storeState.store == null) {
          store.dispatch(CreateDefaultStoreAction());
        }
      },
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        return scaffold(vm);
      },
    );
  }

  scaffold(ManageStoreVMv2 vm) {
    return KeyboardDismissalUtility(
      content: AppScaffold(
        title: 'General Business Details',
        centreTitle: false,
        body: vm.isLoading != true ? layout(vm) : const AppProgressIndicator(),
        enableProfileAction: false,
        actions: [
          Visibility(
            visible: widget.showPageNumber,
            child: PageNumberText(
              pageNumber: widget.pageNumber,
              totalNumPages: widget.totalNumPages,
            ),
          ),
        ],
        persistentFooterButtons: [
          FooterButtonsSecondaryPrimary(
            secondaryButtonText:
                !(vm.store!.state.storeState.store?.isConfigured ?? false)
                ? 'Skip'
                : 'Cancel',
            onSecondaryButtonPressed: (ctx) async {
              !(vm.store!.state.storeState.store?.isConfigured ?? false)
                  ? navigateToContactInfoPage(context, vm)
                  : Navigator.of(context).pop();
            },
            primaryButtonText:
                vm.store!.state.storeState.store?.isConfigured == true
                ? 'Save'
                : 'Next',
            onPrimaryButtonPressed: (ctx) async {
              if (_formKey.currentState == null) return;

              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                if (vm.item == null) return;

                if (isInfoChanged(_storeName!, _description!, _slogan!)) {
                  final completer = Completer<void>();
                  await vm.upsertStore(vm.item!, completer: completer);
                  await completer.future;
                }

                if (mounted) {
                  navigateToContactInfoPage(context, vm);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  layout(ManageStoreVMv2 vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.labelLarge(
              'General Information',
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
              isSemiBold: true,
            ),
            context.labelMedium(
              'Provide key details about your business to help customers learn more about you.',
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              alignLeft: true,
            ),
            Padding(padding: const EdgeInsets.only(top: 16), child: form(vm)),
          ],
        ),
      ),
    );
  }

  form(ManageStoreVMv2 vm) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StringFormField(
              key: const Key('online_store_name'),
              initialValue:
                  widget.storeName ?? vm.item?.displayName ?? vm.item?.name,
              onSaveValue: (value) {
                if (isNotBlank(value)) {
                  if (mounted) {
                    setState(() {
                      _storeName = value;
                      vm.store?.dispatch(SetStoreNameAction(value!));
                    });
                  }
                }
              },
              hintText:
                  'Enter the name of your online store eg My Awesome Shop',
              labelText: 'Online Store Name',
              useOutlineStyling: true,
              isRequired: true,
              useRegex: false,
              onFieldSubmitted: (value) {
                if (mounted) {
                  setState(() {
                    _storeName = value;
                  });
                }
              },
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _storeName = value;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StringFormField(
              key: const Key('online_store_slogan'),
              initialValue: widget.slogan ?? vm.item?.slogan,
              onSaveValue: (value) {
                if (isNotBlank(value)) {
                  if (mounted) {
                    setState(() {
                      _slogan = value;
                      vm.store?.dispatch(SetStoreSloganAction(value!));
                    });
                  }
                }
              },
              hintText: 'Add a catchy tagline for your homepage.',
              labelText: 'Store Slogan',
              maxLines: 1,
              maxLength: 50,
              useOutlineStyling: true,
              isRequired: false,
              useRegex: false,
              onFieldSubmitted: (value) {
                if (mounted) {
                  setState(() {
                    _slogan = value;
                  });
                }
              },
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _slogan = value;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StringFormField(
              key: const Key('online_store_description'),
              initialValue: widget.description ?? vm.item?.description,
              onSaveValue: (value) {
                if (isNotBlank(value) && mounted) {
                  setState(() {
                    _description = value;
                    vm.store?.dispatch(SetStoreDescriptionAction(value!));
                  });
                }
              },
              hintText: 'Describe your business for the About Us page',
              labelText: 'About My Business',
              useOutlineStyling: true,
              isRequired: true,
              minLines: 2,
              maxLines: 3,
              maxLength: 500,
              minLength: 1,
              useRegex: false,
              onFieldSubmitted: (value) {
                if (mounted) setState(() => _description = value);
              },
              onChanged: (value) {
                if (mounted) setState(() => _description = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isInfoChanged(String storeName, String description, String slogan) {
    if (isBlank(storeName) || isBlank(description) || isBlank(slogan)) {
      return false;
    }
    if (storeName != _initialName ||
        description != _initialDescription ||
        slogan != _initialSlogan) {
      return true;
    }
    return false;
  }

  void navigateToContactInfoPage(BuildContext context, ManageStoreVMv2 vm) {
    if (vm.store!.state.storeState.store?.isConfigured == true) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(
        CustomRoute(
          builder: (ctx) => OnlineStoreContactInfoPage(
            phoneNumber: vm.item?.contactInformation?.mobileNumber,
            email: vm.item?.contactInformation?.email,
          ),
        ),
      );
    }
  }
}
