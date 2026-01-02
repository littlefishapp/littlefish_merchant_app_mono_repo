class SystemVariant {
  String? name;
  String? id;

  SystemVariant({this.id, this.name});

  factory SystemVariant.fromJson(Map<String, dynamic> json) {
    return SystemVariant(
      name: json['name'] as String?,
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson(SystemVariant instance) => <String, dynamic>{
    'name': instance.name,
    'id': instance.id,
  };
}
