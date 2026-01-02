class SemanticsConstants {
  /// [Sell_Screen]
  static String kWorkspaceSwitch = 'Workspace Switch Button';
  static String kMoreActionsMenu = 'More Actions Menu Button ';
  static String kBurgerMenu = 'Burger Menu Button';
  static String kQuickSellTop = 'Quick Sell Top Button';
  static String kQuickSellbottom = 'Quick Sell Bottom Button';
  static String kBarcodeScanner = 'Barcode Scanner Button';
  static String kEmptyCart = 'Empty Cart Button';
  static String kApplyDiscount = 'Apply Discount Button';

  /// [Multiple_Screens]
  static String kClear = 'Clear Button';
  static String kBack = 'Back Button';
  static String kRefresh = 'Refresh Button';
  static String kFilter = 'Filter Button';
  static String kDiscard = 'Discard Button';

  /// [List_Tiles_Products]
  static int _index = 0; // Private static variable
  static String get kProductListTile => 'Product List Tile, $_index';

  static String get kProductIncreaseQuantity =>
      'Increase Product Quantity Button $_index';
  static String get kProductIDecreaseQuantity =>
      'Increase Product Quantity Button $_index';
  static void setProductAndListTileIndex(int index) {
    _index = index;
  }
}
