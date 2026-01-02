// package imports
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

// project imports
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_filter_utilities.dart';

part 'order_filter.g.dart';

@JsonSerializable(explicitToJson: true)
@immutable
class OrderFilter extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<CapturedChannel> _capturedChannels;
  final List<FinancialStatus> _financialStatuses;
  final FulfilmentMethod? fulfilmentMethod;
  final OrderStatus? orderStatus;
  final FulfillmentStatus? fulfillmentStatus;
  final OrderSource? orderSource;

  OrderFilter({
    this.startDate,
    this.endDate,
    this.orderStatus,
    this.fulfillmentStatus,
    this.orderSource,
    this.fulfilmentMethod,
    List<CapturedChannel>? capturedChannels,
    List<FinancialStatus>? financialStatuses,
  }) : _capturedChannels = List.unmodifiable(capturedChannels ?? []),
       _financialStatuses = List.unmodifiable(financialStatuses ?? []);

  List<CapturedChannel> get capturedChannels => _capturedChannels;
  List<FinancialStatus> get financialStatuses => _financialStatuses;

  OrderFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<CapturedChannel>? capturedChannels,
    List<FinancialStatus>? financialStatuses,
    FulfilmentMethod? fulfilmentMethod,
    OrderStatus? orderStatus,
    FulfillmentStatus? fulfillmentStatus,
    OrderSource? orderSource,
  }) {
    return OrderFilter(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      capturedChannels: capturedChannels ?? this.capturedChannels,
      financialStatuses: financialStatuses ?? this.financialStatuses,
      fulfilmentMethod: fulfilmentMethod ?? this.fulfilmentMethod,
      orderStatus: orderStatus ?? this.orderStatus,
      fulfillmentStatus: fulfillmentStatus ?? this.fulfillmentStatus,
      orderSource: orderSource ?? this.orderSource,
    );
  }

  bool hasData() {
    return startDate != null ||
        endDate != null ||
        capturedChannels.isNotEmpty ||
        financialStatuses.isNotEmpty ||
        fulfilmentMethod != null ||
        orderStatus != null ||
        fulfillmentStatus != null ||
        orderSource != null;
  }

  List<Order> applyFilters(List<Order> orders) {
    List<Order> filteredOrders = orders;

    if (startDate != null || endDate != null) {
      filteredOrders = OrderFilterUtilities.filterByDateRange(
        filteredOrders,
        startDate,
        endDate,
      );
    }

    if (capturedChannels.isNotEmpty) {
      filteredOrders = OrderFilterUtilities.filterByCapturedChannel(
        filteredOrders,
        capturedChannels,
      );
    }

    if (financialStatuses.isNotEmpty) {
      filteredOrders = OrderFilterUtilities.filterByFinancialStatus(
        filteredOrders,
        financialStatuses,
      );
    }

    if (fulfilmentMethod != null) {
      filteredOrders = OrderFilterUtilities.filterByFulfilmentMethod(
        filteredOrders,
        fulfilmentMethod!,
      );
    }

    if (orderStatus != null) {
      filteredOrders = OrderFilterUtilities.filterByOrderStatus(
        filteredOrders,
        orderStatus!,
      );
    }

    if (fulfillmentStatus != null) {
      filteredOrders = OrderFilterUtilities.filterByFulfillmentStatus(
        filteredOrders,
        fulfillmentStatus!,
      );
    }

    if (orderSource != null) {
      filteredOrders = OrderFilterUtilities.filterByOrderSource(
        filteredOrders,
        orderSource!,
      );
    }

    return filteredOrders;
  }

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    capturedChannels,
    financialStatuses,
    fulfilmentMethod,
    orderStatus,
    fulfillmentStatus,
    orderSource,
  ];
}
