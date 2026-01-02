import 'package:flutter/material.dart';

class SellViewItem {
  final String name;
  final String displayName;
  final String icon;
  final String iconAndroid;
  final String iconIOS;
  final String route;
  final List<SellViewItem> subItems;
  final IconData? iconData;
  final Function(dynamic context)? action;

  const SellViewItem({
    this.name = '',
    this.displayName = '',
    this.icon = '',
    this.iconAndroid = '',
    this.iconIOS = '',
    this.route = '',
    this.subItems = const [],
    this.iconData,
    this.action,
  });

  factory SellViewItem.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};

    var subItems = <SellViewItem>[];
    if (data.containsKey('subItems')) {
      final value = data['subItems'];
      if (value is List) {
        subItems = value
            .map((e) => SellViewItem.fromJson(e as Map<String, dynamic>?))
            .toList();
      }
    }

    try {
      return SellViewItem(
        name: data['name'] ?? '',
        displayName: data['displayName'] ?? '',
        icon: data['icon'] ?? '',
        iconAndroid: data['icon_android'] ?? '',
        iconIOS: data['icon_iOS'] ?? '',
        route: data['route'] ?? '',
        subItems: subItems,
      );
    } catch (e) {
      debugPrint('### Error parsing SellViewItem from JSON: $e');
    }
    return SellViewItem();
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'displayName': displayName,
      'icon': icon,
      'icon_android': iconAndroid,
      'icon_iOS': iconIOS,
      'route': route,
    };
    if (subItems.isNotEmpty) {
      json['subItems'] = subItems.map((e) => e.toJson()).toList();
    }
    return json;
  }
}
