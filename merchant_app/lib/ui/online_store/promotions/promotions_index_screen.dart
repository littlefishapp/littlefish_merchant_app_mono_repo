import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/icon_constants.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/broadcasts/create_broadcast_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/featured/featured_store_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/posts/create_post_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/promotions/create_promotion_page.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/settings/manage_promotions_screen.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import '../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../features/ecommerce_shared/models/store/store.dart';
import '../../../common/presentaion/components/long_text.dart';

class PromotionsIndexScreen extends StatefulWidget {
  static const String route = '/promotions/index';

  const PromotionsIndexScreen({Key? key}) : super(key: key);

  @override
  State<PromotionsIndexScreen> createState() => _PromotionsIndexScreenState();
}

class _PromotionsIndexScreenState extends State<PromotionsIndexScreen> {
  Store? item;

  ManageStoreVM? _vm;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      onInit: (store) => store.dispatch(ClearSelectedPromotionAction()),
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (BuildContext context, ManageStoreVM vm) {
        item ??= vm.item;
        _vm ??= vm;
        if (_vm!.selectedPromotion != null) {
          _vm!.store!.dispatch(ClearSelectedPromotionAction());
        }

        return AppSimpleAppScaffold(
          title: 'Promotions',
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 12),
              //   child: Text(
              //     S.of(context).promotionsLabel,
              //     style: TextStyle(fontSize: 24),
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              //   child: Text(
              //     S.of(context).getPeopleTalkingText,
              //   ),
              // ),
              // SizedBox(height: 8),
              Container(
                child: vm.isSetupComplete
                    ? _renderLayout(context, vm)
                    : Center(
                        child: CardNeutral(
                          child: ListTile(
                            tileColor: Theme.of(context).colorScheme.background,
                            title: const Text('Please complete store setup'),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container _renderLayout(context, ManageStoreVM vm) {
    var iconColor = Theme.of(
      context,
    ).colorScheme.secondary; //vm.isDarkMode ? Colors.white :

    var productCards = [
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        dense: true,
        title: const Text('Feature Store'),
        subtitle: const LongText(
          'Put your store front and center',
          // style: TextStyle(fontSize: 12),
        ),
        leading: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.15 >= 48
              ? 64
              : MediaQuery.of(context).size.width * 0.15,
          height: (MediaQuery.of(context).size.width * 0.15) * 0.65,
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            FontAwesomeIcons.certificate,
            size: 18,
            color: vm.item!.isFeatured! ? Colors.green : Colors.white,
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(FeaturedStorePage.route);
        },
      ),
      const CommonDivider(),
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        dense: true,
        title: const Text('Create Promotion'),
        subtitle: const LongText(
          'Promote your products, coupons, categories and more',
          // style: TextStyle(fontSize: 12),
        ),
        leading: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.15 >= 48
                ? 64
                : MediaQuery.of(context).size.width * 0.15,
            height: (MediaQuery.of(context).size.width * 0.15) * 0.65,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Image.asset(
              IconConstants.promoteIcon,
              height: 20,
              width: 20,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(CreatePromotionPage.route);
          },
        ),
        onTap: () {
          Navigator.of(context).pushNamed(CreatePromotionPage.route);
        },
      ),
      const CommonDivider(),
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        dense: true,
        title: const Text('Create Post'),
        subtitle: const LongText(
          'Post to your timeline',
          // style: TextStyle(fontSize: 12),
        ),
        leading: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.15 >= 48
                ? 64
                : MediaQuery.of(context).size.width * 0.15,
            height: (MediaQuery.of(context).size.width * 0.15) * 0.65,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              FontAwesomeIcons.plus,
              // size: 18,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(CreatePostPage.route);
          },
        ),
        onTap: () {
          Navigator.of(context).pushNamed(CreatePostPage.route);
        },
      ),
      const CommonDivider(),
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        dense: true,
        title: const Text('Make Broadcast'),
        subtitle: const LongText(
          'Send a notification to your followers',
          // style: TextStyle(fontSize: 12),
        ),
        leading: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.15 >= 48
                ? 64
                : MediaQuery.of(context).size.width * 0.15,
            height: (MediaQuery.of(context).size.width * 0.15) * 0.65,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.share),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(CreateBroadcastPage.route);
          },
        ),
        onTap: () {
          Navigator.of(context).pushNamed(CreateBroadcastPage.route);
        },
      ),
      const CommonDivider(),
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        dense: true,
        subtitle: const LongText('Manage all your Promotions'),
        leading: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.15 >= 48
                ? 64
                : MediaQuery.of(context).size.width * 0.15,
            height: (MediaQuery.of(context).size.width * 0.15) * 0.65,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.edit),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (c) => const ManagePromotionsScreen()),
          ),
        ),
        title: const Text('Promotions'),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (c) => const ManagePromotionsScreen()),
        ),
      ),
      const CommonDivider(),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: productCards,
      ),
    );
  }
}
