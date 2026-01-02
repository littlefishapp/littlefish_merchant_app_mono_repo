import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app_device_incompatibility.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/login.dart';
import 'package:littlefish_merchant/redux/device/device_actions.dart';
import 'package:littlefish_merchant/tools/security/app_security_validation.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/security/login/landing_page.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/ui/splash/loading_page.dart';

class LoginPage extends StatefulWidget {
  static const route = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isValid = true;

  /// NOTE: [JAILBREAK] AND [ROOT] DETECTION
  bool _showIncompatibilityScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!AppVariables.isPOSBuild) {
        _performIntegrityCheck();
      }
    }
  }

  Future<void> _performIntegrityCheck() async {
    try {
      bool deviceIntegritySecure = await AppSecurityValidation()
          .checkDeviceIntegrity();

      if (!deviceIntegritySecure) {
        if (mounted) {
          setState(() {
            _showIncompatibilityScreen = true;
          });
        }

        // If device requirements are not met, show a message and exit the app
        // Automatically exit the app after 30 seconds
        Future.delayed(const Duration(seconds: 30), () async {
          SystemNavigator.pop();
          exit(0);
        });
      } else {
        // Device is secure, ensure we're not showing incompatibility screen
        if (_showIncompatibilityScreen && mounted) {
          setState(() {
            _showIncompatibilityScreen = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error during integrity check: $e');
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    debugPrint('#### Login page');

    /// [JAILBREAK] & [ROOT] DETECTION
    if (_showIncompatibilityScreen) {
      return const AppDeviceIncompatibility();
    }
    return StoreConnector<AppState, LoginVM>(
      onDispose: (store) => store.dispatch(AuthSetPasswordAction(null)),
      onInit: (store) {
        if (store.state.deviceState.deviceDetails == null) {
          store.dispatch(InitializeDeviceDetailsAction());
        }
      },
      builder: (BuildContext storeContext, LoginVM vm) {
        return PopScope(
          canPop: false,
          onPopInvoked: (hasPopped) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              LandingPage.route,
              (route) => false,
            ); // Prevent default back navigation
          },
          child: _body(context: storeContext, vm: vm),
        );
      },
      converter: (Store<AppState> store) {
        return LoginVM.fromStore(store)..key = formKey;
      },
    );
  }

  Widget _body({required BuildContext context, required LoginVM vm}) {
    return login(
      onSubmit: (String? username, String? password) {
        if (username == null || password == null) {
          return;
        }
        Navigator.of(context).push(
          CustomRoute(
            builder: (BuildContext context) => LoadingPage(
              // vm: vm,
              // parentContext: context,
              enableLogon: true,
              onLogonCallback: () => vm.onLogon(context),
            ),
          ),
        );
      },
      onValidate: (value) {
        setState(() {
          isValid = false;
        });
      },
      isLoading: vm.isLoading ?? false,
      loginVM: vm,
    );
  }
}
