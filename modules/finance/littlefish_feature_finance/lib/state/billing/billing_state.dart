// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/billing/billing_info.dart';

part 'billing_state.g.dart';

abstract class BillingState
    implements Built<BillingState, BillingStateBuilder> {
  BillingState._();

  factory BillingState() =>
      _$BillingState._(hasError: false, isLoading: false, errorMessage: null);

  // static Serializer<BillingState> get serializer => _$billingStateSerializer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  String get currentLicense => billingStoreInfo?.currentLicense ?? 'free';

  bool? get billingSupported;

  // List<Package>? get availablePackages =>
  //     storeOfferings?.current?.availablePackages;

  BillingStoreInfo? get billingStoreInfo;

  // Offerings? get storeOfferings;

  bool? get showBillingPage;
}
