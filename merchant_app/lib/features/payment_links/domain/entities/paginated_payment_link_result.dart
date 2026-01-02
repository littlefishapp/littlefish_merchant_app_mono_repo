import 'package:equatable/equatable.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';

class PaginatedPaymentLinkResult extends Equatable {
  final List<Order> items;
  final int totalRecords;

  const PaginatedPaymentLinkResult({
    this.items = const [],
    this.totalRecords = 0,
  });

  @override
  List<Object?> get props => [items, totalRecords];
}
