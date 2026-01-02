// Package imports:
import 'package:json_annotation/json_annotation.dart';

enum OccurenceSchedule { onceOff, daily, weekly, everyTwoWeeks, monthly, none }

enum LedgerStatus { open, dormant, frozen, stopped, closed }

enum MessageDirection { incoming, outgoing, both }

enum UIViewMode { create, edit, readonly }

enum NavbarType { basic, advanced }

enum RAGStatus { red, amber, green }

enum PermissionClassification { groupParent, subGroupHeading }

enum TransactionType {
  @JsonValue(0)
  debit,
  @JsonValue(1)
  credit,
}

enum SortBy {
  @JsonValue(0)
  name,
  @JsonValue(1)
  createdDate,
  @JsonValue(2)
  price,
  @JsonValue(3)
  cost,
}

enum SortOrder {
  @JsonValue(0)
  ascending,
  @JsonValue(1)
  descending,
}

enum SalesSubType {
  @JsonValue(0)
  all,
  @JsonValue(1)
  completed,
  @JsonValue(2)
  refunded,
  @JsonValue(3)
  cancelled,
  @JsonValue(4)
  withdrawals,
}

enum ChangeType {
  @JsonValue(0)
  removed,
  @JsonValue(1)
  updated,
  @JsonValue(2)
  added,
  @JsonValue(3)
  upserted,
}

enum CheckoutCartItemType {
  @JsonValue(0)
  stockProduct,
  @JsonValue(1)
  productCombo,
  @JsonValue(2)
  customItem,
}

enum DiscountType {
  @JsonValue(0)
  fixedPrice,
  @JsonValue(1)
  fixedDiscountAmount,
  @JsonValue(2)
  percentage,
  @JsonValue(3)
  none,
}

enum OtpType {
  @JsonValue(0)
  mobile,
  @JsonValue(1)
  email,
}

enum CheckoutActionType {
  @JsonValue(0)
  withdrawal,
  @JsonValue(1)
  cashback,
}

enum AmountValidationResult {
  @JsonValue(0)
  success,
  @JsonValue(1)
  amountTooLittle,
  @JsonValue(2)
  amountTooMuch,
  @JsonValue(3)
  amountRequired,
}

enum SelectableBoxItemFormat {
  @JsonValue(0)
  currency,
  @JsonValue(1)
  currencyNoDecimal,
  @JsonValue(2)
  percentage,
  @JsonValue(3)
  numberOnly,
  @JsonValue(4)
  withSuffix,
  @JsonValue(5)
  percentageRemoveDecimalsIfZero,
}

enum AuthProviderType {
  @JsonValue(0)
  systemDefault,
  @JsonValue(1)
  firebase,
}

enum FieldType {
  @JsonValue(0)
  string,
  @JsonValue(1)
  integer,
}

enum ReportMode {
  @JsonValue(0)
  day,
  @JsonValue(1)
  week,
  @JsonValue(2)
  month,
  @JsonValue(3)
  threeMonths,
  @JsonValue(4)
  year,
  @JsonValue(5)
  custom,
  @JsonValue(6)
  hour,

  @JsonValue(7)
  prevDay,
  @JsonValue(8)
  prevWeek,
  @JsonValue(9)
  prevMonth,
  @JsonValue(10)
  prevYear,
}

enum DateGroupType {
  @JsonValue(0)
  daily,
  @JsonValue(1)
  weekly,
  @JsonValue(2)
  monthly,
  @JsonValue(3)
  quarterly,
  @JsonValue(4)
  yearly,
  @JsonValue(5)
  all,
}

enum ItemDisplayMode { list, grid }

enum ProductViewMode { productsView, stockView }

enum ListViewMode { view, select }

enum OnlineStoreSetupSectionType {
  businessInformation,
  productCatalogue,
  featuredCategories,
  customiseOnlineStore,
  deliveryAndCollection,
  domainName,
}

enum OnlineStoreSectionType {
  productCatalogue,
  featuredCategories,
  deliveryAndCollection,
  customiseOnlineStore,
  businessInformation,
}

enum SubDomainValidatorResponse {
  success,
  emptySubDomain,
  invalidSubDomain,
  notUniqueSubDomain,
}

enum PublishStoreValidatorResponse {
  success,
  noOnlineProducts,
  brandNotConfigured,
  businessInfoNotConfigured,
  domainNotConfigured,
  deliveryAndCollectionNotConfigured,
  isConfiguredFalse,
}

enum OrderTransactionHistoryFilter {
  startDate,
  endDate,
  success,
  pending,
  failure,
  error,
  sales,
  refunds,
  voids,
  withdrawals,
  online,
  inStore,
  card,
  cash,
}

enum OrderTransactionHistorySort {
  oldFirst,
  newFirst,
  priceDesc,
  priceAsc,
  nameDesc,
  nameAsc,
}

enum PosPrintOptions { customer, merchant, both, none }

enum CardTransactionType {
  purchase,
  purchaseWithCashback,
  withdrawal,
  refund,
  voided,
}

// enum PlatformType { pos, softPos }

enum QuantityUnitType { integer, fractional }

enum StatusType { defaultStatus, destructive, success, warning, neutral }

enum TransactionPaymentMethod {
  cash,
  card,
  masterpass,
  snapscan,
  zapper,
  mpesa,
  airtelMoney,
  tigoPesa,
  credit,
  other,
}

enum RequestingChannel {
  @JsonValue(0)
  web,
  @JsonValue(1)
  android,
  @JsonValue(2)
  ios,
  @JsonValue(3)
  pos,
  @JsonValue(4)
  na,
}

enum ProductPageContext {
  /// For general product management (create, view, edit).
  general,

  /// For adding or editing products in the online store context.
  onlineStore,
}
