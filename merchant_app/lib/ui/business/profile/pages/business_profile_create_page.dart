import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/security/login/landing_page.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/ui/business/profile/forms/business_profile_create_form.dart';
import 'package:littlefish_merchant/ui/business/profile/viewmodels/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/toggle_button_bar.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class BusinessProfileCreatePage extends StatefulWidget {
  static const String route = '/business-profile-create';

  final Function? onSubmit;

  const BusinessProfileCreatePage({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<BusinessProfileCreatePage> createState() =>
      _BusinessProfileCreatePageState();
}

class _BusinessProfileCreatePageState extends State<BusinessProfileCreatePage> {
  BusinessProfileCreateVM? _vm;

  bool isNewBusiness = true;

  String? inviteCode;

  GlobalKey<FormState> createKey = GlobalKey<FormState>();

  GlobalKey<FormState> joinKey = GlobalKey<FormState>();

  PageController? controller;

  ToggleButtonBar? toggleButtonBar;

  BuildContext? baseContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = PageController(initialPage: isNewBusiness ? 0 : 1);

    baseContext = context;

    return StoreConnector<AppState, BusinessProfileCreateVM?>(
      distinct: true,
      onInit: (store) {
        store.dispatch(loadBusinessProfile());
        //This is used to create default business profile if one hasn't been created yet
        if (store.state.businessState.profile == null) {
          store.dispatch(
            BusinessProfileLoadedAction(
              BusinessProfile(
                businessEmail: store.state.authManager.user?.email,
              ),
            ),
          );
        }
        // Load business types if not loaded
        if (store.state.businessState.types == null ||
            store.state.businessState.types!.isEmpty) {
          store.dispatch(loadBusinessTypes());
        }
      },
      converter: (Store<AppState> store) {
        _vm = BusinessProfileCreateVM.fromStore(store)
          ..selectedType = _vm?.selectedType
          ..form = FormManager(createKey);

        return _vm;
      },
      builder: (BuildContext ctx, BusinessProfileCreateVM? vm) =>
          scaffold(ctx, vm!),
    );
  }

  AppScaffold scaffold(context, BusinessProfileCreateVM vm) => AppScaffold(
    title: 'Complete your Profile',
    displayAppBar: true,
    body: vm.isLoading! ? const AppProgressIndicator() : body(context, vm),
    displayNavDrawer: false,
    enableProfileAction: false,
    displayBackNavigation: false,
    persistentFooterButtons: [
      FooterButtonsSecondaryPrimary(
        primaryButtonText: 'Create Business',
        primaryButtonDisabled: vm.isLoading ?? false,
        secondaryButtonText: 'Go Back',
        onPrimaryButtonPressed: (ctx) {
          if (vm.form.key!.currentState!.validate()) {
            vm.form.key!.currentState!.save();
            if (isYellowToast) {
              String mid = AppVariables.store!.state.merchantID;
              String mcc = AppVariables.store!.state.mcc;
              if (mid.length < 10) {
                mid = mid.padLeft(10, '0');
              }
              vm.item?.masterMerchantId = mid;
              vm.item?.mcc = mcc;
            }
            vm.item?.dateEstablished = DateTime.now();
            widget.onSubmit == null
                ? vm.onAdd(vm.item, baseContext)
                : widget.onSubmit!();
          }
        },
        onSecondaryButtonPressed: (ctx) async {
          await Navigator.of(
            context,
          ).push(CustomRoute(builder: (context) => const LandingPage()));
        },
      ),
    ],
  );

  Container body(context, BusinessProfileCreateVM vm) {
    var result = Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const LongText(
              "We want to know how exactly we can meet the need's of your business, fill out the information below so we can make your experience the best experience",
              fontSize: null,
              alignment: TextAlign.center,
              maxLines: 10,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: BusinessProfileCreateForm(model: vm),
          ),
        ],
      ),
    );
    return result;
  }
}
