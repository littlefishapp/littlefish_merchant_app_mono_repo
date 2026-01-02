import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/device/device_email_request.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/email/email_actions.dart';
import 'package:littlefish_payments/models/shared/purchase_helper.dart';

class PaymentActionHelper {
  static Future<void> doPaymentAction({
    required Completer<bool> completer,
    required ActionData data,
  }) async {
    switch (data.action) {
      case PaymentAction.registerDeviceRequest:
        int totalDevices = data.data['totalDevices'] ?? 0;
        int maxDevices = data.data['maxDevices'] ?? 0;
        await _registerDeviceRequest(
          completer: completer,
          totalDevices: totalDevices,
          maxDevices: maxDevices,
        );
        break;

      case PaymentAction.deviceLimitReached:
        DeviceEmailRequest request = DeviceEmailRequest(
          deviceId: data.data['deviceId'] ?? '',
          deviceName: data.data['deviceName'] ?? '',
          deviceLimit: data.data['maxDevices'].toString(),
          totalDevices: data.data['totalDevices'].toString(),
          merchantId: '',
          businessName: '',
          deviceBrand: data.data['deviceBrand'] ?? '',
        );

        AppVariables.store!.dispatch(
          sendDeviceLimitEmail(request: request, completer: completer),
        );
        break;
      case PaymentAction.deviceRegistered:
        DeviceEmailRequest request = DeviceEmailRequest(
          deviceId: data.data['deviceId'] ?? '',
          deviceName: data.data['deviceName'] ?? '',
          deviceLimit: data.data['maxDevices'].toString(),
          totalDevices: data.data['totalDevices'].toString(),
          merchantId: '',
          businessName: '',
          deviceBrand: data.data['deviceBrand'] ?? '',
        );

        AppVariables.store!.dispatch(
          sendDeviceRegisteredEmail(request: request, completer: completer),
        );
        break;

      case PaymentAction.deviceUnregistered:
        DeviceEmailRequest request = DeviceEmailRequest(
          deviceId: data.data['deviceId'] ?? '',
          deviceName: data.data['deviceName'] ?? '',
          deviceLimit: data.data['maxDevices'].toString(),
          totalDevices: data.data['totalDevices'].toString(),
          merchantId: '',
          businessName: '',
          deviceBrand: data.data['deviceBrand'] ?? '',
        );

        AppVariables.store!.dispatch(
          sendDeviceDeRegisteredEmail(request: request, completer: completer),
        );
        break;
      default:
        completer.complete(true);
        break;
    }
    return;
  }

  static Future<void> _registerDeviceRequest({
    required Completer<bool> completer,
    required int totalDevices,
    required int maxDevices,
  }) async {
    final modalService = getIt<ModalService>();

    BuildContext context = globalNavigatorKey.currentContext!;
    bool? isAccepted = await modalService.showActionModal(
      status: StatusType.destructive,
      title: 'Register Device',
      context: context,
      description:
          'Would you like to register this device? \n\n'
          'You have $totalDevices devices registered. '
          'You can register up to $maxDevices devices.',
      acceptText: 'Register',
      cancelText: 'Cancel',
    );
    completer.complete(isAccepted);
    return;
  }
}
