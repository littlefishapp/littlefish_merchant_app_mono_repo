import 'primitive.dart';

class NeutralPrimitiveDesignSystem {
  final Primitive neutral1;
  final Primitive neutral2;
  final Primitive neutral3;
  final Primitive neutral4;
  final Primitive neutral5;
  final Primitive neutral6;
  final Primitive neutral7;
  final Primitive neutral8;

  const NeutralPrimitiveDesignSystem({
    this.neutral1 = const Primitive(),
    this.neutral2 = const Primitive(),
    this.neutral3 = const Primitive(),
    this.neutral4 = const Primitive(),
    this.neutral5 = const Primitive(),
    this.neutral6 = const Primitive(),
    this.neutral7 = const Primitive(),
    this.neutral8 = const Primitive(),
  });

  factory NeutralPrimitiveDesignSystem.fromJson(Map<String, dynamic> json) {
    return NeutralPrimitiveDesignSystem(
      neutral1: Primitive.fromJson(json['neutral1']),
      neutral2: Primitive.fromJson(json['neutral2']),
      neutral3: Primitive.fromJson(json['neutral3']),
      neutral4: Primitive.fromJson(json['neutral4']),
      neutral5: Primitive.fromJson(json['neutral5']),
      neutral6: Primitive.fromJson(json['neutral6']),
      neutral7: Primitive.fromJson(json['neutral7']),
      neutral8: Primitive.fromJson(json['neutral8']),
    );
  }

  Map<String, dynamic> toJson() => {
    'neutral1': neutral1.toString(),
    'neutral2': neutral2.toString(),
    'neutral3': neutral3.toString(),
    'neutral4': neutral4.toString(),
    'neutral5': neutral5.toString(),
    'neutral6': neutral6.toString(),
    'neutral7': neutral7.toString(),
    'neutral8': neutral8.toString(),
  };
}
