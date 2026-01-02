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

import '../../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../../features/ecommerce_shared/models/shared/form_view_model.dart';
import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../common/presentaion/components/form_fields/string_form_field.dart';

class CreatePostPage extends StatefulWidget {
  static const String route = 'promotions/create-post';

  final bool isPreview;

  final Promotion? item;

  const CreatePostPage({Key? key, this.isPreview = false, this.item})
    : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  ManageStoreVM? _vm;
  final formKey = GlobalKey<FormState>();

  bool _uploading = false;

  void setUploading(bool value) {
    _uploading = value;
    _rebuild();
  }

  _rebuild() {
    if (mounted) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  final List<FocusNode> _nodes = [FocusNode(), FocusNode()];

  Promotion? item;

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
        if (item == null) {
          if (widget.item != null) {
            item = widget.item;
          } else {
            item = Promotion.usingState(
              vm.store!.state,
              false,
              promoType: PromotionType.post,
            );
          }
        }

        return scaffold();
      },
    );
  }

  AppSimpleAppScaffold scaffold() => AppSimpleAppScaffold(
    title: widget.isPreview ? '${item!.title}' : 'Create Post',
    footerActions: <Widget>[
      if (widget.isPreview == false && !_vm!.isLoading! && _uploading == false)
        ButtonBar(
          buttonHeight: 48,
          buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
          children: <Widget>[
            if (_vm!.isLoading == false)
              ElevatedButton(
                // TODO(lampian): fix
                // color: Theme.of(context).colorScheme.secondary,
                child: const Text('Next'),
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState!.save();

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
            if (_vm!.isLoading! || _uploading) const LinearProgressIndicator(),
            KeyboardActions(
              disableScroll: true,
              config: keyboardConfig(context, _nodes),
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
                    onTap: widget.isPreview
                        ? null
                        : () async {
                            setUploading(true);

                            var result = await FileManager()
                                .chooseAndUploadImage(
                                  context,
                                  itemId: item!.id,
                                  sectionId: 'promotions',
                                  groupId: item!.storeInfo!.storeId,
                                );
                            if (result != null) {
                              item!.imageAddress = result.fullPath;
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
                    onTap: widget.isPreview
                        ? null
                        : () async {
                            setUploading(true);

                            var result = await FileManager()
                                .chooseAndUploadImage(
                                  context,
                                  itemId: item!.id,
                                  sectionId: 'promotions',
                                  groupId: item!.storeInfo!.storeId,
                                );
                            if (result != null) {
                              item!.imageAddress = result.fullPath;
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
          if (!widget.isPreview)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: StringFormField(
                enabled: !widget.isPreview,
                initialValue: item!.title ?? '',
                hintText: 'Big News',
                key: const Key('title'),
                focusNode: _nodes[0],
                nextFocusNode: _nodes[1],
                labelText: 'Title',
                isRequired: true,
                inputAction: TextInputAction.next,
                onSaveValue: (val) {
                  item!.title = val;
                },
                onFieldSubmitted: (val) {
                  item!.title = val;
                },
              ),
            ),
          !widget.isPreview
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: StringFormField(
                    enabled: !widget.isPreview,
                    maxLines: 5,
                    initialValue: item!.message ?? '',
                    hintText: 'We are Relocating',
                    key: const Key('message'),
                    labelText: 'Message',
                    isRequired: true,
                    focusNode: _nodes[1],
                    inputAction: TextInputAction.done,
                    onSaveValue: (val) {
                      item!.message = val;
                    },
                    onFieldSubmitted: (val) {
                      item!.message = val;
                    },
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: CardNeutral(
                    // color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        enabled: false,
                        maxLines: 5,
                        maxLength: 1000,
                        decoration: InputDecoration.collapsed(
                          hintText: item!.message,
                        ),
                      ),
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
