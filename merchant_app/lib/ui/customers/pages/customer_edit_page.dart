// remove ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_selectors.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/customers/forms/customer_details_form.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/ui/reports/shared/widgets/summary_card.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/decorated_text.dart';
import '../../../common/presentaion/components/long_text.dart';
import '../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../tools/network_image/flutter_network_image.dart';

class CustomerEditPage extends StatefulWidget {
  static const String route = '/customer-edit';

  final Customer? customer;

  final bool isEmbedded;
  final BuildContext? parentContext;
  final bool clearCustomerOnPop;

  const CustomerEditPage({
    Key? key,
    this.parentContext,
    this.customer,
    this.isEmbedded = false,
    this.clearCustomerOnPop = true,
  }) : super(key: key);

  @override
  State<CustomerEditPage> createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.5, initialPage: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CustomerViewModel>(
      converter: (Store store) {
        return CustomerViewModel.fromStore(store as Store<AppState>)
          ..key = key
          ..form = FormManager(key);
      },
      builder: (BuildContext ctx, CustomerViewModel vm) {
        if (widget.customer != null) {
          if (vm.item == null) {
            vm.item = widget.customer;
          } else if (vm.item!.id != widget.customer!.id) {
            vm.item = widget.customer;
          }
        } else if (ModalRoute.of(context)!.settings.arguments != null) {
          vm.item ??= (ModalRoute.of(context)!.settings.arguments as List)[0];
        }
        return PopScope(
          canPop: true,
          child: scaffold(context, vm),
          onPopInvoked: (didPop) {
            if (widget.clearCustomerOnPop) {
              vm.store?.dispatch(ClearCustomerItemAction());
            }
            return;
          },
        );
      },
    );
  }

  Widget scaffold(context, CustomerViewModel vm) => AppScaffold(
    enableProfileAction: false,
    displayBackNavigation: true,
    title: isBlank(vm.item?.displayName)
        ? 'New Customer'
        : vm.item!.displayName ?? 'New Customer',
    body: vm.isLoading! ? const AppProgressIndicator() : layout(context, vm),
    persistentFooterButtons: [
      FooterButtonsSecondaryPrimary(
        primaryButtonText: 'Save',
        onPrimaryButtonPressed: (_) async {
          if (vm.key!.currentState!.validate()) {
            final dupError = validateDuplicateEmail(
              vm.item?.email,
              currentId: vm.item?.id,
            );
            if (dupError != null) {
              await showMessageDialog(
                context,
                dupError,
                LittleFishIcons.warning,
              );
              return;
            }

            if ((isBlank(vm.item!.mobileNumber) ||
                    ((vm.item?.mobileNumber?.length ?? 0) <= 3)) &&
                isBlank(vm.item!.email)) {
              await showMessageDialog(
                context,
                'Please provide either a mobile number or email address',
                LittleFishIcons.warning,
              );
              return;
            }

            if (validatePhoneNumber(vm.item!.mobileNumber) != null &&
                isBlank(vm.item?.email)) {
              await showMessageDialog(
                context,
                validatePhoneNumber(vm.item!.mobileNumber),
                LittleFishIcons.warning,
              );
              return;
            }

            if (validateEmail(vm.item!.email) != null &&
                (isBlank(vm.item!.mobileNumber) ||
                    ((vm.item?.mobileNumber?.length ?? 0) <= 3))) {
              await showMessageDialog(
                context,
                validateEmail(vm.item!.email),
                LittleFishIcons.warning,
              );
              return;
            }
            vm.item = await vm.onAdd(vm.item, context);
          }
        },
        secondaryButtonText: 'Cancel',
        onSecondaryButtonPressed: (_) {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  Column layout(context, CustomerViewModel vm) =>
      Column(children: <Widget>[Expanded(child: form(context, vm))]);

  Container form(BuildContext context, CustomerViewModel vm) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: CustomerDetailsForm(vm: vm),
  );

  SizedBox stats(vm) {
    return SizedBox(
      height: 88,
      child: PageView(
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          SummaryCard(
            context,
            value: vm._item.totalSaleValue?.toStringAsFixed(2) ?? '0.0',
            title: 'Total Sales',
          ),
          SummaryCard(
            context,
            value: vm._item.averageSaleValue?.toStringAsFixed(2) ?? '0.0',
            asDouble: false,
            title: 'Average Sale Value',
          ),
          SummaryCard(
            context,
            value: vm._item.totalSaleCount ?? 0,
            asDouble: false,
            title: 'Total Sale Count',
          ),
          if (storeCreditSettings(vm.store.state)?.enabled == true &&
              vm.store.state.enableStoreCredit == true)
            SummaryCard(
              context,
              value: vm._item.creditBalance?.toStringAsFixed(2) ?? '0.0',
              title: 'Credit Balance',
            ),
        ],
      ),
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    var country = CountryStub(
      countryCode: LocaleProvider.instance.currentLocale!.countryCode,
      diallingCode: LocaleProvider.instance.currentLocale!.diallingCode,
    );

    var requiredLength = 9 + country.diallingCode!.length;

    if (value.length < requiredLength) return 'Enter a valid phone number';

    final RegExp phoneExp = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneExp.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final RegExp emailExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validateDuplicateEmail(String? value, {String? currentId}) {
    final normalized = (value ?? '').trim().toLowerCase();
    if (normalized.isEmpty) return null;

    final allCustomers =
        AppVariables.store?.state.customerstate.customers ?? [];
    final exists = allCustomers.any(
      (c) =>
          c.id != currentId &&
          (c.email ?? '').trim().toLowerCase() == normalized,
    );

    return exists ? 'Email already exists for another customer' : null;
  }
}

class CustomerHeader extends StatefulWidget {
  final Customer customer;

  const CustomerHeader({Key? key, required this.customer}) : super(key: key);

  @override
  State<CustomerHeader> createState() => _CustomerHeaderState();
}

class _CustomerHeaderState extends State<CustomerHeader> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Material(
                        color: Theme.of(context).colorScheme.secondary,
                        elevation: 1,
                        borderRadius: BorderRadius.circular(4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () => uploadImage(
                            context,
                            widget.customer,
                            // source: ImageSource.camera,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: isNotBlank(widget.customer.profileImageUri)
                                  ? DecorationImage(
                                      image: getIt<FlutterNetworkImage>()
                                          .asImageProviderById(
                                            id: widget.customer.id!,
                                            category: 'customers',
                                            legacyUrl: widget
                                                .customer
                                                .profileImageUri!,
                                            height:
                                                AppVariables.listImageHeight,
                                            width: AppVariables.listImageWidth,
                                          ),
                                    )
                                  : null,
                            ),
                            height: 100,
                            width: 120,
                            child: isNotBlank(widget.customer.profileImageUri)
                                ? const SizedBox.shrink()
                                : const Icon(
                                    Icons.camera_alt,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: 8),
                    // Text(widget.customer.displayName)
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 0.5, indent: 24, endIndent: 24),
            const SizedBox(width: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const LongText(
                      'Total Purchases',
                      alignment: TextAlign.left,
                      fontSize: 12,
                    ),
                    DecoratedText(
                      TextFormatter.toStringCurrency(
                        widget.customer.totalSaleValue ?? 0,
                        displayCurrency: false,
                        currencyCode: '',
                      ),
                      fontSize: 20,
                      alignment: Alignment.centerLeft,
                      fontWeight: FontWeight.bold,
                      textColor: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 4),
                    const LongText(
                      'Average Purchase',
                      alignment: TextAlign.left,
                      fontSize: 12,
                    ),
                    DecoratedText(
                      TextFormatter.toStringCurrency(
                        widget.customer.averageSaleValue ?? 0,
                        displayCurrency: false,
                        currencyCode: '',
                      ),
                      fontSize: 20,
                      alignment: Alignment.centerLeft,
                      fontWeight: FontWeight.bold,
                      textColor: Theme.of(context).colorScheme.primary,
                    ),
                    if (storeCreditSettings(
                          AppVariables.store!.state,
                        )?.enabled ==
                        true)
                      const SizedBox(height: 4),
                    if (storeCreditSettings(
                          AppVariables.store!.state,
                        )?.enabled ==
                        true)
                      const LongText(
                        'Credit Balance',
                        alignment: TextAlign.left,
                        fontSize: 12,
                      ),
                    if (storeCreditSettings(
                          AppVariables.store!.state,
                        )?.enabled ==
                        true)
                      DecoratedText(
                        TextFormatter.toStringCurrency(
                          widget.customer.creditBalance ?? 0,
                          displayCurrency: false,
                          currencyCode: '',
                        ),
                        fontSize: 20,
                        alignment: Alignment.centerLeft,
                        fontWeight: FontWeight.bold,
                        textColor: Theme.of(context).colorScheme.primary,
                      ),
                    const SizedBox(height: 4),
                    const LongText(
                      'Total Visits',
                      alignment: TextAlign.left,
                      fontSize: 12,
                    ),
                    DecoratedText(
                      (widget.customer.totalSaleCount ?? 0).toString(),
                      fontSize: 20,
                      alignment: Alignment.centerLeft,
                      fontWeight: FontWeight.bold,
                      textColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage(BuildContext context, Customer customer) async {
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
        id: customer.id ?? const Uuid().v4(),
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
        'Unable to save customer details. Please verify the information and try again.',
        LittleFishIcons.error,
      );
    }
  }
}
