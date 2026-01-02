// Dart imports:
import 'dart:async';

// Package imports:
// removed ignore: depend_on_referenced_packages

import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/monitoring/services/monitoring_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/store_service_cf.dart';

import '../../features/ecommerce_shared/models/online/system_variant.dart';
import '../../features/ecommerce_shared/models/store/store_attribute.dart';
import '../../features/ecommerce_shared/models/store/store_subtype.dart';
import '../../features/ecommerce_shared/models/store/store_type.dart';

ThunkAction<AppState> getSystemData({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      final MonitoringService monitoringService = LittleFishCore.instance
          .get<MonitoringService>();
      var trace = await monitoringService.createTrace(name: 'cf-get-sys-data');

      try {
        await trace.start();

        var storeService = StoreServiceCF(store: store);

        storeService.getStoreTypes().then((res) {
          store.dispatch(SetSystemStoreTypesAction(res));

          for (var element in res) {
            storeService.getStoreSubtypes(element).then((value) {
              store.dispatch(SetSystemStoreSubtypesAction(value));

              for (var el in value) {
                storeService.getSystemStoreProductTypes(el).then((val) {
                  store.dispatch(SetSystemStoreProductTypesAction(val));
                });

                storeService.getSystemStoreAttributeGroupLinks(el).then((val) {
                  store.dispatch(SetSystemStoreAttributeGroupLinksAction(val));
                });
              }
            });
          }
        });

        storeService.getSystemVariants().then((res) {
          store.dispatch(SetSystemVariantsAction(res));
        });

        storeService.getStoreAttributeGroups().then((res) {
          store.dispatch(SetSystemStoreAttributeGroupsAction(res));
          List<List<StoreAttribute>> groupedAttributes = [];

          for (var element in res) {
            storeService
                .getStoreAttributes(element)
                .then((value) {
                  groupedAttributes.add(value);
                })
                .then((value) {
                  store.dispatch(
                    SetSystemStoreAttributesAction(groupedAttributes),
                  );
                });
          }
        });

        completer?.complete();
      } catch (error) {
        reportCheckedError(error);
        completer?.completeError(error);
      } finally {
        await trace.stop();
      }
    });
  };
}

class SetSystemStoreTypesAction {
  List<StoreType> value;

  SetSystemStoreTypesAction(this.value);
}

class SetSystemStoreSubtypesAction {
  List<StoreSubtype> value;

  SetSystemStoreSubtypesAction(this.value);
}

class SetSystemStoreAttributeGroupsAction {
  List<StoreAttributeGroup> value;

  SetSystemStoreAttributeGroupsAction(this.value);
}

class SetSystemVariantsAction {
  List<SystemVariant> value;

  SetSystemVariantsAction(this.value);
}

class SetSystemStoreAttributesAction {
  List<List<StoreAttribute>> value;

  SetSystemStoreAttributesAction(this.value);
}

class SetSystemStoreProductTypesAction {
  List<StoreProductType> value;

  SetSystemStoreProductTypesAction(this.value);
}

class SetSystemStoreAttributeGroupLinksAction {
  List<StoreAttributeGroupLink> value;

  SetSystemStoreAttributeGroupLinksAction(this.value);
}
