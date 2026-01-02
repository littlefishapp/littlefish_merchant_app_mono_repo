// Flutter imports:

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../../../../../features/ecommerce_shared/models/online/system_variant.dart';
import '../../../../../features/ecommerce_shared/models/store/store.dart'
    as model;
import '../../../../../features/ecommerce_shared/models/store/store_attribute.dart';
import '../../../../../features/ecommerce_shared/models/store/store_subtype.dart';
import '../../../../../features/ecommerce_shared/models/store/store_type.dart';

class StoreServiceCF {
  StoreServiceCF({required this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store.state.token}';
    baseUrl =
        '${store.state.environmentState.environmentConfig!.cloudFunctionsUrl}storeAPI';
    reviewBaseUrl = store.state.environmentState.environmentConfig?.baseUrl!;
    //'http://10.0.2.2:6001/littlefish-merchant-dev/europe-west1/apiGroup-storeAPI';
  }

  String? baseUrl;
  String? reviewBaseUrl;
  String? token;
  Store<AppState> store;
  late RestClient client;

  Future<dynamic> publishStore(model.Store store) async {
    Map<String, dynamic> json = {'storeId': store.id};
    var response = await client.post(
      url: '$baseUrl/publishStore',
      token: token,
      requestData: json,
    );

    if (response?.statusCode == 200) {
      return store;
    } else if (response?.statusCode == 400) {
      var errorCode = response!.data;

      if (errorCode.startsWith('NOT_CONFIGURED')) {
        throw ManagedException(message: 'Please complete store configuration');
      } else if (errorCode.startsWith('NO_PRODUCTS')) {
        throw ManagedException(message: 'Please add atleast 2 products');
      } else {
        throw Exception(response.data());
      }
    } else {
      throw Exception(response!.data());
    }
  }

  Future<dynamic> submitStoreForReview(
    model.Store store,
    String storeUrl,
  ) async {
    final Map<String, dynamic> body = {'store_url': storeUrl};

    var response = await client.post(
      url: '$reviewBaseUrl/Store/reviewStore/',
      token: token,
      requestData: body,
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(
        'Bad server response, unable to check for unique subdomain',
      );
    }
  }

  Future<bool> isStoreReviewed(model.Store store) async {
    final response = await client.get(
      url: '$reviewBaseUrl/Business/GetBusiness?businessId=${store.businessId}',
      token: token,
    );

    if (response?.statusCode == 200) {
      final data = response!.data as Map<String, dynamic>;
      return data['isOnline'] as bool? ?? false;
    } else {
      throw Exception(
        'Bad server response, unable to check for unique subdomain',
      );
    }
  }

  Future<bool> subdomainExists(String? storeId, String? subdomainName) async {
    var response = await client.post(
      url: '$baseUrl/uniqueDomain',
      //'http://10.0.2.2:6001/littlefish-merchant-dev/europe-west1/apiGroup-storeAPI/uniqueDomain',
      token: token,
      requestData: {'storeId': storeId, 'subdomainName': subdomainName},
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(
        'Bad server response, unable to check for unique subdomain',
      );
    }
  }

  Future<dynamic> goOffline(String? id) async {
    var response = await client.post(
      url: '$baseUrl/goOffline?id=$id',
      token: token,
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data());
    }
  }

  Future<dynamic> upsertFirebaseStore(model.Store store) async {
    Map<String, dynamic> json = store.toJson();
    var response = await client.post(
      url: '$baseUrl/saveStore',
      token: token,
      requestData: json,
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data());
    }
  }

  Future<dynamic> saveStoreTradingHours(
    String? id,
    List<model.TradingDay>? tradingHours,
  ) async {
    var response = await client.post(
      url: '$baseUrl/saveTradingHours?id=$id',
      token: token,
      requestData: tradingHours?.map((e) => e.toJson()).toList(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data());
    }
  }

  Future<dynamic> saveStoreCategories(
    model.StoreCategoryOptions categories,
    String id,
  ) async {
    var response = await client.post(
      url: '$baseUrl/saveStoreCategories?id=$id',
      token: token,
      requestData: categories.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data());
    }
  }

  Future<dynamic> saveStoreType(
    String? id, {
    required StoreType storeType,
    required StoreSubtype storeSubtype,
    required List<StoreProductType>? storeProductTypes,
    required List<StoreAttribute>? storeAttributes,
  }) async {
    var body = {
      'storeTypeId': storeType.id,
      'storeSubtypeId': storeSubtype.id,
      'storeAttributes':
          storeAttributes?.map((e) => {'id': e.id}).toList() ?? [],
      'storeProductTypes':
          storeProductTypes?.map((e) => {'id': e.id}).toList() ?? [],
    };
    var response = await client.post(
      url: '$baseUrl/saveStoreTypeInfo?id=$id',
      token: token,
      requestData: body,
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data());
    }
  }

  Future<dynamic> saveLocationInformation(
    model.StoreAddress location,
    String? id,
  ) async {
    var response = await client.post(
      url: '$baseUrl/saveLocation?id=$id',
      token: token,
      requestData: location.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data());
    }
  }

  Future<dynamic> deleteStore(String id) async {
    var response = await client.delete(
      url: '$baseUrl/deleteStore?id=$id',
      token: token,
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data());
    }
  }

  Future<QuerySnapshot> getStoreCategories() {
    return FirebaseFirestore.instance.collection('store_categories').get();
  }

  Future<List<StoreType>> getStoreTypes() async {
    var query = FirebaseFirestore.instance.collection('store_types');

    return (await query.get()).docs
        .map((e) => StoreType.fromDocumentSnapshot(e, reference: e.reference))
        .toList();
  }

  Future<List<SystemVariant>> getSystemVariants() async {
    var query = FirebaseFirestore.instance.collection('system_variants');

    return (await query.get()).docs
        .map((e) => SystemVariant.fromJson(e.data()))
        .toList();
  }

  Future<List<StoreSubtype>> getStoreSubtypes(StoreType storeType) async {
    var query = storeType.storeSubtypesCollection!;

    return (await query.get()).docs
        .map(
          (e) => StoreSubtype.fromDocumentSnapshot(e, reference: e.reference),
        )
        .toList();
  }

  Future<List<StoreProductType>> getSystemStoreProductTypes(
    StoreSubtype storeSubtype,
  ) async {
    Query query = storeSubtype.storeProductTypesCollection!;

    return (await query.get()).docs
        .map((e) => StoreProductType.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<StoreAttributeGroupLink>> getSystemStoreAttributeGroupLinks(
    StoreSubtype storeSubtype,
  ) async {
    Query query = storeSubtype.storeAttributeGroupsCollection!;

    return (await query.get()).docs
        .map(
          (e) => StoreAttributeGroupLink.fromJson(
            e.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<dynamic> getSystemStoreAttributes(StoreSubtype storeSubtype) async {
    Query query = storeSubtype.storeAttributeGroupsCollection!;

    return (await query.get()).docs.map((e) => e.data).toList();
  }

  Future<List<DocumentSnapshot>> getCurrentStoreProductTypes(
    model.Store store,
  ) async {
    var query = store.storeProductTypesCollection!;

    return (await query.get()).docs.toList();
  }

  Future<List<DocumentSnapshot>> getCurrentStoreAttributes(
    model.Store store,
  ) async {
    var query = store.storeAttributesCollection!;

    return ((await query.get()).docs.toList());
  }

  Future<List<StoreAttribute>> getStoreAttributes(
    StoreAttributeGroup storeAttributeGroup,
  ) async {
    var query = storeAttributeGroup.storeAttributesCollection!;

    return (await query.get()).docs
        .map((e) => StoreAttribute.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<StoreProductType>> getStoreProductTypes(model.Store store) async {
    Query query = store.storeProductTypesCollection!;

    return (await query.get()).docs
        .map((e) => StoreProductType.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<StoreAttributeGroup>> getStoreAttributeGroups() async {
    var query = FirebaseFirestore.instance.collection('store_attribute_groups');

    return (await query.get()).docs
        .map((e) => StoreAttributeGroup.fromDocumentSnapshot(e))
        .toList();
  }
}
