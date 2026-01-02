import 'package:equatable/equatable.dart';

import 'payment_type.dart';

class PaymentTypeList extends Equatable {
  final String created;
  final String usecase;
  final List<PaymentType> types;
  final List<String> voidTypes;
  final List<String> refundTypes;

  const PaymentTypeList({
    this.types = const [],
    this.voidTypes = const [],
    this.refundTypes = const [],
    this.created = '',
    this.usecase = '',
  });

  factory PaymentTypeList.fromJson(Map<String, dynamic> jsonMap) {
    var created = '';
    var useCase = '';
    var types = <PaymentType>[];
    var voids = <String>[];
    var refunds = <String>[];

    if (jsonMap.containsKey('config_info')) {
      final configMap = jsonMap['config_info'];
      if (configMap is Map) {
        if (configMap.containsKey('created')) {
          created = configMap['created'];
        }
        if (configMap.containsKey('usecase')) {
          useCase = configMap['usecase'];
        }
      }
    }

    if (jsonMap.containsKey('types')) {
      final typesMap = jsonMap['types'];
      if (typesMap is List) {
        types = typesMap
            .map<PaymentType>((e) => PaymentType.fromJson(e))
            .toList();
      }
    }

    if (jsonMap.containsKey('refundTypes')) {
      final typesMap = jsonMap['refundTypes'];
      if (typesMap is List) {
        refunds = typesMap.map<String>((e) => e).toList();
      }
    }

    if (jsonMap.containsKey('voidTypes')) {
      final typesMap = jsonMap['voidTypes'];
      if (typesMap is List) {
        voids = typesMap.map<String>((e) => e).toList();
      }
    }

    return PaymentTypeList(
      created: created,
      refundTypes: refunds,
      types: types,
      usecase: useCase,
      voidTypes: voids,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [created, usecase, types, voidTypes, refundTypes];
}
