import 'package:littlefish_core/analytics/models/analytics_event.dart';
import 'package:littlefish_core/analytics/services/analytics_service.dart';
import 'package:littlefish_core/auth/models/authentication_result.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/observability/observability_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';

class AnalyticsMiddleware extends MiddlewareClass<AppState> {
  final LittleFishCore core = LittleFishCore.instance;

  late AnalyticsService analyticsService;
  late ObservabilityService observabilityService;

  late LoggerService logger;
  late ConfigService configService;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    //trigger the next action in the chain as expected
    next(action);

    configService = core.get<ConfigService>();
    observabilityService = core.get<ObservabilityService>();

    try {
      analyticsService = core.get<AnalyticsService>();
      logger = LittleFishCore.instance.get<LoggerService>();

      if (!analyticsService.isAnalyticsEnabled) {
        logger.debug(this, 'AnalyticsMiddleware: Analytics is disabled');
        return;
      }

      if (action is LogonFirebaseSuccessAction) {
        await logFirebaseSuccessAction(analyticsService, action);
      } else if (action is UserProfileLoadedAction) {
        await logUserProfileLoadedAction(analyticsService, action.value);
      } else if (action is BusinessProfileLoadedAction) {
        await logBusinessProfileLoaded(analyticsService, action.value);
      } else if (action is LogonSuccessAction) {
        await logLogonSuccessAction(analyticsService, action.result);
      } else if (action is LogonFailureAction) {
        await logLogonFailureAction(analyticsService, action);
      } else if (action is RegisterSuccessAction) {
        await logRegisterSuccessAction(analyticsService, action.result);
      } else if (action is SignoutAction) {
        await logSignoutAction(analyticsService, action);
      }
    } catch (e) {
      logger.error(
        this,
        'AnalyticsMiddleware error: $e',
        stackTrace: StackTrace.current,
      );

      reportCheckedError(e, trace: StackTrace.current);
    }
  }

  Future<void> logFirebaseSuccessAction(
    AnalyticsService analyticsService,
    LogonFirebaseSuccessAction action,
  ) async {
    await analyticsService.logEvent(
      e: AnalyticsEvent(
        'authSuccess',
        parameters: {
          'signInProvider': action.signInProvider ?? 'unknown',
          'userId': action.user?.uid ?? 'unknown',
          'userName': action.user?.firstName ?? 'unknown',
          'email': action.user?.email ?? 'unknown',
          'userVerified': action.user?.emailVerified.toString() ?? 'unknown',
          'source': action.source,
        },
      ),
    );

    analyticsService.setUserId(userId: action.user?.uid ?? 'unknown');

    observabilityService.setUserId(action.user?.uid ?? 'unknown');
    observabilityService.setCustomKey(
      'userName',
      action.user?.displayName ?? 'unknown',
    );

    await analyticsService.setDefaultEventParameters(
      parameters: {
        'userId': action.user?.uid ?? 'unknown',
        'userName': action.user?.displayName ?? 'unknown',
      },
    );
  }

  Future<void> logUserProfileLoadedAction(
    AnalyticsService analyticsService,
    UserProfile? value,
  ) async {
    await analyticsService.logEvent(e: AnalyticsEvent('userProfileLoaded'));

    await analyticsService.setUserProperty(
      name: 'userName',
      value: value?.name ?? 'unknown',
    );

    await analyticsService.setUserProperty(
      name: 'Gender',
      value: value?.gender?.name ?? 'unknown',
    );

    await analyticsService.setUserProperty(
      name: 'countryCode',
      value: value?.countryCode ?? 'unknown',
    );

    observabilityService.setCustomKey(
      'countryCode',
      value?.countryCode ?? 'unknown',
    );
  }

  Future<void> logBusinessProfileLoaded(
    AnalyticsService analyticsService,
    BusinessProfile? value,
  ) async {
    await analyticsService.logEvent(e: AnalyticsEvent('businessProfileLoaded'));

    await analyticsService.setUserProperty(
      name: 'businessName',
      value: value?.name ?? 'unknown',
    );

    await analyticsService.setUserProperty(
      name: 'businessId',
      value: value?.parentId ?? 'unknown',
    );

    await analyticsService.setUserProperty(
      name: 'merchantId',
      value: value?.masterMerchantId ?? 'unknown',
    );

    await analyticsService.setUserProperty(
      name: 'businessProfileId',
      value: value?.id ?? 'unknown',
    );

    await analyticsService.setUserProperty(
      name: 'businessType',
      value: value?.type?.name ?? 'unknown',
    );

    await analyticsService.setUserProperty(
      name: 'businessCategory',
      value: value?.category?.name ?? 'unknown',
    );

    await analyticsService.setUserProperty(
      name: 'businessMCCCode',
      value: value?.mcc?.toString() ?? 'unknown',
    );

    await analyticsService.setUserProperty(
      name: 'country',
      value: value?.countryCode ?? 'unknown',
    );

    observabilityService.setCustomKey('businessName', value?.name ?? 'unknown');

    observabilityService.setCustomKey(
      'businessType',
      value?.type?.name ?? 'unknown',
    );

    observabilityService.setCustomKey(
      'businessId',
      value?.parentId ?? 'unknown',
    );

    observabilityService.setCustomKey(
      'merchantId',
      value?.masterMerchantId ?? 'unknown',
    );
  }

  Future<void> logLogonSuccessAction(
    AnalyticsService analyticsService,
    AuthenticationResult value,
  ) async {
    await analyticsService.logEvent(
      e: AnalyticsEvent(
        'logonSuccess',
        parameters: {
          'businessCount': value.businesses?.length ?? 0,
          'authenticated': value.authenticated ?? false,
        },
      ),
    );
  }

  Future<void> logLogonFailureAction(
    AnalyticsService analyticsService,
    LogonFailureAction action,
  ) async {
    await analyticsService.logEvent(
      e: AnalyticsEvent(
        'logonFailure',
        parameters: {'signInProvider': action.message},
      ),
    );
  }

  Future<void> logRegisterSuccessAction(
    AnalyticsService analyticsService,
    AuthenticationResult value,
  ) async {
    await analyticsService.logEvent(
      e: AnalyticsEvent(
        'registrationSuccess',
        parameters: {
          'businessCount': value.businesses?.length ?? 0,
          'authenticated': value.authenticated ?? false,
        },
      ),
    );
  }

  Future<void> logSimpleEvent(AnalyticsService analyticsService, action) async {
    analyticsService.logEvent(e: AnalyticsEvent(action.toString()));
  }

  Future<void> logSignoutAction(
    AnalyticsService analyticsService,
    SignoutAction action,
  ) async {
    analyticsService.logEvent(
      e: AnalyticsEvent('signout', parameters: {'reason': action.cause}),
    );
  }
}
