import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'combo_info.g.dart';

@JsonSerializable(explicitToJson: true)
class ComboInfo extends Equatable {
  final String id;
  final String name;
  final String productId;
  final double quantity;

  const ComboInfo({
    required this.id,
    required this.name,
    required this.productId,
    required this.quantity,
  });

  ComboInfo copyWith({
    String? id,
    String? name,
    String? productId,
    double? quantity,
  }) {
    return ComboInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  factory ComboInfo.fromJson(Map<String, dynamic> json) =>
      _$ComboInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ComboInfoToJson(this);

  @override
  List<Object?> get props => [id, name, productId, quantity];
}
