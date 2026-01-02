// File: banner_panel.dart
import 'package:flutter/material.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';

import 'app_progress_indicator.dart';

enum BannerPanelMode {
  /// Full-bleed left side on tablets — no padding, no rounding
  fullLeft,

  /// Classic mobile — inside a rounded card with padding/shadow
  card,

  /// Raw image only (for Stack/full-bleed backgrounds)
  raw,
}

class BannerPanel extends StatelessWidget {
  /// How the banner should behave
  final BannerPanelMode mode;

  /// Optional override URL (rarely needed)
  final String? imageUrlOverride;

  /// Padding around the image when mode == card (default = 16)
  final EdgeInsetsGeometry? cardPadding;

  /// Border radius when mode == card (default = 16)
  final BorderRadiusGeometry? cardBorderRadius;

  /// Optional box shadow when mode == card
  final List<BoxShadow>? cardShadow;

  const BannerPanel({
    Key? key,
    this.mode = BannerPanelMode.card,
    this.imageUrlOverride,
    this.cardPadding,
    this.cardBorderRadius,
    this.cardShadow,
  }) : super(key: key);

  // Keep the old zero-param constructor working (defaults to card mode)
  const BannerPanel.legacy({Key? key})
    : this(key: key, mode: BannerPanelMode.card);

  String _getBannerImageUrl() {
    if (imageUrlOverride != null) return imageUrlOverride!;

    final configService = LittleFishCore.instance.get<ConfigService>();
    return configService.getStringValue(
      key: 'login_banner_image_url_v2',
      defaultValue: 'assets/client_specific/images/login_background.png',
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.appLoginBannerPng),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: AppProgressIndicator()),
        errorWidget: (context, url, error) => const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.appLoginBannerPng),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    // Local asset
    return Image.asset(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getBannerImageUrl();
    final imageWidget = _buildImage(imageUrl);

    return switch (mode) {
      BannerPanelMode.fullLeft => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
      ),
      BannerPanelMode.card => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: cardBorderRadius ?? BorderRadius.circular(16),
          boxShadow:
              cardShadow ??
              [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
        ),
        child: Padding(
          padding: cardPadding ?? const EdgeInsets.all(32),
          child: ClipRRect(
            borderRadius: cardBorderRadius ?? BorderRadius.circular(12),
            child: imageWidget,
          ),
        ),
      ),
      BannerPanelMode.raw => imageWidget,
    };
  }
}
