import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';

import '../../../features/ecommerce_shared/models/store/store.dart';
import '../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../injector.dart';
import '../../../tools/network_image/flutter_network_image.dart';

class StoreCard extends StatefulWidget {
  final StoreCardDisplayMode mode;

  final Store? store;

  final Position? userPosition;

  final Function? onLongPress;

  final Function? onTap;

  // final Function? onBannerTap;

  final double elevation;

  const StoreCard({
    Key? key,
    // this.onBannerTap,
    this.mode = StoreCardDisplayMode.card,
    this.onLongPress,
    this.onTap,
    required this.store,
    this.userPosition,
    this.elevation = 1.0,
  }) : super(key: key);

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  // late List<StoreBanner> banners = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // banners = widget.store!.banners!.where((banner) => showBanner(banner)).toList();
    return _storeCard(context);
  }

  InkWell _storeCard(context) => InkWell(
    customBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kBorderRadius!),
    ),
    onTap: () {
      widget.onTap!();
    },
    child: Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: storeCoverImage(context, widget.store?.coverImageUrl),
          ),
        ),
        if (isNotBlank(widget.store?.description))
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(kBorderRadius!),
              bottomRight: Radius.circular(kBorderRadius!),
            ),
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(
                widget.store?.description ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${widget.store!.addressConfigured ? widget.store!.primaryAddress!.city : ''}",
              ),
            ),
          ),
      ],
    ),
  );
}

// bool showBanner(StoreBanner banner) {
//   if (banner.endDate!.isAfter(DateTime.now()) && banner.enabled == false) {
//     return false;
//   }
//   return true;
// }

ClipRRect storeCoverImage(context, String? coverUrl) => ClipRRect(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(kBorderRadius!),
    topRight: Radius.circular(kBorderRadius!),
  ),
  child: ColorFiltered(
    colorFilter: ColorFilter.mode(
      Colors.black.withOpacity(0.85),
      BlendMode.dstATop,
    ),
    child: Container(
      constraints: const BoxConstraints.expand(),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius!),
      ),
      child: isBlank(coverUrl)
          ? Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.coverPlaceholder3Png),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                    child: Container(
                      //you can change opacity with color here(I used black) for background.
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).scaffoldBackgroundColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'No Image',
                    style: TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ],
            )
          : FirebaseImage(imageAddress: coverUrl, fit: BoxFit.cover),
    ),
  ),
);

Container storeLogo(context, String logoUrl) => Container(
  height: 64,
  width: 64,
  padding: const EdgeInsets.symmetric(vertical: 8),
  child: Material(
    // color: Theme.of(context).colorScheme.secondary,
    borderRadius: BorderRadius.circular(kBorderRadius!),
    elevation: 5,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius!),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5),
      height: 74,
      width: 76,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: isNotBlank(logoUrl)
            ? getIt<FlutterNetworkImage>().asWidget(
                id: '', //ToDo: we need to validate online store.. (business_data)
                category: 'stores',
                httpHeaders: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${AppVariables.store!.state.token!}',
                },
                legacyUrl: logoUrl,
                height: AppVariables.listImageHeight,
                width: AppVariables.listImageWidth,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => const AppProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(LittleFishIcons.error),
              )
            : Image.asset(ImageConstants.storeLogoDefault),
      ),
    ),
  ),
);

Container storeSubCardItem(
  context, {
  Alignment? alignment,
  Color? backgroundColor,
  Widget? child,
}) => Container(
  alignment: alignment ?? Alignment.center,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(kBorderRadius!),
  ),
  padding: const EdgeInsets.symmetric(vertical: 2),
  child: child,
);

enum StoreCardDisplayMode { tile, card }
