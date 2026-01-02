// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

// Flutter imports:

// Package imports:
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';

class LocalDatabase {
  late String name;

  Database? database;

  setup() async {
    var dir = await getApplicationDocumentsDirectory();

    await dir.create(recursive: true);

    name = '${dir.path}/lf_merchant.db';
    DatabaseFactory dbFactory = databaseFactoryIo;

    database = await dbFactory.openDatabase(name);
  }

  Future<void> storeData<T>(String key, T value) async {
    if (database == null) await setup();

    var store = StoreRef.main();

    store.record(key).put(database!, value);
  }

  Future<void> pushItem(
    String store,
    Map<String, dynamic> value, {
    bool parseItem = false,
  }) async {
    if (database == null) await setup();

    var datastore = intMapStoreFactory.store(store);

    datastore.add(database!, parseItem ? _parseItem(value) : value);
  }

  Future<bool> removeItem(String store, {Filter? filter}) async {
    if (database == null) await setup();

    var datastore = intMapStoreFactory.store(store);

    var result = await datastore.delete(
      database!,
      finder: Finder(filter: filter),
    );

    return result > 0;
  }

  Future<int> count({required String store, Filter? filter}) async {
    if (database == null) await setup();

    var datastore = intMapStoreFactory.store(store);

    return await datastore.count(database!, filter: filter);
  }

  Future<List<Map<String, dynamic>>> find({
    required String store,
    Filter? filter,
    int batchSize = 50,
    bool parseItems = false,
  }) async {
    if (database == null) await setup();

    var datastore = intMapStoreFactory.store(store);

    var result = await datastore.find(
      database!,
      finder: Finder(filter: filter, limit: batchSize),
    );

    if (result.isNotEmpty) {
      return result
          .map((r) => parseItems ? _unparseItem(r.value) : r.value)
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> findAndUpdate({
    required String store,
    Filter? filter,
    Map<String, dynamic>? item,
    bool parseItems = false,
    bool upsert = true,
  }) async {
    if (database == null) await setup();

    var datastore = intMapStoreFactory.store(store);

    var updatedCount = await datastore.update(
      database!,
      parseItems ? _parseItem(item!) : item!,
      finder: Finder(filter: filter),
    );

    if (updatedCount == 0 && upsert) {
      datastore.add(database!, item);
      return true;
    }

    return updatedCount > 0;
  }

  Future<void> storeDataList(
    List<Map<String, dynamic>> values, {
    required String store,
    bool parseItems = false,
    bool append = false,
  }) async {
    if (database == null) await setup();

    var datastore = intMapStoreFactory.store(store);

    await database!
        .transaction((t) async {
          if (!append) {
            //remove all the existing records there are
            await datastore.delete(t);
          }

          if (parseItems) {
            //save all the new records recieved
            for (final value in values) {
              var replaceKeys = value.entries
                  .where(
                    (e) =>
                        !(e.value is String ||
                            e.value is num ||
                            e.value is bool ||
                            e.value == null),
                  )
                  .map((ee) => ee.key);

              if (replaceKeys.isEmpty) {
                return;
              } else {
                for (var key in replaceKeys) {
                  var currentValue = value[key];

                  if (currentValue is List) {
                    value[key] = currentValue
                        .map((v) => jsonEncode(v))
                        .toList();
                  } else {
                    value[key] = jsonEncode(value[key]);
                  }
                }
              }
            }
          }

          await datastore.addAll(t, values);
        })
        .then((result) {})
        .catchError((error) {
          log(
            'an error occurred saving data list to store:$store',
            error: error,
            stackTrace: StackTrace.current,
          );

          reportCheckedError(error, trace: StackTrace.current);

          throw error;
        });
  }

  Future<List<Map<String, dynamic>>> getDataList({
    required String store,
    bool parseItems = false,
  }) async {
    if (database == null) await setup();

    var datastore = intMapStoreFactory.store(store);

    var result = await datastore.find(database!).catchError((error) {
      log(
        'an error occurred getting data list to store:$store',
        error: error,
        stackTrace: StackTrace.current,
      );

      reportCheckedError(error, trace: StackTrace.current);

      throw error;
    });

    if (result.isNotEmpty) {
      return result
          .map((r) => parseItems ? _unparseItem(r.value) : r.value)
          .toList();
    } else {
      return [];
    }
  }

  Future<void> clearStore({required String store}) async {
    if (database == null) await setup();

    var datastore = intMapStoreFactory.store(store);

    await datastore.delete(database!).catchError((error) {
      log(
        'an error occurred clearing data list from store:$store',
        error: error,
        stackTrace: StackTrace.current,
      );

      reportCheckedError(error, trace: StackTrace.current);
      return -1;
    });
  }

  dynamic getData(String key) async {
    try {
      if (database == null) await setup();
      var store = StoreRef.main();

      var result = await store.record(key).get(database!) ?? '';
      if (result is String) {
        return jsonDecode(result);
      }

      return result;
    } catch (e) {
      log('unable to inquire data with key:$key, from sembas', error: e);
      reportCheckedError(e, trace: StackTrace.current);
      rethrow;
    }
  }

  Future<void> removeData<T>(String key) async {
    if (database == null) await setup();
    var store = StoreRef.main();

    await store.record(key).delete(database!);
  }

  Map<String, dynamic> _parseItem(Map<String, dynamic> item) {
    var replaceKeys = item.entries
        .where(
          (e) =>
              !(e.value is String ||
                  e.value is num ||
                  e.value is bool ||
                  e.value == null),
        )
        .map((ee) => ee.key);

    if (replaceKeys.isEmpty) {
      return item;
    } else {
      for (var key in replaceKeys) {
        var currentValue = item[key];

        if (currentValue is List) {
          item[key] = currentValue.map((v) => jsonEncode(v)).toList();
        }
        // else
        //   item[key] = jsonEncode(item[key]);
      }
    }

    return item;
  }

  Map<String, dynamic> _unparseItem(Map<String, dynamic> item) {
    Map<String, dynamic> newItem = {}..addEntries(item.entries);

    var replaceKeys = newItem.entries
        .where(
          (e) =>
              !(e.value is String ||
                  e.value is num ||
                  e.value is bool ||
                  e.value == null),
        )
        .map((ee) => ee.key);

    if (replaceKeys.isEmpty) {
      return newItem;
    } else {
      for (var key in replaceKeys) {
        var currentValue = newItem[key];

        if (currentValue is List) {
          newItem[key] = currentValue.map((v) => jsonDecode(v)).toList();
        }
      }
    }

    return newItem;
  }
}
