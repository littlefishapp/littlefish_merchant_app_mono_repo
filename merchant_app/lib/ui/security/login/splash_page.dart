import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/lf_app_themes.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/loading.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/splash/viewmodels/splash_page_viewmodel.dart';

class SplashPage extends StatefulWidget {
  static const route = '/splash';

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lfCustomTheme(context: context, language: 'en'),
      child: Scaffold(
        body: StoreConnector<AppState, SplashPageViewModel>(
          rebuildOnChange: true,
          onInitialBuild: (model) {
            model.populate(context: context);
          },
          builder: (BuildContext context, vm) {
            return loadingWithMessage('Loading...');
          },
          converter: (Store<AppState> store) {
            return SplashPageViewModel.fromStore(store);
          },
        ),
      ),
    );
  }
}
