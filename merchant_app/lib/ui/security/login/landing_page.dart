import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/lf_app_themes.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/landing.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';

class LandingPage extends StatefulWidget {
  static const route = '/landing';

  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    debugPrint('#### Landing page');
    saveKeyToPrefsBool('isGuestLogin', false);
    return Theme(
      data: lfCustomTheme(context: context, language: 'en'),
      child: StoreConnector<AppState, LoginVM>(
        converter: (store) {
          var vm = LoginVM.fromStore(store);
          vm.key = GlobalKey<FormState>();
          return vm;
        },
        onDidChange: (previousViewModel, viewModel) async {
          if (viewModel.hasError == true &&
              viewModel.hasError != previousViewModel?.hasError &&
              viewModel.errorMessage != null) {
            await showMessageDialog(
              context,
              viewModel.errorMessage!,
              LittleFishIcons.error,
            ).then((_) async {
              if (viewModel.onResetErorr != null) {
                await viewModel.onResetErorr!();
              }
            });
          }
        },
        builder: (BuildContext context, LoginVM vm) {
          return landing(vm.isLoading!, vm);
        },
      ),
    );
  }
}
