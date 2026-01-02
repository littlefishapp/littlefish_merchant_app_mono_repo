import 'package:littlefish_merchant/models/stock/stock_take_item.dart';

class StockRunHelper {
  static const String stockAdjustment = 'Stock Adjustment';
  static const String stolen = 'Stolen Stock';
  static const String damaged = 'Damaged Stock';
  static const String returned = 'Returned Stock';
  static const String otherIncrease = 'Other Stock Increase';
  static const String otherDecrease = 'Other Stock Decrease';
  static const String lost = 'Lost Stock';

  static const Map<String, StockRunType> reasonMap = {
    stockAdjustment: StockRunType.reCount,
    stolen: StockRunType.theft,
    damaged: StockRunType.damagedStock,
    returned: StockRunType.returnedStock,
    otherIncrease: StockRunType.otherIncrease,
    otherDecrease: StockRunType.otherDecrease,
    lost: StockRunType.loss,
  };

  static const List<String> stockIncreaseDisplayReasons = [
    stockAdjustment,
    returned,
  ];

  static const List<String> stockDecreaseDisplayReasons = [damaged, stolen];

  static bool isDecreaseByReason(StockRunType type) {
    switch (type) {
      case StockRunType.damagedStock:
      case StockRunType.loss:
      case StockRunType.otherDecrease:
      case StockRunType.theft:
        return true;
      default:
        return false;
    }
  }

  static bool isRecount(StockRunType type) => type == StockRunType.reCount;

  static bool isIncreaseByReason(StockRunType type) {
    switch (type) {
      case StockRunType.otherIncrease:
      case StockRunType.returnedStock:
        return true;
      default:
        return false;
    }
  }
}
