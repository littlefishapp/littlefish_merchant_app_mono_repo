import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/snackbars/snackbar_helper.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/errors/presentation/redux/error_vm.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/ui/initial/go_initial_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_core_utils/error/error_code_manager.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  final String? errorCode;
  final bool showBackToSafetyButton;
  final bool showExitAppButton;
  final bool showTryAgainButton;
  final bool showTestInternetButton;

  const ErrorPage({
    super.key,
    required this.message,
    this.errorCode,
    this.showBackToSafetyButton = true,
    this.showExitAppButton = false,
    this.showTryAgainButton = true,
    this.showTestInternetButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ErrorVM>(
      converter: (Store<AppState> store) {
        return ErrorVM.fromStore(store);
      },
      builder: (BuildContext context, ErrorVM vm) {
        return SafeArea(
          child: AppScaffold(
            title: errorCode != null && errorCode!.isNotEmpty
                ? 'Error - $errorCode'
                : 'Error',
            body: vm.isLoading == true
                ? const AppProgressIndicator()
                : _body(context, message, vm),
            persistentFooterButtons: [_footerButtons(context, message, vm)],
            displayBackNavigation: false,
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, String message, ErrorVM vm) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Icon(
                  Icons.offline_bolt,
                  size: 128.0,
                  color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
                ),
              ),
              context.labelLarge(
                'Oops, this shouldn\'t have happened',
                isSemiBold: true,
              ),
              const SizedBox(height: 16),
              context.paragraphMedium(
                ErrorCodeManager.getUserMessageByErrorCode(
                  errorCode: errorCode ?? 'Code_Unknown',
                  defaultMessage: message,
                ),
              ),
              const SizedBox(height: 8),
              if (errorCode != null)
                context.paragraphXSmall('Error code: $errorCode'),
            ],
          ),
        ),
      );

  Widget _footerButtons(BuildContext context, String message, ErrorVM vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showTryAgainButton) _tryAgain(context),
        if (showTestInternetButton) _testInternet(context, vm),
        _reportIssue(context, vm),
        if (showBackToSafetyButton) _backToSafety(context, vm),
      ],
    );
  }

  Container _tryAgain(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    alignment: Alignment.bottomCenter,
    child: ButtonPrimary(
      buttonColor: Theme.of(context).colorScheme.primary,
      text: 'Try Again',
      onTap: (context) {
        AppVariables.store!.dispatch(UpdateAuthTokenErrorAction(false));
        Navigator.of(context).push(
          CustomRoute(
            builder: (BuildContext context) => const GoInitialPage(),
            settings: const RouteSettings(name: GoInitialPage.route),
          ),
        );
      },
    ),
  );

  Container _testInternet(BuildContext context, ErrorVM vm) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    alignment: Alignment.bottomCenter,
    child: ButtonPrimary(
      buttonColor: Theme.of(context).colorScheme.primary,
      text: 'Test Internet',
      onTap: (context) => vm.testInternet(),
    ),
  );

  Container _reportIssue(BuildContext context, ErrorVM vm) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    alignment: Alignment.bottomCenter,
    child: ButtonPrimary(
      buttonColor: Theme.of(context).colorScheme.primary,
      text: 'Report Issue',
      onTap: (context) async {
        final logger = LittleFishCore.instance.get<LoggerService>();
        bool isReportedSuccessfully = await vm.reportError(message);
        if (context.mounted) {
          if (isReportedSuccessfully) {
            SnackBarHelper.showSuccessSnackbar(
              context,
              'Issue successfully reported',
            );
            return;
          }

          SnackBarHelper.showFailureSnackbar(context, 'Failed to report issue');
        } else {
          logger.debug(
            'error-page',
            'Context unavailable, failed to show snackbar',
          );
        }
      },
    ),
  );

  Widget _backToSafety(BuildContext context, ErrorVM vm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.bottomCenter,
      child: ButtonPrimary(
        buttonColor: Theme.of(context).colorScheme.primary,
        text: 'Back to Safety',
        onTap: (context) => vm.backToSafety(context),
      ),
    );
  }
}
