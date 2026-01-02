import 'dart:async';
import 'package:littlefish_merchant/models/device/device_email_request.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/email_service.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

late EmailService emailService;

ThunkAction<AppState> sendDeviceLimitEmail({
  required DeviceEmailRequest request,
  String? email,
  Completer<bool>? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      DeviceEmailRequest data = DeviceEmailRequest.copy(request);

      if (isBlank(email)) {
        email = store.state.businessState.profile?.businessEmail ?? '';
      }
      if (isBlank(request.merchantId)) {
        data.copyWith(
          merchantId: store.state.businessState.profile?.businessEmail ?? '',
        );
      }
      if (isBlank(request.businessName)) {
        data.copyWith(
          businessName: store.state.businessState.profile?.name ?? '',
        );
      }

      try {
        final result = await emailService.sendDeviceLimitEmail(
          email: email ?? '',
          request: data,
        );

        completer?.complete(result.success);
      } catch (e) {
        completer?.complete(false);
      }
    });
  };
}

ThunkAction<AppState> sendDeviceRegisteredEmail({
  required DeviceEmailRequest request,
  String? email,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      DeviceEmailRequest data = DeviceEmailRequest.copy(request);

      if (isBlank(email)) {
        email = store.state.businessState.profile?.businessEmail ?? '';
      }
      if (isBlank(request.merchantId)) {
        data.copyWith(
          merchantId: store.state.businessState.profile?.businessEmail ?? '',
        );
      }
      if (isBlank(request.businessName)) {
        data.copyWith(
          businessName: store.state.businessState.profile?.name ?? '',
        );
      }
      try {
        final result = await emailService.sendRegisterDeviceEmail(
          email: email ?? '',
          request: data,
        );

        completer?.complete(result.success);
      } catch (e) {
        completer?.complete(false);
      }
    });
  };
}

ThunkAction<AppState> sendDeviceDeRegisteredEmail({
  required DeviceEmailRequest request,
  String? email,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      DeviceEmailRequest data = DeviceEmailRequest.copy(request);

      if (isBlank(email)) {
        email = store.state.businessState.profile?.businessEmail ?? '';
      }
      if (isBlank(request.merchantId)) {
        data.copyWith(
          merchantId: store.state.businessState.profile?.businessEmail ?? '',
        );
      }
      if (isBlank(request.businessName)) {
        data.copyWith(
          businessName: store.state.businessState.profile?.name ?? '',
        );
      }

      try {
        final result = await emailService.sendDeRegisterDeviceEmail(
          email: email ?? '',
          request: data,
        );

        completer?.complete(result.success);
      } catch (e) {
        completer?.complete(false);
      }
    });
  };
}

_initializeService(Store<AppState> store) {
  emailService = EmailService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
  );
}
