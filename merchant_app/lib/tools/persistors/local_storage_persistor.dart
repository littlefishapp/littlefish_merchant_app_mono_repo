// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';

// Core imports:
import 'package:littlefish_core/core/littlefish_core.dart';

// Project imports:
import 'package:littlefish_merchant/models/cache/cache_item.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';

// import 'package:usb_serial/usb_serial.dart';

// import 'package:synchronized/synchronized.dart';

/// Persistor class that saves/loads to/from disk.
class LocalStoragePersistor {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  /// Debug mode (prints debug information).
  bool debug;

  /// Duration for which to throttle saving. Disable by setting to null.
  /// It is recommended to set a duration of a few (2-5) seconds to reduce
  /// storage calls, while preventing data loss.
  /// A duration of zero (default) will try to save on next available cycle
  Duration throttleDuration;

  bool hasLoaded = false;

  // /// Synchronization lock for saving
  // final _saveLock = Lock();

  /// Function that if not null, returns if an action should trigger a save.
  final bool Function(Store<AppState> store, dynamic action)? shouldSave;

  LocalStoragePersistor({
    this.debug = false,
    this.throttleDuration = Duration.zero,
    this.shouldSave,
  });

  /// Middleware used for Redux which saves on each action.
  Middleware<AppState> createMiddleware() {
    Timer? saveTimer;

    return (Store<AppState> store, dynamic action, NextDispatcher next) {
      next(action);

      if (shouldSave != null && shouldSave!(store, action) != true) {
        return;
      }

      // Save / clear
      try {
        if (action is SignoutAction) {
          clear(store);
        } else // Only create a new timer if the last one hasn't been run.
        if (saveTimer?.isActive != true) {
          saveTimer = Timer(throttleDuration, () => save(store, store.state));
        }
      } catch (_) {}
    };
  }

  /// Load state from storage
  Future load(Store<AppState> store) async {
    try {
      var prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey('products')) {
        store.dispatch(
          ProductsLoadedAction(
            CachedProducts.fromJson(
              loadFromCache(prefs, 'products') as Map<String, dynamic>,
            ).items,
          ),
        );
      }

      if (prefs.containsKey('combos')) {
        store.dispatch(
          CombosLoadedAction(
            CachedCombos.fromJson(
              loadFromCache(prefs, 'combos') as Map<String, dynamic>,
            ).items,
          ),
        );
      }

      if (prefs.containsKey('modifiers')) {
        store.dispatch(
          ModifiersLoadedAction(
            CachedModifiers.fromJson(
              loadFromCache(prefs, 'modifiers') as Map<String, dynamic>,
            ).items,
          ),
        );
      }

      if (prefs.containsKey('customers')) {
        store.dispatch(
          CustomersLoadedAction(
            CachedCustomers.fromJson(
              loadFromCache(prefs, 'customers') as Map<String, dynamic>,
            ).items,
          ),
        );
      }

      if (prefs.containsKey('sales')) {}

      if (prefs.containsKey('employees')) {
        store.dispatch(
          EmployeesLoadedAction(
            CachedEmployees.fromJson(
              loadFromCache(prefs, 'employees') as Map<String, dynamic>,
            ).items,
          ),
        );
      }
    } catch (error) {
      if (debug) {
        logger.debug(
          'tools.persistors.local_storage_persistor',
          'Error while loading: ${error.toString()}',
        );
      }
      rethrow;
    } finally {
      hasLoaded = true;
    }
  }

  Future clear(Store store) async {
    try {
      var prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey('products')) {
        prefs.remove('products');
      }

      if (prefs.containsKey('combos')) {
        prefs.remove('combos');
      }

      if (prefs.containsKey('modifiers')) {
        prefs.remove('modifiers');
      }

      if (prefs.containsKey('customers')) {
        prefs.remove('customers');
      }

      if (prefs.containsKey('sales')) {
        prefs.remove('sales');
      }

      if (prefs.containsKey('employees')) {
        prefs.remove('employees');
      }
    } catch (error) {
      if (debug) {
        logger.debug(
          'tools.persistors.local_storage_persistor',
          'Error while loading: ${error.toString()}',
        );
      }
      rethrow;
    } finally {
      hasLoaded = true;
    }
  }

  /// Save state to storage.
  Future<void> save(Store store, AppState state) async {
    if (state.businessId == null || state.businessId!.isEmpty) return;

    if (!hasLoaded) return;

    try {
      var prefs = await SharedPreferences.getInstance();

      prefs.setString(
        'products',
        jsonEncode(
          (CachedProducts()
                ..items = state.productState.products
                ..businessId = state.businessId)
              .toJson(),
        ),
      );

      prefs.setString(
        'combos',
        jsonEncode(
          (CachedCombos()
                ..items = state.productState.productCombos
                ..businessId = state.businessId)
              .toJson(),
        ),
      );

      prefs.setString(
        'modifiers',
        jsonEncode(
          (CachedModifiers()
                ..items = state.productState.modifiers
                ..businessId = state.businessId)
              .toJson(),
        ),
      );

      prefs.setString(
        'customers',
        jsonEncode(
          (CachedCustomers()
                ..items = state.customerstate.customers
                ..businessId = state.businessId)
              .toJson(),
        ),
      );

      prefs.setString(
        'employees',
        jsonEncode(
          (CachedEmployees()
                ..items = state.businessState.employees
                ..businessId = state.businessId)
              .toJson(),
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  Map? loadFromCache(SharedPreferences prefs, String key) {
    var value = prefs.getString(key);

    if (value == null) return null;

    return jsonDecode(value);
  }

  // Removed _printDebug method in favor of direct logger.debug calls
}
