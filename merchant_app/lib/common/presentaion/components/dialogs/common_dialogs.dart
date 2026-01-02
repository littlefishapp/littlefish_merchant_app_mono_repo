import 'package:flutter/material.dart';
import 'package:littlefish_core_utils/error/error_code_manager.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_neutral.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/components/dialog_card_skeleton.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/modal_info_icon.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import '../app_progress_indicator.dart';
import '../icons/warning_icon.dart';

Future<T?> showPopupDialog<T>({
  required BuildContext context,
  required Widget content,
  double width = 438,
  double? height,
  bool borderDismissable = true,
  bool defaultPadding = true,
  String title = '',
  bool useNewModal = false,
}) {
  if (useNewModal) {
    var modal = DialogCardSkeleton(
      enableCloseButton: true,
      title: title,
      description: '',
      leading: content,
      footerWidgets: [
        ButtonSecondary(
          text: 'Ok',
          onTap: (ctx) {
            Navigator.of(globalNavigatorKey.currentContext ?? ctx).pop();
          },
        ),
      ],
    );

    return showDialog<T>(
      context: context,
      barrierDismissible: borderDismissable,
      builder: (context) {
        return modal;
      },
    );
  }

  final availableWidth =
      EnvironmentProvider.instance.screenWidth ??
      MediaQuery.of(context).size.width;
  final widthUsed = EnvironmentProvider.instance.isLargeDisplay!
      ? availableWidth * 0.9
      : availableWidth;
  final heightUsed =
      height ??
      (EnvironmentProvider.instance.screenHeight ??
              MediaQuery.of(context).size.height) *
          0.9;
  return showDialog<T>(
    context: context,
    barrierDismissible: borderDismissable,
    builder: (context) => Center(
      child: Material(
        elevation: 5.0,
        child: Container(
          width: widthUsed,
          height: heightUsed,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
          ),
          child: content,
        ),
      ),
    ),
  );
}

showComingSoon({required BuildContext context, String? description}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 36),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.05,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.new_releases,
                    size: MediaQuery.of(context).size.height * 0.05,
                    color: UIStateData.iconsColor,
                  ),
                ),
                const SizedBox(height: 16.0),
                context.headingSmall('Coming Soon!', isSemiBold: true),
                const SizedBox(height: 8.0),
                Text(
                  'Thanks for clicking here, now we know you want this!',
                  style: context.styleParagraphMediumRegular!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                ButtonPrimary(
                  onTap: (c) {
                    Navigator.of(context).pop();
                  },
                  text: 'DISMISS',
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<dynamic> showErrorDialog(context, error) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ErrorDialog(ErrorCodeManager.getUserMessage(error)),
    barrierDismissible: true,
  );
}

Future<dynamic> showMessageDialog(
  BuildContext context,
  String? message,
  IconData icon, {
  Color? iconColor,
  String? confirmText,
  StatusType? status,
}) async {
  StatusType statusType = status ?? StatusType.defaultStatus;

  var modal = DialogCardSkeleton(
    enableCloseButton: true,
    leading: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ModalInfoIcon(status: statusType, isBoxIcon: true, iconData: icon),
    ),
    title: '',
    description: message ?? '',
    footerWidgets: [
      ButtonPrimary(
        text: confirmText ?? 'Ok',
        isNegative: statusType == StatusType.destructive,
        isNeutral: statusType == StatusType.neutral,
        onTap: (ctx) {
          Navigator.of(globalNavigatorKey.currentContext ?? ctx).pop();
        },
      ),
    ],
  );

  return await showDialog<bool>(
    context: context,
    builder: (context) => modal,
    barrierDismissible: true,
  );
}

Future showSuccess(BuildContext context, String message, IconData icon) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Center(
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.05,
                backgroundColor: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.brand,
                child: Icon(
                  icon,
                  size: MediaQuery.of(context).size.height * 0.05,
                  color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
                ),
              ),
              const SizedBox(height: 16.0),
              context.labelSmall(
                message,
                color: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.secondary,
              ),
              const SizedBox(height: 16.0),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: ButtonSecondary(
                  onTap: (c) {
                    Navigator.of(context).pop();
                  },
                  text: 'Ok',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

showProgress({required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: AppProgressIndicator()),
  );
}

hideProgress(BuildContext context) {
  Navigator.pop(context);
}

Future<bool?> confirmDismissal(
  BuildContext context,
  dynamic item, {
  String? message,
}) async {
  final modalService = getIt<ModalService>();

  return await modalService.showActionModal(
    context: context,
    status: StatusType.destructive,
    description: message ?? 'Are you sure you want to remove this item?',
  );
}

class PermissionDialog extends StatelessWidget {
  final Permission? _permission;

  const PermissionDialog({Key? key, Permission? permission})
    : _permission = permission,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: const Text('Permission Required'),
      content: Text(
        "To enable permission for ${_permission.toString().split('.').last}, you need to go to settings and enable it manually.",
      ),
      actions: <Widget>[
        ButtonText(
          onTap: (_) {
            Navigator.of(context).pop();
          },
          text: 'Cancel',
        ),
        ButtonText(
          onTap: (_) {
            openAppSettings();
            Navigator.of(context).pop();
          },
          text: 'Open Settings',
        ),
      ],
    );
  }
}

Future showPermissionDialog(BuildContext context, Permission permission) =>
    showDialog(
      context: context,
      builder: (context) => PermissionDialog(permission: permission),
    );

Future<bool?> showCustomMessageDialog({
  required BuildContext context,
  required Widget content,
  required String title,
  required String buttonText,
  bool borderDismissable = false,
}) async {
  var result = await showDialog<bool>(
    context: context,
    barrierDismissible: borderDismissable,
    builder: (context) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CardNeutral(
              child: Container(
                width: 320,
                margin: const EdgeInsets.all(16.0),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      height: 150,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              color: Theme.of(
                                context,
                              ).extension<AppliedSurface>()?.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const WarningIcon(),
                          ),
                          const SizedBox(height: 24),
                          DecoratedText(
                            title,
                            alignment: Alignment.center,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: content,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: <Widget>[
                        ButtonPrimary(
                          expand: true,
                          text: buttonText,
                          onTap: (context) {
                            Navigator.pop(context, true);
                          },
                          elevation: 0,
                          upperCase: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  return result;
}

void showCustomAboutDialog({
  required BuildContext context,
  required String applicationName,
  required String applicationVersion,
  required Widget applicationIcon,
  required String viewCustom,
  required VoidCallback onTapViewCustom,
  String cohort = '',
  String applicationBuild = '',
  bool enableViewCustom = false,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: applicationIcon),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        context.headingSmall(
                          applicationName,
                          color: Theme.of(
                            context,
                          ).extension<AppliedTextIcon>()?.secondary,
                          isBold: true,
                        ),
                        context.labelSmall(
                          applicationVersion,
                          color: Theme.of(
                            context,
                          ).extension<AppliedTextIcon>()?.secondary,
                        ),
                        if (applicationBuild.isNotEmpty)
                          context.labelSmall(
                            applicationBuild,
                            color: Theme.of(
                              context,
                            ).extension<AppliedTextIcon>()?.secondary,
                          ),
                        if (cohort.isNotEmpty)
                          context.labelXSmall(
                            cohort,
                            color: Theme.of(
                              context,
                            ).extension<AppliedTextIcon>()?.secondary,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          if (viewCustom.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ButtonText(
                onTap: (_) {
                  onTapViewCustom();
                },
                text: viewCustom,
                isNeutral: false,
                disabled: !enableViewCustom,
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ButtonText(
              onTap: (_) {
                Navigator.of(context).pop();
              },
              text: 'Close',
            ),
          ),
        ],
      );
    },
  );
}

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required Widget content,
  bool borderDismissable = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: borderDismissable,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      surfaceTintColor: Colors.transparent,
      child: content,
    ),
  );
}
