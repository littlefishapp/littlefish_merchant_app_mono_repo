import '../../../../models/enums.dart';

class SortByType {
  late final List<SortBy> order;

  SortByType(this.order);
}

class ProductSortBy extends SortByType {
  ProductSortBy() : super([SortBy.name, SortBy.createdDate, SortBy.price]);

  SortBy? get name => order.contains(SortBy.name) ? SortBy.name : null;

  SortBy? get createdDate =>
      order.contains(SortBy.createdDate) ? SortBy.createdDate : null;

  SortBy? get price => order.contains(SortBy.price) ? SortBy.price : null;
}

class BusinessDataItemSortBy extends SortByType {
  BusinessDataItemSortBy() : super([SortBy.name, SortBy.createdDate]);

  SortBy? get name => order.contains(SortBy.name) ? SortBy.name : null;

  SortBy? get createdDate =>
      order.contains(SortBy.createdDate) ? SortBy.createdDate : null;
}
