List<String> toArray(String value) {
  if (value.isEmpty) return [];

  List items = [];
  for (var i = 0; i < value.length; i++) {
    items.add(value[i]);
  }
  return items as List<String>;
}

double? toDouble(String value) {
  var amt = value;

  amt = amt.replaceAll(RegExp(r'\s\b|\b\s\t'), '');

  return double.tryParse(amt);
}

int toInt(String? value) {
  var amt = value ?? '0';

  amt = amt.replaceAll(RegExp(r'\s\b|\b\s\t'), '');

  return double.tryParse(amt)!.floor();
}

String enumToString(dynamic value) {
  if (value == null) return value;

  return value.toString().substring(value.toString().lastIndexOf('.') + 1);
}
