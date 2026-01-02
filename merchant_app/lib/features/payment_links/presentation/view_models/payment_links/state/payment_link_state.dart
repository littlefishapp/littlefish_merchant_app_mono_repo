import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:built_collection/built_collection.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import '../../../../../order_common/data/model/order.dart';

part 'payment_link_state.g.dart';

@immutable
@JsonSerializable()
abstract class PaymentLinksState
    implements Built<PaymentLinksState, PaymentLinksStateBuilder> {
  factory PaymentLinksState([
    void Function(PaymentLinksStateBuilder)? updates,
  ]) => _$PaymentLinksState(
    (b) => b
      ..links = ListBuilder<Order>()
      ..offset = 0
      ..limit = 10
      ..totalRecords = 0
      ..hasMore = true
      ..isLoading = false
      ..hasError = false
      ..error = null
      ..update(updates),
  );

  const PaymentLinksState._();

  BuiltList<Order> get links;
  bool get isLoading;
  bool get hasError;
  GeneralError? get error;

  int get offset;
  int get limit;
  int get totalRecords;
  bool get hasMore;
}
