import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/lf_app_themes.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/banner_panel.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/loading_entity.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/banner.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/logo.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';

enum _LayoutMode { stacked, splitLeftBanner, splitTopBanner, fullBleed }

class LoadingComponent extends StatelessWidget {
  final LoadingEntity config;
  final ValueNotifier<String> message;

  const LoadingComponent({
    Key? key,
    required this.config,
    required this.message,
  }) : super(key: key);

  _LayoutMode _decideLayoutMode(BuildContext context, LoadingEntity config) {
    final isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay ?? false;
    // TODO: Add isMediumDisplay if available

    if (!isLargeDisplay) return _LayoutMode.stacked;

    final ratio = config.largeDisplayBannerRatio.clamp(0.0, 1.0);
    if (ratio <= 0.01) return _LayoutMode.stacked;
    if (ratio >= 0.95) return _LayoutMode.fullBleed;

    return config.bannerOnLeftSide
        ? _LayoutMode.splitLeftBanner
        : _LayoutMode.splitTopBanner;
  }

  @override
  Widget build(BuildContext context) {
    final inkColor = config.useReverseColours
        ? Theme.of(context).extension<AppliedTextIcon>()?.inversePrimary ??
              Colors.white
        : Theme.of(context).extension<AppliedTextIcon>()?.primary ??
              Colors.black;

    final progressColor = inkColor.withAlpha(200);

    final mode = _decideLayoutMode(context, config);

    return Theme(
      data: lfCustomTheme(context: context, language: 'en'),
      child: Scaffold(
        backgroundColor:
            Theme.of(context).extension<AppliedSurface>()?.primary ??
            Colors.white,
        body: switch (mode) {
          _LayoutMode.stacked => _buildStacked(
            context,
            inkColor,
            progressColor,
          ),
          _LayoutMode.splitLeftBanner => _buildSplitLeft(
            context,
            inkColor,
            progressColor,
          ),
          _LayoutMode.splitTopBanner => _buildSplitTop(
            context,
            inkColor,
            progressColor,
          ),
          _LayoutMode.fullBleed => _buildFullBleed(
            context,
            inkColor,
            progressColor,
          ),
        },
      ),
    );
  }

  Widget _buildStacked(
    BuildContext context,
    Color inkColor,
    Color progressColor,
  ) {
    return Container(
      width: double.infinity,
      decoration: config.decorationEnabled ? _backgroundDecoration() : null,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: config.alignTop
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: _sharedContentChildren(
              context: context,
              inkColor: inkColor,
              progressColor: progressColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSplitLeft(
    BuildContext context,
    Color inkColor,
    Color progressColor,
  ) {
    final ratio = config.largeDisplayBannerRatio.clamp(0.3, 0.6);
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * ratio,
          child: BannerPanel(), // Assuming BannerPanel is imported/available
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _sharedProgressChildren(
                context,
                inkColor,
                progressColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSplitTop(
    BuildContext context,
    Color inkColor,
    Color progressColor,
  ) {
    return Column(
      children: [
        Expanded(flex: 4, child: BannerPanel()),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _sharedProgressChildren(
                context,
                inkColor,
                progressColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullBleed(
    BuildContext context,
    Color inkColor,
    Color progressColor,
  ) {
    return Stack(
      children: [
        Positioned.fill(child: BannerPanel()),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _sharedProgressChildren(
                context,
                inkColor,
                progressColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _sharedContentChildren({
    required BuildContext context,
    required Color inkColor,
    required Color progressColor,
  }) {
    final useBanner = config.bannerComponent.toLowerCase().contains('banner');
    final children = <Widget>[];
    if (useBanner) {
      children.add(banner(templateKey: config.bannerComponent));
    } else {
      children.add(logo(templateKey: config.bannerComponent));
    }
    children.addAll(_sharedProgressChildren(context, inkColor, progressColor));
    return children;
  }

  List<Widget> _sharedProgressChildren(
    BuildContext context,
    Color inkColor,
    Color progressColor,
  ) {
    final useDefaultProgress = config.progressComponent.toLowerCase().contains(
      'default',
    );
    return [
      if (useDefaultProgress)
        Padding(
          padding: const EdgeInsets.only(top: 64, bottom: 16),
          child: AppProgressIndicator(loaderColor: progressColor),
        ),
      context.labelXSmall(
        message.value.isEmpty
            ? 'Loading, this may take a few seconds...'
            : message.value,
      ),
    ];
  }

  BoxDecoration _backgroundDecoration() => const BoxDecoration(
    color: Colors.white,
    image: DecorationImage(
      image: AssetImage(AppAssets.appBackgroundLoginPng),
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    ),
  );
}
