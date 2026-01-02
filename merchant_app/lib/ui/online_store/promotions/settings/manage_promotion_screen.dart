// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:quiver/strings.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../features/ecommerce_shared/models/shared/form_view_model.dart';
import '../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';

class ManagePromotionScreen extends StatefulWidget {
  final bool isPreview;
  final bool manage;
  final Promotion item;

  const ManagePromotionScreen({
    Key? key,
    required this.item,
    this.isPreview = false,
    this.manage = false,
  }) : super(key: key);

  @override
  State<ManagePromotionScreen> createState() => _ManagePromotionScreenState();
}

class _ManagePromotionScreenState extends State<ManagePromotionScreen> {
  ManageStoreVM? _vm;
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

  final formKey = GlobalKey<FormState>();
  late Promotion item;

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

        return scaffold();
      },
    );
  }

  AppSimpleAppScaffold scaffold() => AppSimpleAppScaffold(
    title: 'Promotion',
    footerActions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (widget.isPreview == false &&
              _vm!.isLoading == false &&
              _uploading == false)
            ButtonBar(
              buttonHeight: 48,
              buttonMinWidth: widget.manage
                  ? MediaQuery.of(context).size.width * 0.42
                  : MediaQuery.of(context).size.width * 0.90,
              children: <Widget>[
                if (!item.isExpired && item.isCancelled == false)
                  ElevatedButton(
                    // TODO(lampian): fix
                    // color: Colors.red,
                    child: const Text('Cancel Promotion'),
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        _vm!.isLoading = true;

                        try {
                          _rebuild();
                          await _vm!.cancelPromotion(item);
                          _vm!.isLoading = false;

                          _rebuild();
                          Navigator.of(context).pop();
                          showMessageDialog(
                            context,
                            'Promotion has been Cancelled',
                            Icons.thumb_up,
                          );
                        } catch (e) {
                          _vm!.isLoading = false;
                          showErrorDialog(context, e);
                          _rebuild();
                        }
                      }
                    },
                  ),
                if (item.isExpired)
                  ElevatedButton(
                    // TODO(lampian): fix
                    // color: Colors.red,
                    child: const Text('Delete Promotion'),
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();

                        try {
                          _vm!.isLoading = true;

                          _rebuild();
                          await _vm!.deletePromotion(item);
                          _vm!.isLoading = false;

                          Navigator.of(context).pop();
                          showMessageDialog(
                            context,
                            'Your Item has been deleted!',
                            Icons.thumb_up,
                          );
                          _rebuild();
                        } catch (e) {
                          _vm!.isLoading = false;
                          showErrorDialog(context, e);
                          _rebuild();
                        }
                      }
                    },
                  ),
                if (widget.manage)
                  ElevatedButton(
                    // TODO(lampian): fix
                    // color: Theme.of(context).colorScheme.secondary,
                    child: const Text('Save'),
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();

                        try {
                          _vm!.isLoading = true;

                          _rebuild();
                          await _vm!.createPromotion(item);
                          _vm!.isLoading = false;

                          Navigator.of(context).pop();
                          showMessageDialog(
                            context,
                            'action completed successfully!',
                            Icons.thumb_up,
                          );
                          _rebuild();
                        } catch (e) {
                          _vm!.isLoading = false;
                          showErrorDialog(context, e);
                          _rebuild();
                        }
                      }
                    },
                  ),
              ],
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
            Container(child: form(context)),
          ],
        ),
      ),
    ),
  );

  SizedBox featureImage(context, ManageStoreVM? vm) => SizedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        isBlank(item.imageUrl)
            ? SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: InkWell(
                    onTap: widget.isPreview || widget.manage
                        ? null
                        : () async {
                            setUploading(true);
                            var result = await FileManager()
                                .chooseAndUploadImage(
                                  context,
                                  itemId: item.id,
                                  sectionId: 'promotions',
                                  groupId: item.storeInfo!.storeId,
                                );
                            if (result != null) {
                              item.imageAddress = result.fullPath;
                              item.imageUrl = result.downloadUrl;
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
                    onTap: widget.isPreview || widget.manage
                        ? null
                        : () async {
                            setUploading(true);

                            var result = await FileManager()
                                .chooseAndUploadImage(
                                  context,
                                  itemId: item.id,
                                  sectionId: 'promotions',
                                  groupId: item.storeInfo!.storeId,
                                );
                            if (result != null) {
                              item.imageAddress = result.fullPath;
                              item.imageUrl = result.downloadUrl;
                            }

                            setUploading(false);
                          },
                    child: Material(
                      child: FirebaseImage(
                        imageAddress: item.imageUrl,
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
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Text(
              widget.isPreview
                  ? '${item.title}'
                  : widget.manage
                  ? ''
                  : 'Create Post',
              style: const TextStyle(fontSize: 24),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: featureImage(context, _vm),
          ),
          if (!widget.isPreview)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: StringFormField(
                enabled: !widget.isPreview,
                initialValue: item.title ?? '',
                hintText: 'Big News',
                key: const Key('title'),
                labelText: 'Title',
                isRequired: true,
                onSaveValue: (val) {
                  item.title = val;
                },
                onFieldSubmitted: (val) {
                  item.title = val;
                },
              ),
            ),
          !widget.isPreview
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: StringFormField(
                    enabled: !widget.isPreview,
                    maxLines: 5,
                    initialValue: item.message ?? '',
                    hintText: 'We are Relocating',
                    key: const Key('message'),
                    labelText: 'Message',
                    isRequired: true,
                    onSaveValue: (val) {
                      item.message = val;
                    },
                    onFieldSubmitted: (val) {
                      item.message = val;
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
                          hintText: item.message,
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
