import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tax_info.g.dart';

@JsonSerializable(explicitToJson: true)
class TaxInfo extends Equatable {
  final String taxId;
  final String name;
  final double price;
  final double rate;
  final TaxType type;
  final TaxTarget target;

  const TaxInfo({
    this.taxId = '',
    this.name = '',
    this.price = 0.0,
    this.rate = 0.0,
    this.target = TaxTarget.undefined,
    this.type = TaxType.undefined,
  });

  TaxInfo copyWith({
    String? taxId,
    String? name,
    double? price,
    double? rate,
    TaxType? type,
    TaxTarget? target,
  }) {
    return TaxInfo(
      name: name ?? this.name,
      price: price ?? this.price,
      rate: rate ?? this.rate,
      target: target ?? this.target,
      taxId: taxId ?? this.taxId,
      type: type ?? this.type,
    );
  }

  factory TaxInfo.fromJson(Map<String, dynamic> json) =>
      _$TaxInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TaxInfoToJson(this);

  @override
  List<Object?> get props => [taxId, name, price, rate, type, target];
}

@JsonEnum()
enum TaxType {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  amount,
  @JsonValue(1)
  percentage,
}

@JsonEnum()
enum TaxTarget {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  lineItem,
  @JsonValue(1)
  cart,
}
