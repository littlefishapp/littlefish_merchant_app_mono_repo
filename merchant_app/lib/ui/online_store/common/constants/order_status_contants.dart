import 'package:flutter/material.dart';
import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';

class OrderStatusConstants {
  // TODO(lampian): rework to use theme colours
  static final OrderStatus pending = OrderStatus(
    color: Colors.blueGrey.value.toRadixString(16),
    displayName: 'Pending',
    name: 'pending',
    deleted: false,
    description: 'Order has been placed',
    id: 'pending',
    searchName: 'pending',
    enabled: true,
    isSystemStatus: true,
    totalOrders: 0,
    action: 'Pending Order',
  );

  static final OrderStatus confirmed = OrderStatus(
    // TODO(lampian): fix usage of string
    color: Colors.grey.value.toRadixString(16),
    displayName: 'Confirmed',
    name: 'confirmed',
    deleted: false,
    description: 'Shopkeeper has confirmed the order',
    id: 'confirmed',
    searchName: 'confirmed',
    enabled: true,
    isSystemStatus: true,
    totalOrders: 0,
    action: 'Confirm Order',
  );

  static final OrderStatus cancelled = OrderStatus(
    color: Colors.red.value.toRadixString(16),
    displayName: 'Cancelled',
    name: 'cancelled',
    deleted: false,
    description: 'Order cannot be fulfilled',
    id: 'cancelled',
    searchName: 'cancelled',
    enabled: true,
    isSystemStatus: true,
    totalOrders: 0,
    action: 'Cancel Order',
  );

  static final OrderStatus complete = OrderStatus(
    color: Colors.green.value.toRadixString(16),
    displayName: 'Complete',
    name: 'complete',
    deleted: false,
    description: 'Order complete, and payment received',
    id: 'complete',
    searchName: 'complete',
    enabled: true,
    isSystemStatus: true,
    totalOrders: 0,
    action: 'Complete Order',
  );

  static final OrderStatus ready = OrderStatus(
    totalOrders: 0,
    color: Colors.yellow.value.toRadixString(16),
    displayName: 'Ready for Collection',
    searchName: 'ready',
    name: 'ready',
    id: 'ready',
    description: 'Order is packed, and ready for customer collection',
    deleted: false,
    isSystemStatus: true,
    action: 'Ready for Collection',
  );

  static final OrderStatus out = OrderStatus(
    totalOrders: 0,
    color: Colors.teal.value.toRadixString(16),
    displayName: 'Out for Delivery',
    searchName: 'out',
    name: 'out',
    id: 'out',
    description: 'The order is out for delivery',
    deleted: false,
    isSystemStatus: true,
    action: 'Deliver Order',
  );

  static final OrderStatus preparing = OrderStatus(
    totalOrders: 0,
    color: Colors.cyan.value.toRadixString(16),
    displayName: 'Preparing',
    searchName: 'preparing',
    name: 'preparing',
    id: 'preparing',
    description: 'Your order is being packed and prepared',
    deleted: false,
    isSystemStatus: true,
    action: 'Prepare Order',
  );

  static final orderStatusFlow = [
    pending,
    confirmed,
    preparing,
    ready,
    out,
    complete,
    cancelled,
  ];
}
