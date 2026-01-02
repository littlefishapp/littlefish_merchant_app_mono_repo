// project imports
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/device/device_actions.dart';
import 'package:littlefish_merchant/ui/security/guestLogin/widgets/device_details_summary.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/ui/security/registration/functions/activation_functions.dart';
import 'package:littlefish_merchant/ui/splash/loading_page.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';

class GuestLoginPage extends StatefulWidget {
  static const route = 'login/guestLogin';

  final bool autoSignIn;

  const GuestLoginPage({required this.autoSignIn, Key? key}) : super(key: key);

  @override
  State<GuestLoginPage> createState() => _GuestLoginPageState();
}

class _GuestLoginPageState extends State<GuestLoginPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginVM>(
      converter: (Store<AppState> store) {
        return LoginVM.fromStore(store);
      },
      onDidChange: (oldVM, currentVM) {
        if (oldVM?.errorMessage != currentVM.errorMessage) {
          setState(() {});
        }
        // Check if device details were just initialized and auto sign-in is enabled
        if (widget.autoSignIn &&
            oldVM?.hasDeviceDetailsLoaded != true &&
            currentVM.hasDeviceDetailsLoaded == true &&
            currentVM.store?.state.deviceState.deviceDetails != null) {
          String? mid = formatMidValue(
            currentVM.store?.state.deviceState.deviceDetails?.merchantId,
          );

          currentVM.loginGuest!(context, mid, platformType);
        }
      },
      onInit: (store) {
        LoginVM vm = LoginVM.fromStore(store);
        if (store.state.deviceState.deviceDetails == null) {
          store.dispatch(InitializeDeviceDetailsAction());
          vm.checkDeviceDetailsStatus!(context);
        } else if (widget.autoSignIn) {
          String? mid = formatMidValue(
            store.state.deviceState.deviceDetails?.merchantId,
          );
          vm.loginGuest!(context, mid, platformType);
        }
      },
      builder: (BuildContext context, LoginVM vm) {
        return _scaffold(context, vm);
      },
    );
  }

  Widget _scaffold(BuildContext context, LoginVM vm) {
    return !loadingEnabled(vm)
        ? LoadingPage(
            enableLogon: false,
            onLogonCallback: () => vm.onLogon(context),
            displayMessage: vm.hasDeviceDetailsLoaded != true
                ? "We're preparing your guest experience\nThis may take up to a minute${_loadingEllipses()}"
                : null,
          )
        : AppScaffold(
            title: 'Guest Login',
            displayAppBar: true,
            centreTitle: false,
            persistentFooterButtons: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: loadingEnabled(vm)
                    ? ButtonPrimary(
                        text: 'Try Again',
                        buttonTextSize: PrimaryButtonTextSize.small,
                        onTap: (context) async {
                          if (vm.hasDeviceDetailsLoaded == true) {
                            String? mid = formatMidValue(
                              vm
                                  .store
                                  ?.state
                                  .deviceState
                                  .deviceDetails
                                  ?.merchantId,
                            );
                            await vm.loginGuest!(context, mid, platformType);
                          } else {
                            vm.store!.dispatch(InitializeDeviceDetailsAction());
                          }
                        },
                      )
                    : ButtonSecondary(
                        text: 'LOADING',
                        buttonTextSize: PrimaryButtonTextSize.small,
                        disabled: true,
                        onTap: (_) {},
                      ),
              ),
            ],
            body: layout(context, vm),
          );
  }

  Widget layout(BuildContext context, LoginVM vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 56),
            context.headingXSmall('Login Failed', isBold: true),
            const SizedBox(height: 24),
            context.labelSmall(
              'We could not verify your device and merchant information. If the problem persists, contact ${AppVariables.store?.state.appName ?? ''} Merchant Support at ${AppVariables.store!.state.clientSupportEmail} or ${AppVariables.store!.state.clientSupportMobileNumber}',
            ),
            const SizedBox(height: 24),
            DeviceDetailsSummary(
              deviceDetails: vm.store!.state.deviceState.deviceDetails,
              hasDeviceDetailsLoaded: vm.hasDeviceDetailsLoaded ?? false,
            ),
          ],
        ),
      ),
    );
  }

  bool loginButtonEnabled(LoginVM vm) {
    bool hasDeviceDetails = vm.hasDeviceDetailsLoaded == true;
    bool notLoading = vm.isLoading != true;

    return !(hasDeviceDetails && notLoading && isNotBlank(vm.errorMessage));
  }

  String _loadingEllipses() {
    int dotCount = DateTime.now().second % 3 + 1;
    return '.' * dotCount;
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {});
      } else {
        t.cancel();
      }
    });
  }

  bool loadingEnabled(LoginVM vm) {
    return (vm.isLoading == false && vm.hasDeviceDetailsLoaded != true) ||
        (vm.isLoading == false && isNotBlank(vm.errorMessage)) ||
        (vm.isLoading == false && isBlank(AppVariables.deviceInfo?.merchantId));
  }
}
