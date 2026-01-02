import 'package:quiver/strings.dart';
import '../search/search_attribute.dart';

class ProductSearchParams {
  ProductSearchParams({
    this.distance = 10,
    this.attributes = const [],
    this.categories = const [],
    this.subCategories = const [],
    this.labels = const [],
    this.lastPosition = 0,
    this.totalCount = 0,
    this.searchName,
    this.searchOnSale = false,
    this.searchFeatured = false,
    this.searchNew = false,
    this.searchFavourites = false,
  });

  String? searchName;

  double distance;

  List<FilterAttribute> attributes;

  List<String?> categories;

  List<String?> subCategories;

  List<String> labels;

  //on each new search this must be set to 0
  //used for paging
  int lastPosition;

  //on each distinct search this total must be set
  int totalCount;

  bool searchOnSale;

  bool searchFeatured;

  bool searchNew;

  bool searchFavourites;

  bool get hasSearchValues =>
      isNotBlank(searchName) ||
      (attributes.isNotEmpty) ||
      (categories.isNotEmpty) ||
      ((subCategories.isNotEmpty) && (categories.isNotEmpty)) ||
      (labels.isNotEmpty) ||
      searchOnSale ||
      searchFeatured ||
      searchNew ||
      searchFavourites;
}
