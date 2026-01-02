import 'package:flutter/material.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import 'bottom_navbar.dart';

IconData getIconForPageType({required PageType pageType, bool active = false}) {
  if (active) {
    switch (pageType) {
      case PageType.home:
        return Icons.home;
      case PageType.products:
        return Icons.archive;
      case PageType.stock:
        return Icons.note_alt;
      case PageType.eStore:
        return Icons.add_business;
      case PageType.more:
        return Icons.settings;
      case PageType.sell:
        return Icons.point_of_sale;
      case PageType.sales:
        return Icons.receipt_long;
      case PageType.orderFulfillment:
        return Icons.add_business;
      case PageType.getPaid:
        return Icons.monetization_on_rounded;
      default:
    }
  }
  switch (pageType) {
    case PageType.home:
      return Icons.home_outlined;
    case PageType.products:
      return Icons.archive_outlined;
    case PageType.stock:
      return Icons.note_alt_outlined;
    case PageType.eStore:
      return Icons.add_business_outlined;
    case PageType.more:
      return Icons.settings_outlined;
    case PageType.sell:
      return Icons.point_of_sale_outlined;
    case PageType.sales:
      return Icons.receipt_long_outlined;
    case PageType.orderFulfillment:
      return Icons.add_business_outlined;
    case PageType.getPaid:
      return Icons.monetization_on_outlined;
    default:
  }
  return LittleFishIcons.error;
}
