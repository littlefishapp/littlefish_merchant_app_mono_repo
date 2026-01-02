import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:async/async.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/storage/littlefish_storage_service.dart';
import 'package:littlefish_core/storage/models/storage_reference.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../common/presentaion/components/app_progress_indicator.dart';
import 'flutter_network_image.dart';

@Injectable(as: FlutterNetworkImage)
class CloudStorageNetworkImage implements FlutterNetworkImage {
  LittleFishCore core = LittleFishCore.instance;

  @override
  ImageProvider<Object> asImageProviderByUrl(
    String image, {
    Map<String, String>? headers,
    double? width,
    double? height,
  }) => CachedNetworkImageProvider(
    image,
    headers: headers,
    maxHeight: height?.toInt(),
    maxWidth: width?.toInt(),
  );

  @override
  ImageProvider<Object> asImageProviderById({
    required String id,
    required String category,
    String legacyUrl = '',
    Map<String, String>? headers,
    double? width,
    double? height,
  }) {
    if (legacyUrl.isNotEmpty) {
      return asImageProviderByUrl(
        legacyUrl,
        headers: headers,
        height: height,
        width: width,
      );
    } else {
      //ToDo: figure this out...
      return const CachedNetworkImageProvider('');
    }
  }

  final AsyncMemoizer<StorageDownloadUrl> _memoizer = AsyncMemoizer();

  @override
  Widget asWidget({
    required String id,
    required String category,
    String legacyUrl = '',
    BoxFit? fit,
    Color? color,
    Map<String, String>? httpHeaders,
    double? width,
    double? height,
    Widget Function(BuildContext, String, Object)? errorWidget,
    Widget Function(BuildContext, String)? placeholder,
  }) {
    defaultPlaceholder(context, url) => const Padding(
      padding: EdgeInsets.all(12),
      child: AppProgressIndicator(),
    );
    defaultErrorWidget(context, url, error) => Icon(LittleFishIcons.error);

    final LittleFishStorageService storageService = core
        .get<LittleFishStorageService>();

    if (legacyUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(
          (AppVariables.appDefaultButtonRadius / 3),
        ),
        child: CachedNetworkImage(
          imageUrl: legacyUrl,
          fit: fit,
          height: height,
          width: width,
          memCacheHeight: height?.toInt(),
          memCacheWidth: width?.toInt(),
          color: color,
          placeholder: placeholder ?? defaultPlaceholder,
          errorWidget: errorWidget ?? defaultErrorWidget,
          httpHeaders: httpHeaders,
        ),
      );
    }

    return FutureBuilder<StorageDownloadUrl>(
      future: _memoizer.runOnce(() {
        return storageService.getImageUrl(
          businessId: AppVariables.store!.state.businessId ?? '',
          fileCategory: category,
          fileId: id,
          legacyUrl: legacyUrl,
        );
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return defaultPlaceholder(context, '');
        }

        if (snapshot.hasError) {
          return defaultErrorWidget(context, '', snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return defaultErrorWidget(context, '', snapshot.error);
          }

          final data = snapshot.data!;
          return CachedNetworkImage(
            imageUrl: data.url,
            fit: fit,
            height: height,
            width: width,
            memCacheHeight: height?.toInt(),
            memCacheWidth: width?.toInt(),
            color: color,
            placeholder: placeholder ?? defaultPlaceholder,
            errorWidget: errorWidget ?? defaultErrorWidget,
            httpHeaders: httpHeaders,
          );
        }

        return defaultPlaceholder(context, '');
      },
    );
  }

  @override
  Widget asWidgetUri({
    required String uri,
    BoxFit? fit,
    Color? color,
    Map<String, String>? httpHeaders,
    double? width,
    double? height,
    Widget Function(BuildContext p1, String p2, Object p3)? errorWidget,
    Widget Function(BuildContext p1, String p2)? placeholder,
  }) {
    defaultPlaceholder(context, url) => const Padding(
      padding: EdgeInsets.all(12),
      child: AppProgressIndicator(),
    );
    defaultErrorWidget(context, url, error) => Icon(LittleFishIcons.error);

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        (AppVariables.appDefaultButtonRadius / 3),
      ),
      child: CachedNetworkImage(
        imageUrl: uri,
        fit: fit,
        height: height,
        width: width,
        memCacheHeight: height?.toInt(),
        memCacheWidth: width?.toInt(),
        color: color,
        placeholder: placeholder ?? defaultPlaceholder,
        errorWidget: errorWidget ?? defaultErrorWidget,
        httpHeaders: httpHeaders,
      ),
    );
  }
}
