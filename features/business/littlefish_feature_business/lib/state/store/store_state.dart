// Package imports:
import 'package:built_value/built_value.dart';

// project imports
import 'package:littlefish_merchant/models/enums.dart';
import '../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../features/ecommerce_shared/models/shared/analysis_pair.dart';
import '../../features/ecommerce_shared/models/store/promotion.dart';
import '../../features/ecommerce_shared/models/store/store.dart';
import '../../features/ecommerce_shared/models/store/store_attribute.dart';
import '../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../features/ecommerce_shared/models/store/store_product.dart';
import '../../features/ecommerce_shared/models/store/store_subtype.dart';
import '../../features/ecommerce_shared/models/store/store_type.dart';
import '../../features/ecommerce_shared/models/store/store_user.dart';
import '../../tools/textformatter.dart';

part 'store_state.g.dart';

abstract class StoreState implements Built<StoreState, StoreStateBuilder> {
  StoreState._();

  factory StoreState() => _$StoreState._(hasError: false, errorMessage: null);

  bool? get hasError;

  String? get errorMessage;

  bool? get isLoading;

  Store? get store;

  List<StoreProductCategory>? get productCategories;

  double? get followerCount;

  List<StoreProduct>? get products;

  bool get storeIsLive => store?.isPublic ?? false;

  List<CheckoutOrder>? get orders;

  List<StoreCustomer>? get customers;

  List<OrderStatus>? get orderStatuses;

  bool get hasProducts => products != null && products!.isNotEmpty;

  List<StoreProduct>? get onsaleProducts;

  bool get hasSale => onsaleProducts != null && onsaleProducts!.isNotEmpty;

  double? get totalRevenue {
    if (orders != null && orders!.isNotEmpty) {
      return orders?.fold(
        0,
        ((a, b) => a + b.orderValue)
            as double? Function(double?, CheckoutOrder),
      );
    }

    return 0;
  }

  double? get totalCost {
    if (orders != null && orders!.isNotEmpty) {
      return orders?.fold(
        0,
        ((a, b) => a + b.orderCost) as double? Function(double?, CheckoutOrder),
      );
    }

    return 0;
  }

  int get completeOrders {
    if (orders != null && orders!.isNotEmpty) {
      return orders?.where((c) => c.status == 'complete').length ?? 0;
    }

    return 0;
  }

  int get incompleteOrders {
    if (orders != null && orders!.isNotEmpty) {
      return orders?.where((c) => c.status != 'complete').length ?? 0;
    }

    return 0;
  }

  List<AnalysisPair> get ordersMadeAnalysis {
    if (orders != null && orders!.isNotEmpty) {
      Map<String, int> map = {};
      var result = <AnalysisPair>[];
      var dates = orders!
          .map(
            (f) =>
                '${TextFormatter.toShortDate(dateTime: f.orderDate)} ${f.orderDate!.hour}:${f.orderDate!.minute}',
          )
          .toList();

      for (var element in dates) {
        map.putIfAbsent(element, () => 0);
        // list.add(element);
      }

      map.forEach((element, index) {
        var itemsInStatus =
            orders
                ?.where(
                  (f) =>
                      '${TextFormatter.toShortDate(dateTime: f.orderDate)} ${f.orderDate!.hour}:${f.orderDate!.minute}' ==
                      element,
                )
                .fold(0, (dynamic a, b) => a + b.orderValue) ??
            0;

        result.add(AnalysisPair(id: element, value: itemsInStatus.toDouble()));
      });

      return result;
    }

    return <AnalysisPair>[];
  }

  List<AnalysisPair> get currentOrderStatusesAnalyis {
    if (orders != null && orders!.isNotEmpty) {
      var result = <AnalysisPair>[];

      var statuses = orderStatuses!;

      for (var item in statuses) {
        var itemsInStatus =
            orders?.where((z) => z.status == item.name).length ?? 0;
        result.add(
          AnalysisPair(
            id: item.displayName,
            value: itemsInStatus.roundToDouble(),
          ),
        );
      }

      return result;
    }

    return <AnalysisPair>[];
  }

  List<StoreProduct>? get featuredProducts;

  bool get hasFeaturedProducts =>
      featuredProducts != null && featuredProducts!.isNotEmpty;

  List<StoreUser>? get teamMembers;

  bool get hasTeamMembers => teamMembers != null && teamMembers!.isNotEmpty;
}

abstract class StoreUIState
    implements Built<StoreUIState, StoreUIStateBuilder> {
  StoreUIState._();

  factory StoreUIState() => _$StoreUIState._(
    isLoading: false,
    hasError: false,
    errorMessage: null,
    isSearchingProducts: false,
    selectedOrderIndex: 0,
  );

  bool? get isLoading;

  bool? get isSearchingProducts;

  bool? get hasError;

  String? get errorMessage;

  StoreProductCategory? get selectedCategory;

  List<String>? get subCategories;

  String? get selectedSubCategory;

  Promotion? get selectedPromotion;

  List<StoreProduct>? get categoryProducts;

  List<StoreProduct>? get subCategoryProducts;

  List<StoreProductType>? get storeProductTypeOptions;

  List<List<StoreAttribute>>? get storeAttributeOptions;

  List<StoreProductType>? get selectedStoreProductTypes;

  List<StoreAttribute>? get selectedStoreAttributes;

  StoreSubtype? get selectedStoreSubtype;

  StoreType? get selectedStoreType;

  StoreProduct? get item;

  List<CheckoutOrder>? get selectedOrders;

  String? get selectedOrderStatus;

  int? get selectedOrderIndex;

  int? get currentNavIndex;

  SortBy? get sortProductsBy;

  SortOrder? get sortProductsOrder;
}
