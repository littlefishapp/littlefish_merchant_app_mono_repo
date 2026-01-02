import 'primitive.dart';

class StatusPrimitiveDesignSystem {
  final Primitive status1;
  final Primitive status2;
  final Primitive status3;
  final Primitive status4;
  final Primitive status5;
  final Primitive status6;
  final Primitive status7;
  final Primitive status8;
  final Primitive status9;
  final Primitive status10;
  final Primitive status11;
  final Primitive status12;

  const StatusPrimitiveDesignSystem({
    this.status1 = const Primitive(),
    this.status2 = const Primitive(),
    this.status3 = const Primitive(),
    this.status4 = const Primitive(),
    this.status5 = const Primitive(),
    this.status6 = const Primitive(),
    this.status7 = const Primitive(),
    this.status8 = const Primitive(),
    this.status9 = const Primitive(),
    this.status10 = const Primitive(),
    this.status11 = const Primitive(),
    this.status12 = const Primitive(),
  });

  factory StatusPrimitiveDesignSystem.fromJson(Map<String, dynamic> json) {
    return StatusPrimitiveDesignSystem(
      status1: Primitive.fromJson(json['status1']),
      status2: Primitive.fromJson(json['status2']),
      status3: Primitive.fromJson(json['status3']),
      status4: Primitive.fromJson(json['status4']),
      status5: Primitive.fromJson(json['status5']),
      status6: Primitive.fromJson(json['status6']),
      status7: Primitive.fromJson(json['status7']),
      status8: Primitive.fromJson(json['status8']),
      status9: Primitive.fromJson(json['status9']),
      status10: Primitive.fromJson(json['status10']),
      status11: Primitive.fromJson(json['status11']),
      status12: Primitive.fromJson(json['status12']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status1': status1.toString(),
    'status2': status2.toString(),
    'status3': status3.toString(),
    'status4': status4.toString(),
    'status5': status5.toString(),
    'status6': status6.toString(),
    'status7': status7.toString(),
    'status8': status8.toString(),
    'status9': status9.toString(),
    'status10': status10.toString(),
    'status11': status11.toString(),
    'status12': status12.toString(),
  };
}
