class Primitive {
  final String name;
  final String value;

  const Primitive({this.name = '', this.value = ''});

  factory Primitive.fromJson(Map<String, dynamic> json) {
    return Primitive(name: json['name'] ?? '', value: json['value'] ?? '');
  }

  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}
