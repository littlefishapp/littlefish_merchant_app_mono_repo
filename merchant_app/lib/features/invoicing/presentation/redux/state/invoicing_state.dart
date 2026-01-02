import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import '../../../../../models/stock/stock_product.dart';
import '../../../../order_common/data/model/order.dart';

part 'invoicing_state.g.dart';

abstract class InvoicingState
    implements Built<InvoicingState, InvoicingStateBuilder> {
  factory InvoicingState([void Function(InvoicingStateBuilder)? updates]) =>
      _$InvoicingState(
        (b) => b
          ..invoices = ListBuilder<Order>()
          ..offset = 0
          ..limit = 10
          ..totalRecords = 0
          ..hasMore = true
          ..discount = null
          ..totalAmount = 0
          ..dueDate = null
          ..notes = ''
          ..selectedProducts = ListBuilder<StockProduct>()
          ..selectedQuantities = MapBuilder<String, int>({})
          ..isLoading = false
          ..hasError = false
          ..error = null
          ..update(updates),
      );

  InvoicingState._();

  BuiltList<Order> get invoices;

  CheckoutDiscount? get discount;

  double get totalAmount;

  DateTime? get dueDate;

  BuiltList<StockProduct> get selectedProducts;

  BuiltMap<String, int> get selectedQuantities;

  String get notes;

  bool get isLoading;

  bool get hasError;

  GeneralError? get error;

  int get offset;
  int get limit;
  int get totalRecords;
  bool get hasMore;
}
