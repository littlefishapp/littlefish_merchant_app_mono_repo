// extension on String {
//   //toArray1 method
//   List toArray1() {
//     List items = [];
//     for (var i = 0; i < this.length; i++) {
//       items.add(this[i]);
//     }
//     return items;
//   }

//   //toArray2 method
//   List toArray2() {
//     List items = [];
//     this.split("").forEach((item) => items.add(item));
//     return items;
//   }
// }

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

int toInt(String value) {
  var amt = value;

  amt = amt.replaceAll(RegExp(r'\s\b|\b\s\t'), '');

  return double.tryParse(amt)!.floor();
}

String normalizeMobileNumber(String value) {
  if (value.isEmpty) return value;

  value = value.trim();

  if (value.startsWith('+27')) {
    value = value.substring('+27'.length).padLeft(10, '0');
  }

  value = value.replaceAll(RegExp(r'\s\b|\b\s\t'), '');

  return value;
}

String enumToString(dynamic value) {
  if (value == null) return value;

  return value.toString().substring(value.toString().lastIndexOf('.') + 1);
}
