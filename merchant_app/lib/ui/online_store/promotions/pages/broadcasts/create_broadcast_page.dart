import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/settings/promotion_settings_page.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:quiver/strings.dart';

import '../../../../../features/ecommerce_shared/models/shared/form_view_model.dart';
import '../../../../../features/ecommerce_shared/models/store/broadcast.dart';
import '../../../../../common/presentaion/components/form_fields/string_form_field.dart';

class CreateBroadcastPage extends StatefulWidget {
  static const String route = 'promotions/create-broadcast';

  const CreateBroadcastPage({Key? key}) : super(key: key);

  @override
  State<CreateBroadcastPage> createState() => _CreateBroadcastPageState();
}

class _CreateBroadcastPageState extends State<CreateBroadcastPage> {
  ManageStoreVM? _vm;
  bool? _uploading;

  void setUploading(bool value) {
    _uploading = value;
    _rebuild();
  }

  final List<FocusNode> _nodes = [FocusNode(), FocusNode()];

  final expandedMargin = const EdgeInsets.only(
    top: 4,
    bottom: 4,
    left: 16,
    right: 12,
  );

  final formKey = GlobalKey<FormState>();
  Broadcast? item;

  @override
  void initState() {
    _uploading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (ctx, vm) {
        _vm ??= vm;
        item ??= Broadcast.usingState(vm.store!.state);

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
    title: 'Make Broadcast',
    footerActions: <Widget>[
      if (_vm!.isLoading == false && _uploading == false)
        ButtonBar(
          buttonHeight: 48,
          buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
          children: <Widget>[
            ElevatedButton(
              // TODO(lampian): fix
              //color: Theme.of(context).colorScheme.secondary,
              child: const Text('Next'),
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState!.save();
                  // _vm.isLoading = true;
                  _rebuild();

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => PromotionSettingsPage(item: item),
                    ),
                  );
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
            if (_vm!.isLoading! || _uploading!) const LinearProgressIndicator(),
            KeyboardActions(
              config: keyboardConfig(context, _nodes),
              disableScroll: true,
              child: Container(child: form(context)),
            ),
          ],
        ),
      ),
    ),
  );

  SizedBox featureImage(context, ManageStoreVM? vm) => SizedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        isBlank(item!.imageUrl)
            ? SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: InkWell(
                    onTap: () async {
                      setUploading(true);

                      var result = await FileManager().chooseAndUploadImage(
                        context,
                        itemId: item!.id,
                        sectionId: 'broadcasts',
                        groupId: item!.storeId,
                      );
                      if (result != null) {
                        item!.imageUrl = result.downloadUrl;
                      }
                      setUploading(false);
                    },
                    child: const Material(
                      child: Center(child: Icon(Icons.add, size: 64)),
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: InkWell(
                    onTap: () async {
                      setUploading(true);
                      var result = await FileManager().chooseAndUploadImage(
                        context,
                        itemId: item!.id,
                        sectionId: 'broadcasts',
                        groupId: item!.storeId,
                      );

                      if (result != null) {
                        item!.imageUrl = result.downloadUrl;
                      }
                      setUploading(false);
                    },
                    child: Material(
                      child: FirebaseImage(
                        imageAddress: item!.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
      ],
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
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: featureImage(context, _vm),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: StringFormField(
              initialValue: item!.title ?? '',
              hintText: 'Title',
              key: const Key('title'),
              labelText: 'Title',
              isRequired: true,
              focusNode: _nodes[0],
              nextFocusNode: _nodes[1],
              inputAction: TextInputAction.next,
              onSaveValue: (val) {
                item!.title = val;
              },
              onFieldSubmitted: (val) {
                item!.title = val;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: StringFormField(
              maxLines: 5,
              initialValue: item!.message ?? '',
              hintText: 'We are Relocating',
              key: const Key('message'),
              focusNode: _nodes[1],
              labelText: 'Message',
              isRequired: true,
              inputAction: TextInputAction.done,
              onSaveValue: (val) {
                item!.message = val;
              },
              onFieldSubmitted: (val) {
                item!.message = val;
              },
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
}
