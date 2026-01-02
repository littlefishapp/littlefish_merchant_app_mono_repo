import 'package:littlefish_merchant/app/theme/design_system/primitive.dart';

class BrandPrimitiveDesignSystem {
  final Primitive brand1;
  final Primitive brand2;
  final Primitive brand3;
  final Primitive brand4;
  final Primitive brand5;
  final Primitive brand6;
  final Primitive brand7;
  final Primitive brand8;
  final Primitive brand9;

  const BrandPrimitiveDesignSystem({
    this.brand1 = const Primitive(),
    this.brand2 = const Primitive(),
    this.brand3 = const Primitive(),
    this.brand4 = const Primitive(),
    this.brand5 = const Primitive(),
    this.brand6 = const Primitive(),
    this.brand7 = const Primitive(),
    this.brand8 = const Primitive(),
    this.brand9 = const Primitive(),
  });

  factory BrandPrimitiveDesignSystem.fromJson(Map<String, dynamic> json) {
    return BrandPrimitiveDesignSystem(
      brand1: Primitive.fromJson(json['brand1']),
      brand2: Primitive.fromJson(json['brand2']),
      brand3: Primitive.fromJson(json['brand3']),
      brand4: Primitive.fromJson(json['brand4']),
      brand5: Primitive.fromJson(json['brand5']),
      brand6: Primitive.fromJson(json['brand6']),
      brand7: Primitive.fromJson(json['brand7']),
      brand8: Primitive.fromJson(json['brand8']),
      brand9: Primitive.fromJson(json['brand9']),
    );
  }

  Map<String, dynamic> toJson() => {
    'brand1': brand1.toJson(),
    'brand2': brand2.toJson(),
    'brand3': brand3.toJson(),
    'brand4': brand4.toJson(),
    'brand5': brand5.toJson(),
    'brand6': brand6.toJson(),
    'brand7': brand7.toJson(),
    'brand8': brand8.toJson(),
    'brand9': brand9.toJson(),
  };
}
