// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// removed ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/online_store/shared/store_card.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

import '../../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../../features/ecommerce_shared/models/shared/form_view_model.dart';
import '../../../../../features/ecommerce_shared/models/store/store.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/long_text.dart';

class FeaturedStorePage extends StatefulWidget {
  static const String route = 'promotions/feature-store';

  const FeaturedStorePage({Key? key}) : super(key: key);

  @override
  State<FeaturedStorePage> createState() => _FeaturedStorePageState();
}

class _FeaturedStorePageState extends State<FeaturedStorePage> {
  ManageStoreVM? _vm;

  final AsyncMemoizer<FeaturedStore?> _memoizer = AsyncMemoizer();

  final expandedMargin = const EdgeInsets.only(
    top: 4,
    bottom: 4,
    left: 16,
    right: 12,
  );

  final formKey = GlobalKey<FormState>();
  FeaturedStore? item;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (ctx, vm) {
        _vm ??= vm;

        item ??= FeaturedStore.fromStore(vm.item!);
        return vm.item!.isFeatured!
            ? FutureBuilder(
                future: _memoizer.runOnce(() async {
                  return await vm.getFeaturedStore();
                }),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const AppSimpleAppScaffold(
                      title: 'Feature Store',
                      body: LinearProgressIndicator(),
                    );
                  }

                  item = snapshot.data as FeaturedStore;

                  return scaffold();
                },
              )
            : scaffold();
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
    title: 'Feature Store',
    footerActions: <Widget>[
      if (_vm!.item!.isFeatured == true && _vm!.isLoading == false)
        ButtonBar(
          buttonHeight: 48,
          buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
          children: <Widget>[
            ElevatedButton(
              // TODO(lampian): fix
              // color: Colors.red,
              child: const Text('Cancel'),
              onPressed: () async {
                _vm!.isLoading = true;
                _rebuild();
                try {
                  await _vm!.deletedFeaturedStore(item!, context);
                  _vm!.store!.dispatch(SetCurrentStoreFeaturedAction(false));
                  _vm!.isLoading = false;
                  Navigator.of(context).pop();
                  showMessageDialog(
                    context,
                    'Your store is no longer being featured',
                    Icons.thumb_up,
                  );
                  _rebuild();
                } catch (e) {
                  _vm!.isLoading = false;
                  _rebuild();
                }
              },
            ),
          ],
        ),
      if (_vm!.item!.isFeatured != true && _vm!.isLoading == false)
        ButtonBar(
          buttonHeight: 48,
          buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
          children: <Widget>[
            ElevatedButton(
              // TODO(lampian): fix
              // color: Theme.of(context).colorScheme.primary,
              child: const Text(
                'Feature Store',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState!.save();
                  if (item?.duration == null) {
                    showMessageDialog(
                      context,
                      'Please choose a duration',
                      LittleFishIcons.error,
                    );
                  } else {
                    _vm!.isLoading = true;
                    _rebuild();
                    try {
                      item!.startDate = DateTime.now();
                      item!.endDate = item!.startDate!.add(
                        Duration(days: item!.duration!),
                      );
                      await _vm!.saveFeaturedStore(item!, context);
                      _vm!.isLoading = false;
                      _vm!.store!.dispatch(SetCurrentStoreFeaturedAction(true));
                      Navigator.of(context).pop();
                      showMessageDialog(
                        context,
                        'You are now a featured store',
                        Icons.thumb_up,
                      );

                      _rebuild();
                    } catch (e) {
                      _vm!.isLoading = false;
                      _rebuild();
                    }
                  }
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

  Form form(context) {
    final BasicFormModel formModel = BasicFormModel(formKey);

    var formFields = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_vm!.item!.isFeatured == true)
                  Text(
                    'Active'.toUpperCase(),
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                if (_vm!.item!.isFeatured != true)
                  const Text(
                    'Inactive',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Your shop will be viewable directly on the customers home page, giving you more exposure.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: StoreCard(store: _vm!.item),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _vm!.item!.isFeatured!
                ? ListTile(
                    tileColor: Theme.of(context).colorScheme.background,
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Duration'),
                    subtitle: Text('${item?.duration} ${"Days"}'),
                  )
                : ListTile(
                    tileColor: Theme.of(context).colorScheme.background,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text('Duration'),
                        const SizedBox(height: 4),
                        const LongText(
                          'How long your store will be featured for',
                        ),
                        Slider(
                          onChanged: (value) {
                            item!.duration = value.toInt();

                            _rebuild();
                          },
                          value: item!.duration?.toDouble() ?? 7,
                          min: 1,
                          max: 14,
                          divisions: 14,
                        ),
                        LongText(
                          '${item?.duration ?? 7} ${"Days"}',
                          fontSize: null,
                          textColor: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    ];

    return Form(
      key: formModel.formKey,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }

  Widget timelineCard(
    context, {
    required String title,
    required String description,
    required String headerImage,
    Function? onTap,
    String? tapTitle,
  }) => CardNeutral(
    child: SizedBox(
      height: 240,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 156,
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(headerImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              const SizedBox(height: 8),
              ListTile(
                tileColor: Theme.of(context).colorScheme.background,
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(description),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
