import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart' as tools;
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/colour_picker_page.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/hex_color.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/colour_info_tile.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/online_store_images.dart';

import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import '../../../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../../../injector.dart';

class OnlineStoreBrandInfoPage extends StatefulWidget {
  static const route = 'online-store/brand-info';

  const OnlineStoreBrandInfoPage({Key? key}) : super(key: key);

  @override
  State<OnlineStoreBrandInfoPage> createState() =>
      _OnlineStoreBrandInfoPageState();
}

class _OnlineStoreBrandInfoPageState extends State<OnlineStoreBrandInfoPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      onInit: (store) {
        if (store.state.storeState.store == null) {
          store.dispatch(CreateDefaultStoreAction());
        }
      },
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        return scaffold(vm);
      },
    );
  }

  Widget scaffold(ManageStoreVMv2 vm) {
    return KeyboardDismissalUtility(
      content: AppScaffold(
        title: 'Customise your online store',
        centreTitle: false,
        body: vm.isLoading != true
            ? layout(context, vm)
            : const AppProgressIndicator(),
        enableProfileAction: false,
        persistentFooterButtons: [
          FooterButtonsSecondaryPrimary(
            secondaryButtonText: 'Cancel',
            onSecondaryButtonPressed: (ctx) async {
              Navigator.of(context).pop();
            },
            primaryButtonText: 'Save Changes',
            onPrimaryButtonPressed: (ctx) async {
              final isValid = await _validateBrandingFields(context, vm);
              if (!isValid) return;

              await vm.upsertStore(vm.item!);
              Navigator.of(context).pushNamedAndRemoveUntil(
                tools.getOnlineStoreRoute(isTrue(vm.item?.isConfigured)),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  layout(BuildContext context, ManageStoreVMv2 vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logoHeadingAndImage(context, vm),
            const SizedBox(height: 16),
            bannerHeadingAndImage(context, vm),
            const SizedBox(height: 16),
            aboutCompanyBannerHeadingAndImage(context, vm),
            const SizedBox(height: 16),
            storeColourTiles(vm),
          ],
        ),
      ),
    );
  }

  Widget logoHeadingAndImage(BuildContext context, ManageStoreVMv2 vm) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: context.labelLarge(
            'Logo',
            color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
            isSemiBold: true,
          ),
        ),
        const SizedBox(height: 8),
        CardSquareFlat(
          margin: const EdgeInsets.all(0),
          child: OnlineStoreImages(
            imageUrl: vm.item?.logoUrl,
            helperText:
                'Upload your logo to represent your business on your online store. It will appear in the header across all pages.',
            onTap: () {
              vm.store?.dispatch(
                chooseAndUploadStoreBrandImage(
                  context: context,
                  imageType: ImageType.logo,
                  onError: (error) {
                    showCustomMessageDialog(
                      context: context,
                      content: context.labelSmall(error),
                      title: 'Upload Error',
                      buttonText: 'Ok',
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget bannerHeadingAndImage(BuildContext context, ManageStoreVMv2 vm) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: context.labelLarge(
            'Home Page Banner',
            color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
            isSemiBold: true,
          ),
        ),
        const SizedBox(height: 8),
        CardSquareFlat(
          margin: const EdgeInsets.all(0),
          child: OnlineStoreImages(
            label: 'Upload Banner',
            helperText:
                'Upload a banner image to display on your homepage. This image will be featured prominently at the top of your site.',
            imageUrl: vm.item?.bannerUrl,
            onTap: () {
              vm.store?.dispatch(
                chooseAndUploadStoreBrandBannerImage(
                  context: context,
                  onError: (error) {
                    showCustomMessageDialog(
                      context: context,
                      content: context.labelSmall(error),
                      title: 'Upload Error',
                      buttonText: 'Ok',
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget aboutCompanyBannerHeadingAndImage(
    BuildContext context,
    ManageStoreVMv2 vm,
  ) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: context.labelLarge(
            'About Company Banner',
            color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
            isSemiBold: true,
          ),
        ),
        const SizedBox(height: 8),
        CardSquareFlat(
          margin: const EdgeInsets.all(0),
          child: OnlineStoreImages(
            label: 'About Company Banner',
            helperText:
                'Upload an image for your About Us page. This image will help tell your brand\'s story and appear alongside your business details.',
            imageUrl: vm.item?.aboutImageUrl,
            onTap: () {
              vm.store?.dispatch(
                chooseAndUploadStoreBrandAboutImage(
                  context: context,
                  onError: (error) {
                    showCustomMessageDialog(
                      context: context,
                      content: context.labelSmall(error),
                      title: 'Upload Error',
                      buttonText: 'Ok',
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget storeColourTiles(ManageStoreVMv2 vm) {
    String? primaryColourStr = vm.item?.storePreferences?.theme?.primaryColor;
    String? secondaryColourStr =
        vm.item?.storePreferences?.theme?.secondaryColor;
    Color? primaryColour = isNotBlank(primaryColourStr)
        ? HexColor(primaryColourStr!)
        : null;
    Color? secondaryColour = isNotBlank(secondaryColourStr)
        ? HexColor(secondaryColourStr!)
        : null;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: context.labelLarge(
            'Colours',
            color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
            isSemiBold: true,
          ),
        ),
        ColourInfoTile(
          title: 'Primary Colour',
          description:
              'Choose your store\'s primary color, which will be used for key elements like buttons and links',
          colour: primaryColour,
          onTap: () => showColourPicker(
            context: context,
            initialColour: primaryColour ?? Colors.red,
            onSave: (colour) => _savePrimaryColour(colour, vm),
          ),
        ),
        ColourInfoTile(
          title: 'Secondary Colour',
          description:
              'Pick a secondary color to complement your primary color and enhance the overall look of your store',
          colour: secondaryColour,
          onTap: () => showColourPicker(
            context: context,
            initialColour:
                secondaryColour ?? Theme.of(context).colorScheme.secondary,
            onSave: (colour) => _saveSecondaryColour(colour, vm),
          ),
        ),
      ],
    );
  }

  showColourPicker({
    required BuildContext context,
    required Color initialColour,
    required void Function(Color) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        return SafeArea(
          top: false,
          bottom: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: ColourPickerPage(
                initialColour: initialColour,
                onSaveColour: (colour) => onSave(colour),
              ),
            ),
          ),
        );
      },
    );
  }

  void _savePrimaryColour(Color colour, ManageStoreVMv2 vm) {
    if (mounted) {
      setState(() {
        vm.store?.dispatch(SetStorePrimaryColourAction(colour));
      });
    }
  }

  void _saveSecondaryColour(Color colour, ManageStoreVMv2 vm) {
    if (mounted) {
      setState(() {
        vm.store?.dispatch(SetStoreSecondaryColourAction(colour));
      });
    }
  }

  Future<bool> _validateBrandingFields(
    BuildContext context,
    ManageStoreVMv2 vm,
  ) async {
    final hasLogo = isNotBlank(vm.item?.logoUrl);
    final hasBanner = isNotBlank(vm.item?.bannerUrl);
    final hasAboutBanner = isNotBlank(vm.item?.aboutImageUrl);
    final hasPrimary = isNotBlank(
      vm.item?.storePreferences?.theme?.primaryColor,
    );
    final hasSecondary = isNotBlank(
      vm.item?.storePreferences?.theme?.secondaryColor,
    );

    if (hasLogo && hasBanner && hasAboutBanner && hasPrimary && hasSecondary) {
      return true;
    }

    String missing = '';
    if (!hasLogo) missing += '• Logo\n';
    if (!hasBanner) missing += '• Home Page Banner\n';
    if (!hasAboutBanner) missing += '• About Company Banner\n';
    if (!hasPrimary) missing += '• Primary Colour\n';
    if (!hasSecondary) missing += '• Secondary Colour\n';

    await getIt<ModalService>().showActionModal(
      context: context,
      title: 'Missing Required Fields',
      description: 'Please upload the following before saving:\n\n$missing',
      acceptText: 'Ok',
      showCancelButton: false,
    );

    return false;
  }
}
