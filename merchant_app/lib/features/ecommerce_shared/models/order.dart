class ProductItem {
  int? productId;
  String? name;
  int? quantity;
  String? total;

  ProductItem.fromJson(Map<String, dynamic> parsedJson) {
    productId = parsedJson['product_id'];
    name = parsedJson['name'];
    quantity = parsedJson['quantity'];
    total = parsedJson['total'];
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'total': total,
    };
  }

  ProductItem.fromMagentoJson(Map<String, dynamic> parsedJson) {
    productId = parsedJson['item_id'];
    name = parsedJson['name'];
    quantity = parsedJson['qty_ordered'];
    total = parsedJson['base_row_total'].toString();
  }
}

class OrderNote {
  int? id;
  String? dateCreated;
  String? note;

  OrderNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['date_created'];
    note = json['note'];
  }
}
