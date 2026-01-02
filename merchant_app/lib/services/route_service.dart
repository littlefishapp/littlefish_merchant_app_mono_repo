import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/password_form_field.dart';
import '../app/app.dart';
import '../common/presentaion/components/dialogs/services/modal_service.dart';
import '../injector.dart';
import '../models/enums.dart';

class RouteService {
  static final RouteService instance = RouteService._internal();

  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  RouteService._internal();

  factory RouteService() => instance;
}

abstract class RouteAwareWidget<T extends StatefulWidget> extends State<T>
    implements RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context) is PageRoute) {
      RouteService.instance.routeObserver.subscribe(
        this,
        ModalRoute.of(context) as PageRoute,
      );
    }
  }

  @override
  void dispose() {
    RouteService.instance.routeObserver.unsubscribe(this);
    super.dispose();
  }

  bool hasPreviousRoute(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  Widget wrapWithPopScope(BuildContext context, Widget child) {
    return PopScope(
      canPop: hasPreviousRoute(context),
      onPopInvoked: (didPop) {
        if (!didPop && !hasPreviousRoute(context)) {
          setState(() {});
          _showExitConfirmationDialog(context);
        }
      },
      child: child,
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    if (!mounted || hasPreviousRoute(context)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final modalService = getIt<ModalService>();

      RouteServiceDialog().showExitDialog(context, modalService);
    });
  }

  @override
  void didPush() {
    debugPrint('${widget.runtimeType}: didPush');
  }

  @override
  void didPop() {
    debugPrint('${widget.runtimeType}: didPop');
  }

  @override
  void didPopNext() {
    debugPrint('${widget.runtimeType}: didPopNext');
  }

  @override
  void didPushNext() {
    debugPrint('${widget.runtimeType}: didPushNext');
  }
}

class RouteServiceDialog {
  Future<void> showExitDialog(
    BuildContext context,
    ModalService modalService,
  ) async {
    bool? isPasswordEnabled = AppVariables
        .store
        ?.state
        .environmentState
        .environmentConfig
        ?.exitPasswordEnabled;
    TextEditingController passwordController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await modalService.showActionModal(
      context: context,
      title: 'Exit the app?',
      description: 'Are you sure you want to exit the app?',
      customWidget:
          ((AppVariables.isPOSBuild && kDebugMode) ||
              (isPasswordEnabled == true))
          ? Form(
              key: formKey,
              child: PasswordFormField(
                hintText: 'Please enter the exit password',
                labelText: 'Password',
                key: const Key('exit_password'),
                controller: passwordController,
                useOutlineStyling: true,
                onFieldSubmitted: (value) {
                  passwordController.text = value;
                },
                inputAction: TextInputAction.next,
                isRequired: true,
                onSaveValue: (value) {
                  passwordController.text = value!;
                },
                policies: PasswordPolicies()..policies = [],
              ),
            )
          : const SizedBox(),
      acceptText: 'Yes',
      cancelText: 'No',
      status: StatusType.destructive,
      onTap: (context) {
        if (isPasswordEnabled == true) {
          if (formKey.currentState!.validate()) {
            if (passwordController.text ==
                DateFormat('yyyyddMM').format(DateTime.now())) {
              passwordController.text = '';
              Future.delayed(const Duration(milliseconds: 500), () {
                SystemNavigator.pop();
                exit(0);
              });
            }
          }
        } else {
          passwordController.text = '';
          Future.delayed(const Duration(milliseconds: 500), () {
            SystemNavigator.pop();
            exit(0);
          });
        }
      },
    );
  }
}
