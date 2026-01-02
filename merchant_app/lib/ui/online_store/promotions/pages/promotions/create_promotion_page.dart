import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/promotions/review_promotion_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/settings/audience_select_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/settings/promotion_duration_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/settings/promotion_type_page.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:quiver/strings.dart';

import '../../../../../features/ecommerce_shared/models/store/broadcast.dart';
import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/common_divider.dart';

class CreatePromotionPage extends StatefulWidget {
  static const String route = 'promotions/create-promotion';

  const CreatePromotionPage({Key? key}) : super(key: key);

  @override
  State<CreatePromotionPage> createState() => _CreatePromotionPageState();
}

class _CreatePromotionPageState extends State<CreatePromotionPage> {
  Promotion? _item;
  @override
  void initState() {
    _item = Promotion.usingState(AppVariables.store!.state, true);

    _item!.commStream = CommunicationStream(
      email: false,
      sms: false,
      push: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (ctx, vm) {
        if (_item == null && vm.selectedPromotion != null) {
          _item = vm.selectedPromotion;
        }
        // if (item == null) {
        //   if (vm.selectedPromotion == null)
        //     item = Promotion.usingState(
        //       vm.store!.state,
        //       true,
        //     );
        //   else
        //     item = vm.selectedPromotion;
        // }

        return AppSimpleAppScaffold(
          title: 'Create Promotion',
          footerActions: <Widget>[
            ButtonBar(
              buttonHeight: 48,
              buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
              children: <Widget>[
                ElevatedButton(
                  // TODO(lampian): fix
                  // color: Theme.of(context).colorScheme.secondary,
                  child: const Text('Reviews'),
                  onPressed: () async {
                    if (_item!.type != null &&
                        isNotBlank(_item!.title) &&
                        isNotBlank(_item!.message)) {
                      if (_item!.audience != null &&
                          _item!.audience!.audienceType != null) {
                        if (_item!.duration != null) {
                          vm.store!.dispatch(SetSelectedPromotionAction(_item));

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  ReviewPromotionPage(item: _item),
                            ),
                          );
                        } else {
                          showMessageDialog(
                            context,
                            'Please ensure that you have chose a promotion duration',
                            LittleFishIcons.error,
                          );
                        }
                      } else {
                        showMessageDialog(
                          context,
                          'Please ensure that you have selected an audience',
                          LittleFishIcons.error,
                        );
                      }
                    } else {
                      showMessageDialog(
                        context,
                        'Please ensure that you have selected an item',
                        LittleFishIcons.error,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
          body: SafeArea(
            child: Column(
              children: [
                // CommonDivider(),
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: const Text('Promotion Type'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _item!.type == null
                          ? Text(
                              'None'.toUpperCase(),
                              style: const TextStyle(color: Colors.grey),
                            )
                          : Text(
                              _item!.type
                                  .toString()
                                  .split('.')
                                  .last
                                  .toUpperCase(),
                              style: const TextStyle(color: Colors.green),
                            ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () async {
                    // var result = await Navigator.of(context).push(
                    //   CustomRoute(
                    //     builder: (ctx) => PromotionTypePage(item: _item),
                    //   ),
                    // );
                    var result = await showPopupDialog(
                      context: context,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      content: PromotionTypePage(item: _item),
                    );

                    if (result != null) {
                      setState(() {
                        _item = result;
                      });
                    }

                    // _rebuild();
                  },
                ),
                const SizedBox(height: 4),
                const CommonDivider(),
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: const Text('Audience'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _item!.audience == null ||
                              _item!.audience!.audienceType == null
                          ? Text(
                              'None'.toUpperCase(),
                              style: const TextStyle(color: Colors.grey),
                            )
                          : Text(
                              _item!.audience!.audienceType
                                  .toString()
                                  .split('.')
                                  .last
                                  .toUpperCase(),
                              style: const TextStyle(color: Colors.green),
                            ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () async {
                    // var promotion = await Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (ctx) => ,
                    //   ),
                    // );
                    var promotion = await showPopupDialog(
                      context: context,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      content: AudienceSelectPage(item: _item),
                    );

                    if (promotion != null) {
                      _item!.audience = promotion.audience;
                    }

                    _rebuild();
                  },
                ),
                const CommonDivider(),
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: const Text('Duration'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _item!.duration == null
                          ? Text(
                              'None'.toUpperCase(),
                              style: const TextStyle(color: Colors.grey),
                            )
                          : Text(
                              '${_item!.duration} ${"Days"}',
                              style: const TextStyle(color: Colors.green),
                            ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () async {
                    // await Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (ctx) => PromotionDurationPage(item: _item),
                    //   ),
                    // );
                    await showPopupDialog(
                      context: context,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      content: PromotionDurationPage(item: _item),
                    );

                    // if (result != null) item = result;
                    _rebuild();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // validatePromo() {
  //   if(item.)
  // }

  _rebuild() {
    if (mounted) setState(() {});
    // else
    // setState(() {});
  }
}
