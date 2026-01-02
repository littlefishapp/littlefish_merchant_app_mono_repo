// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_actions.dart';
import 'package:littlefish_merchant/ui/products/discounts/widgets/discounts_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

class DiscountSelectPage extends StatelessWidget {
  final bool isEmbedded;

  const DiscountSelectPage({Key? key, this.isEmbedded = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      onInit: (store) => store.dispatch(getDiscounts(refresh: false)),
      builder: (ctx, store) => AppSimpleAppScaffold(
        title: 'Select Discount',
        isEmbedded: isEmbedded,
        body: DiscountsList(
          readOnly: true,
          onTap: (discount) {
            Navigator.of(context).pop(discount);
          },
        ),
      ),
    );
  }
}
