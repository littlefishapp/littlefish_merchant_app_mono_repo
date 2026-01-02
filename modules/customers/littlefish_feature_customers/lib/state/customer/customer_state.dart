// Flutter imports:
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';

part 'customer_state.g.dart';

@immutable
@JsonSerializable()
abstract class CustomerState
    implements Built<CustomerState, CustomerStateBuilder> {
  const CustomerState._();

  factory CustomerState() => _$CustomerState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    customers: const <Customer>[],
  );

  // static Serializer<CustomerState> get serializer => _$customerStateSerializer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  List<Customer>? get customers;

  List<Contact>? get contacts;

  Customer? getCustomerById({required String id}) {
    Customer? customer;
    customers?.forEach((c) {
      if (c.id == id) customer = c;
    });
    return customer;
  }
}

abstract class CustomerUIState
    implements Built<CustomerUIState, CustomerUIStateBuilder> {
  factory CustomerUIState() {
    return _$CustomerUIState._(
      item: UIEntityState<Customer>(Customer.create(), isNew: true),
    );
  }

  CustomerUIState._();

  UIEntityState<Customer?>? get item;

  bool get isNew => item?.isNew ?? false;
}
