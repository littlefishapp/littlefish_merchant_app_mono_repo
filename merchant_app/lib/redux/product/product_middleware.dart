import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';

class ProductMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final LoggerService logger = LittleFishCore.instance.get<LoggerService>();

    if (action is ProductSelectAction) {
      String? productId = action.value.id;
      if (productId != null && productId.isNotEmpty) {
        store.dispatch(ClearProductWithOptionsAction());
        store.dispatch(getFullProductById(productId: productId));
      } else {
        logger.debug(
          'ProductMiddleware',
          'Could not fetch product with options: Product ID is null or empty',
        );
      }
    }
  }
}
