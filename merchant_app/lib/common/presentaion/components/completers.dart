import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/components/dialog_card_skeleton.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/modal_info_icon.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/security/login/landing_page.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';

import 'package:littlefish_core_utils/error/error_code_manager.dart';

import 'icons/error_icon.dart';

//TODO(Michael): Restructure and organise file, review/remove commented code.
Completer? snackBarCompleter(
  BuildContext context,
  String message, {
  bool? shouldPop = false,
  bool? useOnlyCompleterAction = false,
  String? shouldPopTo,
  ScaffoldState? scaffold,
  Function? completerAction,
  bool? usePopup = false,
  int durationMilliseconds = 3000,
  bool goToDefaultRoute = false,
  String defaultRoute = LandingPage.route,
}) {
  // the completer itself is irrelevant, but completely removing it will take a lot of time
  Completer completer = Completer();

  // completer.future.then((value) {});
  completer.future.then(
    (_) {
      if (usePopup == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                duration: Duration(milliseconds: durationMilliseconds),
                content: Row(
                  children: [
                    Icon(
                      LittleFishIcons.info,
                      color: Theme.of(
                        context,
                      ).extension<AppliedTextIcon>()?.positive,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: context.paragraphLarge(
                        message,
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.positive,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Theme.of(
                  context,
                ).extension<AppliedSurface>()?.successEmphasized,
              ),
            )
            .closed;
      }

      if (usePopup == true) {
        showMessageDialog(context, message, LittleFishIcons.info);
      }

      if (shouldPop == true) {
        if (shouldPopTo == null || shouldPopTo.isEmpty) {
          if (completerAction != null) completerAction();
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            shouldPopTo,
            ModalRoute.withName(shouldPopTo),
          );
        }
      }

      if (useOnlyCompleterAction == true) {
        if (completerAction != null) completerAction();
      }
    },
    onError: (error) async {
      if (error is AuthorizationException) {
        await showMessageDialog(
          context,
          ErrorCodeManager.getUserMessageByException(exception: error),
          LittleFishIcons.info,
        );
      } else if (error is ManagedException) {
        if (usePopup == true) {
          await showMessageDialog(
            globalNavigatorKey.currentContext!,
            ErrorCodeManager.getUserMessageByException(exception: error),
            MdiIcons.exclamation,
          );
        } else {
          ScaffoldMessenger.of(globalNavigatorKey.currentContext!)
              .showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Row(
                    children: [
                      const ErrorIcon(),
                      const SizedBox(width: 8),
                      Flexible(
                        child: context.paragraphLarge(
                          ErrorCodeManager.getUserMessageByException(
                            exception: error,
                          ),
                          color: Theme.of(
                            context,
                          ).extension<AppliedTextIcon>()?.error,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).extension<AppliedSurface>()?.error,
                ),
              )
              .closed;
        }
      } else {
        await showErrorDialog(context, error);
      }
      if (goToDefaultRoute == true) {
        Navigator.of(context).pushNamed(defaultRoute);
      }
    },
  );

  return completer;
}

Completer<Null> navigateCompleter(
  BuildContext ctx,
  String onCompletedRoute, {
  String? onFailedRoute,
}) {
  final Completer<Null> completer = Completer<Null>();

  completer.future.then(
    (_) {
      Navigator.pushNamedAndRemoveUntil(
        globalNavigatorKey.currentContext!,
        onCompletedRoute,
        ModalRoute.withName(onCompletedRoute),
      );
    },
    onError: (error) {
      showErrorDialog(ctx, error).then((_) {
        if (onFailedRoute != null) {
          Navigator.pushNamedAndRemoveUntil(
            globalNavigatorKey.currentContext!,
            onFailedRoute,
            ModalRoute.withName(onFailedRoute),
          );
        }
      });
    },
  );

  return completer;
}

Completer actionCompleter(
  BuildContext? ctx,
  Function onCompletedAction, {
  Function? onError,
}) {
  final Completer<Null> completer = Completer<Null>();

  completer.future.then(
    (_) {
      onCompletedAction();
    },
    onError: (error) {
      if (error is AuthorizationException) {
        showMessageDialog(
          ctx!,
          ErrorCodeManager.getUserMessageByException(exception: error),
          MdiIcons.lock,
        );
      } else if (error is ManagedException) {
        showMessageDialog(
          ctx!,
          ErrorCodeManager.getUserMessageByException(exception: error),
          MdiIcons.exclamation,
        ).then((_) {
          if (onError != null) onError();
        });
      } else {
        showErrorDialog(ctx, error).then((_) {
          if (onError != null) onError();
        });
      }
    },
  );

  return completer;
}

class SnackBarRow extends StatelessWidget {
  const SnackBarRow({Key? key, this.message, this.icon = Icons.check_circle})
    : super(key: key);

  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext ctx) {
    return Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(message!),
        ),
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(this.error, {Key? key}) : super(key: key);
  final Object error;

  @override
  Widget build(BuildContext context) {
    return DialogCardSkeleton(
      enableCloseButton: true,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ModalInfoIcon(
          status: StatusType.destructive,
          isBoxIcon: true,
          iconData: LittleFishIcons.error,
        ),
      ),
      title: '',
      description: error.toString().replaceAll('Exception:', '').trim(),
      footerWidgets: [
        ButtonPrimary(
          text: 'Ok',
          isNegative: true,
          onTap: (context) {
            Navigator.of(globalNavigatorKey.currentContext ?? context).pop();
          },
        ),
      ],
    );
  }
}

class LocalElevatedButton extends StatelessWidget {
  const LocalElevatedButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.width,
  }) : super(key: key);

  final Color? color;
  final IconData? icon;
  final String label;
  final Function onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final textUsed = TextFormatter.formatStringFromFontCasing(label);
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: icon != null
            ? IconText(icon: icon, text: textUsed)
            : Text(textUsed),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  const IconText({Key? key, this.text, this.icon, this.style})
    : super(key: key);
  final String? text;
  final IconData? icon;
  // TODO(lampian): remove style parameter and replace with theme
  final TextStyle? style;

  @override
  Widget build(BuildContext ctx) {
    return Row(
      children: <Widget>[
        Icon(icon),
        const SizedBox(width: 8),
        Text(text!, style: style),
      ],
    );
  }
}
