import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/ui/security/registration/forms/register_form.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/models/security/user/business_user_profile.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class RegisterPage extends StatefulWidget {
  static const route = '/register';

  final BusinessUserProfile? profile;
  final bool decorationEnabled;

  const RegisterPage({Key? key, this.profile, this.decorationEnabled = false})
    : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  double bottomValue = 0.0;
  bool editMode = true;
  RegisterVM? _vm;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('#### RegisterPage');
    bottomValue = MediaQuery.of(context).viewInsets.bottom;
    debugPrint('### ${bottomValue.toString()}');
    return StoreConnector<AppState, RegisterVM?>(
      converter: (store) {
        _vm = RegisterVM.fromStore(store)..key = formKey;
        return _vm;
      },
      builder: (storeContext, vm) {
        return scaffold(vm, context, storeContext);
      },
    );
  }

  Widget scaffold(
    RegisterVM? vm,
    BuildContext context,
    BuildContext builderContext,
  ) {
    return vm!.isLoading == true
        ? const AppProgressIndicator(hasScaffold: true)
        : AppScaffold(
            title: 'Create Account',
            displayBackNavigation: widget.profile == null ? true : false,
            displayNavDrawer: false,
            enableProfileAction: false,
            displayAppBar: !EnvironmentProvider.instance.isLargeDisplay!,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RegisterForm(
                  vm: vm,
                  profile: widget.profile,
                  decorationEnabled: widget.decorationEnabled,
                ),
              ),
            ),
          );
  }
}
