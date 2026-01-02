import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'online_product_update.g.dart';

@JsonSerializable(explicitToJson: true)
class OnlineProductUpdate extends Equatable {
  final String productId;
  final bool? isOnline;
  const OnlineProductUpdate(this.productId, this.isOnline);

  @override
  List<Object?> get props => [productId, isOnline];

  factory OnlineProductUpdate.fromJson(Map<String, dynamic> json) =>
      _$OnlineProductUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineProductUpdateToJson(this);
}
