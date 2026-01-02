// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:quiver/strings.dart';

import '../../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/app_progress_indicator.dart';
import '../posts/create_post_page.dart';

class ReviewPromotionPage extends StatefulWidget {
  final Promotion? item;

  const ReviewPromotionPage({Key? key, this.item}) : super(key: key);

  @override
  State<ReviewPromotionPage> createState() => _ReviewPromotionPageState();
}

class _ReviewPromotionPageState extends State<ReviewPromotionPage> {
  ManageStoreVM? _vm;

  Promotion? item;

  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (ctx, vm) {
        _vm ??= vm;
        if (vm.isLoading!) return const AppProgressIndicator();

        return scaffold();
      },
    );
  }

  _rebuild() {
    if (mounted) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  AppSimpleAppScaffold scaffold() => AppSimpleAppScaffold(
    title: 'Review Promotion',
    footerActions: [
      ButtonBar(
        buttonHeight: 48,
        buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
        children: <Widget>[
          if (_vm!.isLoading == false)
            ElevatedButton(
              // TODO(lampian): fix
              // color: Theme.of(context).colorScheme.secondary,
              child: const Text('Promote'),
              onPressed: () async {
                _vm!.isLoading = true;
                _rebuild();
                try {
                  item!.dateRun = item!.startDate = DateTime.now();
                  item!.endDate = item!.startDate!.add(
                    Duration(days: item!.duration!),
                  );

                  await _vm!.createPromotion(item!);
                  _vm!.isLoading = false;
                  showMessageDialog(
                    context,
                    'Promotion has been posted',
                    LittleFishIcons.info,
                  ).then((value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // _rebuild();
                  });
                  // Navigator.of(context).pop();
                } catch (e) {
                  _vm!.isLoading = false;
                  showMessageDialog(
                    context,
                    (e as dynamic).message,
                    LittleFishIcons.info,
                  );
                  _rebuild();
                }
              },
            ),
        ],
      ),
    ],
    body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            if (_vm!.isLoading!) const LinearProgressIndicator(),
            Container(child: form(context)),
          ],
        ),
      ),
    ),
  );
  MediaQuery form(context) {
    var formFields = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Please ensure that all the details are correct',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          CardNeutral(
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              leading: isBlank(item!.imageUrl)
                  ? SizedBox(
                      height: 44,
                      width: 44,
                      child: FirebaseImage(
                        imageAddress: _vm!.item!.logoUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(
                      height: 44,
                      width: 44,
                      child: FirebaseImage(
                        imageAddress: item!.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
              title: const Text('Preview'),
              subtitle: const Text('This is how your post will look'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                        CreatePostPage(isPreview: true, item: item),
                  ),
                );
              },
            ),
          ),
          CardNeutral(
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              leading: SizedBox(
                height: 28,
                width: 28,
                child: Image.asset(ImageConstants.profileDefault),
              ),
              title: const Text('Audience'),
              subtitle: Text(
                item!.audience!.audienceType.toString().split('.').last,
              ),
              // trailing: Icon(
              //   Icons.arrow_forward_ios,
              //   size: 16,
              // ),
            ),
          ),
          CardNeutral(
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Duration'),
              subtitle: Text('${item!.duration} ${"Days".toLowerCase()}'),
              // trailing: Icon(
              //   Icons.arrow_forward_ios,
              //   size: 16,
              // ),
            ),
          ),
        ],
      ),
    ];

    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: formFields,
      ),
    );
  }
}
