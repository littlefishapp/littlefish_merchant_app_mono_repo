import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/categories/view_models/category_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:uuid/uuid.dart';

import '../../../../../app/app.dart';
import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../../injector.dart';
import '../../../../../tools/network_image/flutter_network_image.dart';
import '../../../../products/categories/view_models/category_collection_vm.dart';

class OnlineStoreAddCategoryPage extends StatefulWidget {
  final bool isEmbedded;
  final CategoriesViewModel? vmParent;

  final bool displayProducts;

  final BuildContext? parentContext;

  final Function()? onCategoryUpdate;

  const OnlineStoreAddCategoryPage({
    Key? key,
    this.isEmbedded = false,
    this.vmParent,
    this.displayProducts = true,
    this.parentContext,
    this.onCategoryUpdate,
  }) : super(key: key);

  @override
  State<OnlineStoreAddCategoryPage> createState() =>
      _OnlineStoreAddCategoryPageState();
}

class _OnlineStoreAddCategoryPageState
    extends State<OnlineStoreAddCategoryPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StockCategory? category;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CategoryViewModel>(
      converter: (Store<AppState> store) =>
          CategoryViewModel.fromStore(
              store,
              context: widget.parentContext ?? context,
            )
            ..key = formKey
            ..form = FormManager(formKey),
      builder: (BuildContext context, CategoryViewModel vm) {
        if (category == null || category!.businessId == null) {
          category = StockCategory().copyWith(vm.item!);
          category?.imageUri = null;
        }
        category!.productCount = vm.item!.products!.length;

        return AppScaffold(
          enableProfileAction: false,
          displayBackNavigation: true,
          persistentFooterButtons: [addCategoryCancelBtn(context, vm)],
          title: 'New Category',
          body: vm.isLoading!
              ? const AppProgressIndicator()
              : AppTabBar(reverse: true, tabs: tabs(context, vm)),
        );
      },
    );
  }

  Widget addCategoryCancelBtn(BuildContext context, CategoryViewModel vm) {
    return FooterButtonsSecondaryPrimary(
      primaryButtonText: 'Add Category',
      onPrimaryButtonPressed: (c) async {
        category!.removedProducts = vm.item != null
            ? vm.item!.removedProducts
            : category!.removedProducts;

        category!.newProducts = vm.item != null
            ? vm.item!.newProducts
            : category!.newProducts;

        vm.onUpdate(c, category!, true, true);
      },
      secondaryButtonText: 'Cancel',
      onSecondaryButtonPressed: (_) {
        Navigator.pop(context);
      },
    );
  }

  List<TabBarItem> tabs(context, CategoryViewModel vm) {
    return <TabBarItem>[
      TabBarItem(text: 'Details', content: categoryContext(context, vm)),
    ];
  }

  SingleChildScrollView categoryContext(
    BuildContext context,
    CategoryViewModel vm,
  ) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: vm.key,
          child: Column(children: contextFill(context, vm, category!)),
        ),
      ],
    ),
  );

  List<Widget> contextFill(
    BuildContext context,
    CategoryViewModel vm,
    StockCategory category,
  ) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: category.imageUri == null
            ? InkWell(
                onTap: () async {
                  var imageType = await FileManager().selectFileSource(context);
                  if (imageType != null) {
                    return uploadImage(context, category, imageType, vm);
                  }
                },
                child: Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(
                      context,
                    ).extension<AppliedSurface>()?.secondary,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: MediaQuery.of(context).size.width * (10 / 100),
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.primary,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * (3 / 100),
                      ),
                      Text(
                        'Add Image\n(optional)',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).extension<AppliedTextIcon>()?.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                height: 170,
                width: 170,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        image: isNotBlank(category.imageUri)
                            ? DecorationImage(
                                image: getIt<FlutterNetworkImage>()
                                    .asImageProviderById(
                                      legacyUrl: category.imageUri!,
                                      id: category.id!,
                                      category: 'categories',
                                    ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isNotBlank(category.imageUri)
                              ? Container()
                              : Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size:
                                      MediaQuery.of(context).size.width *
                                      (10 / 100),
                                ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width * (3 / 100),
                          ),
                          isNotBlank(category.imageUri)
                              ? Container()
                              : Text(
                                  'Add Image\n(optional)',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      right: -4,
                      top: -4,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            AppAssets.closeButtonSvg,
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {
                            category.imageUri = null;

                            category.removedProducts = vm.item != null
                                ? vm.item!.removedProducts
                                : category.removedProducts;

                            category.newProducts = vm.item != null
                                ? vm.item!.newProducts
                                : category.newProducts;

                            vm.onUpdate(context, category, false, false);
                            if (mounted) setState(() {});
                          },
                        ),
                      ),
                    ),
                    if (category.imageUri != null)
                      InkWell(
                        child: Container(
                          height:
                              MediaQuery.of(context).size.width *
                              (45 / 100) *
                              (0.25),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700.withOpacity(0.75),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Edit Image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () async {
                          var imageType = await FileManager().selectFileSource(
                            context,
                          );
                          if (imageType != null) {
                            return uploadImage(
                              context,
                              category,
                              imageType,
                              vm,
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
      ),
      //Category Name
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StringFormField(
          enforceMaxLength: false,
          maxLength: 24,
          hintText: 'Name',
          minLines: 1,
          useOutlineStyling: true,
          maxLines: 1,
          key: const Key('name'),
          labelText: 'Category Name',
          nextFocusNode: vm.form.setFocusNode('description'),
          onFieldSubmitted: (value) {
            category.name = category.displayName = value;
          },
          inputAction: TextInputAction.next,
          isRequired: true,
          onSaveValue: (value) {
            category.name = category.displayName = value;
          },
        ),
      ),
      const SizedBox(height: 12),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StringFormField(
          enforceMaxLength: true,
          maxLength: 500,
          maxLines: 120,
          minLines: 1,
          useOutlineStyling: true,
          hintText: 'Describe your product',
          key: const Key('description'),
          labelText: 'Description',
          focusNode: vm.form.setFocusNode('description'),
          nextFocusNode: vm.form.setFocusNode('new'),
          onFieldSubmitted: (value) {
            category.description = value;
          },
          inputAction: TextInputAction.newline,
          isRequired: false,
          onSaveValue: (value) {
            category.description = value;
          },
        ),
      ),
      const CommonDivider(),
      const SizedBox(height: 8),
    ];
  }

  Future<void> uploadImage(
    BuildContext context,
    StockCategory? item,
    ImageSource source,
    CategoryViewModel? vm,
  ) async {
    var selectedImage = await imagePicker.pickImage(source: source);

    if (selectedImage == null) return;

    if (!await FileManager().isFileTypeAllowed(selectedImage, context)) {
      return;
    }

    showProgress(context: context);

    try {
      var state = AppVariables.store!.state;
      var file = File(selectedImage.path);
      var downloadUrl = await FileManager().uploadFile(
        file: file,
        businessId: state.businessId!,
        category: 'categories',
        id: category?.id ?? const Uuid().v4(),
        businessName: '',
      );

      category!.businessId = state.businessId;
      category!.imageUri = downloadUrl.downloadUrl;

      hideProgress(context);
      //we should change the image to the new one

      if (category!.isNew == true) {
        if (mounted) setState(() {});
      } else {
        vm!.onUpdate(context, category!, false, false);
      }
    } on PlatformException catch (e) {
      hideProgress(context);

      showMessageDialog(
        context,
        '${e.code}: ${e.message}',
        LittleFishIcons.warning,
      );
    } catch (e) {
      hideProgress(context);

      reportCheckedError(e, trace: StackTrace.current);

      showMessageDialog(
        context,
        'Something went wrong, please try again later',
        LittleFishIcons.error,
      );
    }
  }
}
