import 'package:flutter/material.dart';

import 'package:littlefish_merchant/app/app.dart';
// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:redux/src/store.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_service.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/notification_service_cf.dart';
import 'package:littlefish_merchant/ui/online_store/services/service_factory.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import '../../../features/ecommerce_shared/models/store/notification.dart';
import '../../../features/ecommerce_shared/models/store/store.dart' as e_store;
import '../../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../../features/ecommerce_shared/models/store/store_user.dart';
import '../../../redux/app/app_state.dart';
import '../../../redux/store/store_actions.dart';
import '../../../redux/store/store_state.dart';

class ManageCustomerVM extends StoreItemViewModel<e_store.Store, StoreState> {
  ManageCustomerVM.fromStore(Store<AppState> store) : super.fromStore(store);

  bool get hasStore => item != null;

  Map<String, dynamic>? get storeInfo => item?.toJson();

  ServiceFactory? serviceFactory;

  bool isFetching = false;

  StoreCustomer? firstCustomer;

  StoreCustomer? lastCustomer;

  List<StoreCustomer>? customers;

  int get customerCount => customers?.length ?? 0;

  int? get totalCustomers => item?.totalCustomers;

  bool? hasReachedMax;

  Function(bool value)? onFetching;

  Function()? onFetched;

  Function(dynamic error)? onFetchError;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.storeState;
    serviceFactory = ServiceFactory();
    item = state!.store;

    isLoading = state?.isLoading ?? false;

    hasError = state?.hasError;
    hasReachedMax = false;
  }

  setLoading(bool loading) {
    store!.dispatch(SetStoreLoadingAction(loading));
  }

  Future<List<StoreCustomer>> getCustomers() async {
    return await LittleFishService.fromStore(store).getStoreCustomers(item);
  }

  Future<List<CustomerList>> getCustomerLists() async {
    return await LittleFishService.fromStore(store).getStoreCustomerLists(item);
  }

  Future<List<StoreUserInvite>> getStoreUserInvites() async {
    return await LittleFishService.fromStore(store).getStoreUserInvites();
  }

  Future<List<StoreUser>> getStoreUsers() async {
    return await LittleFishService.fromStore(store).getStoreUsers(item);
  }

  Future<void> saveCustomer(StoreCustomer customer) async {
    customer.businessId = item!.id;

    return await LittleFishService.fromStore(
      store,
    ).saveCustomer(item!, customer);
  }

  Future<void> deleteCustomer(StoreCustomer customer) async {
    return await LittleFishService.fromStore(
      store,
    ).deleteCustomer(item!, customer);
  }

  Future<void> saveCustomerList(
    CustomerList customerList,
    List<CustomerListLink>? removedCustomers,
  ) async {
    customerList.name = customerList.searchName = cleanString(
      customerList.displayName,
    );
    return await LittleFishService.fromStore(
      store,
    ).saveCustomerList(item!, customerList, removedCustomers: removedCustomers);
  }

  Future<void> deleteCustomerList(CustomerList customerList) async {
    return await LittleFishService.fromStore(
      store,
    ).deleteCustomerList(item!, customerList);
  }

  Future<void> sendMessageToTopic(StoreNotification notification) async {
    return await NotificationServiceCF(
      store: store!,
    ).sendMessageToTopic(notification);
  }

  Future fetchCustomers({int limit = 20}) async {
    try {
      isLoading = true;
      if (isFetching == true || hasReachedMax == true) return;

      if (item == null) return;

      setFetching(true);

      customers ??= <StoreCustomer>[];

      var collection = item!.customersCollection!;

      var query = collection.where('deleted', isEqualTo: false);
      query = query.orderBy('dateCreated');

      if (lastCustomer != null) {
        query = query.startAt([
          lastCustomer!.dateCreated!.millisecondsSinceEpoch,
        ]);
      }

      query = query.limit(limit);

      var snapshot = await query.get();

      List<StoreCustomer> fetchResult = snapshot.docs
          .map(
            (e) => StoreCustomer.fromDocumentSnapshot(
              e,
              reference: collection.doc(e.id),
            ),
          )
          .toList();

      if (fetchResult.isEmpty) {
        hasReachedMax = true;
        return;
      }

      if (fetchResult.length > 1) {
        firstCustomer = fetchResult.first;
      }

      lastCustomer = fetchResult.last;

      if (fetchResult.length < limit) {
        hasReachedMax = true;
      }

      //add to the current collection
      customers!.addAll(fetchResult);
      isLoading = false;
      if (onFetched != null) onFetched!();
    } catch (error) {
      reportCheckedError(error);

      if (null != onFetchError) onFetchError!(error);
    } finally {
      setFetching(false);
    }
  }

  setFetching(bool value) {
    isFetching = value;
    if (onFetching != null) onFetching!(value);
  }
}
