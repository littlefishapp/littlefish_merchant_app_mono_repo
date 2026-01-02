import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/pages/stock_take_page.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/ui/inventory/view_models/view_models.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class StockIntroPage extends StatefulWidget {
  static const String route = 'inventory/Stock-Info';

  const StockIntroPage({Key? key}) : super(key: key);

  @override
  State<StockIntroPage> createState() => _StockIntroPageState();
}

class _StockIntroPageState extends State<StockIntroPage> {
  bool _enablePage = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StockTakeVM>(
      converter: (store) {
        return StockTakeVM.fromStore(store);
      },
      builder: (BuildContext context, StockTakeVM vm) {
        return AppScaffold(
          //backgroundColor: Theme.of(context).colorScheme.background,
          title: 'Stock take steps',
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: informationLayout(context, vm),
          ),
          persistentFooterButtons: [
            Column(
              children: [
                _dontShowAgainCheckbox(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ButtonPrimary(
                    text: 'Start Stock Take',
                    onTap: (qa) => Navigator.pushReplacementNamed(
                      globalNavigatorKey.currentContext!,
                      StockTakePage.route,
                      arguments: null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Column informationLayout(BuildContext context, StockTakeVM vm) =>
      Column(children: <Widget>[...content()]);

  Widget _dontShowAgainCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          activeColor: Theme.of(context).extension<AppliedTextIcon>()?.primary,
          value: _enablePage ? false : true,
          onChanged: (aq) {
            setState(() {
              _enablePage = aq! ? false : true;
              saveKeyToPrefsBool('enableNewStockHelper', _enablePage);
            });
          },
        ),
        context.paragraphMedium(
          "Don't show again",
          color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
        ),
      ],
    );
  }

  List content() {
    return [
      const SizedBox(height: 24),
      Material(
        color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 56,
            width: 56,
            child: Icon(
              Icons.checklist,
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
      context.headingSmall('New Stock Take', isSemiBold: true),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: context.labelMedium(
          'Take inventory of your products or record product adjustments',
          color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
          isBold: true,
        ),
      ),

      _itemTile(
        '1. Select Product',
        'Add product by scanning their barcode or select from existing products.',
        Icons.add_circle_outline_rounded,
      ),

      _itemTile(
        '2. Confirm Product Stock Level',
        'Confirm the current level or indicate adjustments & provide a reason.',
        Icons.task_alt,
      ),

      _itemTile(
        '3. Add To List',
        'Product stock update will be added to the Stock Take list.',
        Icons.playlist_add_circle_outlined,
      ),

      _itemTile(
        '4. Repeat Until Finished',
        'Continue adding & updating products then tap "Finish" when you are finished.',
        Icons.repeat_rounded,
      ),

      // ]),),
    ];
  }

  Widget _itemTile(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(
              context,
            ).extension<AppliedSurface>()?.brand,
            child: Icon(
              icon,
              size: 24,
              color: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.inversePrimary,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              context.labelMedium(
                title,
                color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
                isBold: true,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  description,
                  style: context.appThemeTextFormLabel!.copyWith(
                    color: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//   tileColor: Theme.of(context).colorScheme.background,
//   leading: CircleAvatar(
//     radius: 24,
//     backgroundColor: Theme.of(context).colorScheme.secondary,
//     child: Icon(
//       icon,
//       size: 24,
//       color: Colors.white,
//     ),
//   ),
//   title: Padding(
//     padding: const EdgeInsets.only(bottom: 12.0),
//     child: Text(
//       title,
//       style: const TextStyle(
//         fontWeight: FontWeight.bold,
//         color: Colors.black,
//         fontSize: 16,
//       ),
//     ),
//   ),
//   subtitle: Text(
//     description,
//     style: const TextStyle(
//       color: Colors.grey,
//       fontSize: 14,
//     ),
//   ),
// );

//}
