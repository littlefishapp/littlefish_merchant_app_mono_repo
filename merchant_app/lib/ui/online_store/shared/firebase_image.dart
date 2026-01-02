// removed ignore: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';

import '../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../injector.dart';
import '../../../tools/network_image/flutter_network_image.dart';

class FirebaseImage extends StatefulWidget {
  final String? imageAddress;

  final String? defaultNetworkImage;

  final bool isAsset;

  final BoxFit fit;

  final Color? color;

  const FirebaseImage({
    Key? key,
    required this.imageAddress,
    this.fit = BoxFit.fitHeight,
    this.defaultNetworkImage,
    this.isAsset = false,
    this.color,
  }) : super(key: key);

  @override
  State<FirebaseImage> createState() => _FirebaseImageState();
}

class _FirebaseImageState extends State<FirebaseImage> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    if (widget.imageAddress != null && widget.imageAddress!.contains('asset')) {
      return Image.asset(
        widget.imageAddress!,
        fit: widget.fit,
        color: widget.color,
      );
    }

    return Container(
      constraints: const BoxConstraints.expand(),
      child: isNotBlank(widget.imageAddress)
          ? FutureBuilder(
              future: _memoizer.runOnce(() async {
                Future.delayed(const Duration(milliseconds: 50));
              }),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const AppProgressIndicator();
                }

                var downloadString = widget.imageAddress;
                return isBlank(downloadString)
                    ? isNotBlank(widget.defaultNetworkImage)
                          ? widget.isAsset
                                ? Image.asset(
                                    widget.defaultNetworkImage!,
                                    fit: widget.fit,
                                    color: widget.color,
                                  )
                                : getIt<FlutterNetworkImage>().asWidgetUri(
                                    uri: widget.defaultNetworkImage!,
                                    fit: widget.fit,
                                    color: widget.color,
                                    height: AppVariables.listImageHeight,
                                    width: AppVariables.listImageWidth,
                                    httpHeaders: {
                                      HttpHeaders.authorizationHeader:
                                          'Bearer ${AppVariables.store!.state.token!}',
                                    },
                                  )
                          : Image.asset(
                              ImageConstants.productDefault,
                              fit: widget.fit,
                              color: widget.color,
                            )
                    : getIt<FlutterNetworkImage>().asWidgetUri(
                        httpHeaders: {
                          HttpHeaders.authorizationHeader:
                              'Bearer ${AppVariables.store!.state.token!}',
                        },
                        uri: downloadString!,
                        height: AppVariables.listImageHeight,
                        width: AppVariables.listImageWidth,
                        fit: widget.fit,
                        color: widget.color,
                      );
              },
            )
          : isNotBlank(widget.defaultNetworkImage)
          ? widget.isAsset
                ? Image.asset(
                    widget.defaultNetworkImage!,
                    fit: widget.fit,
                    color: widget.color,
                  )
                : kIsWeb
                ? getIt<FlutterNetworkImage>().asWidgetUri(
                    uri: widget.defaultNetworkImage!,
                    fit: widget.fit,
                    color: widget.color,
                    height: AppVariables.listImageHeight,
                    width: AppVariables.listImageWidth,
                    httpHeaders: {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${AppVariables.store!.state.token!}',
                    },
                  )
                : getIt<FlutterNetworkImage>().asWidgetUri(
                    httpHeaders: {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${AppVariables.store!.state.token!}',
                    },
                    uri: widget.defaultNetworkImage!,
                    height: AppVariables.listImageHeight,
                    width: AppVariables.listImageWidth,
                    fit: widget.fit,
                    color: widget.color,
                  )
          : Image.asset(ImageConstants.productDefault, fit: widget.fit),
    );
  }
}

class FirebaseImageAvatar extends StatefulWidget {
  final String? imageAddress;

  final String? defaultAssetImage;

  final BoxFit fit;

  final double radius;

  final Function? onTap;

  const FirebaseImageAvatar({
    Key? key,
    required this.imageAddress,
    this.fit = BoxFit.fitHeight,
    this.defaultAssetImage,
    this.radius = 30,
    this.onTap,
  }) : super(key: key);

  @override
  State<FirebaseImageAvatar> createState() => _FirebaseImageAvatarState();
}

class _FirebaseImageAvatarState extends State<FirebaseImageAvatar> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    if (widget.imageAddress != null && widget.imageAddress!.contains('asset')) {
      return InkWell(
        onTap: widget.onTap as void Function()?,
        child: CircleAvatar(backgroundImage: AssetImage(widget.imageAddress!)),
      );
    }

    if (isBlank(widget.imageAddress)) {
      return InkWell(
        onTap: widget.onTap as void Function()?,
        child: CircleAvatar(
          radius: widget.radius,
          backgroundImage: isNotBlank(widget.defaultAssetImage)
              ? AssetImage(widget.defaultAssetImage!)
              : null,
        ),
      );
    }

    return FutureBuilder(
      future: _memoizer.runOnce(() async {
        Future.delayed(const Duration(seconds: 1));
      }),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircleAvatar(
            radius: widget.radius,
            child: snapshot.connectionState != ConnectionState.done
                ? const AppProgressIndicator()
                : null,
          );
        }

        var downloadString = widget.imageAddress;

        return InkWell(
          onTap: widget.onTap as void Function()?,
          child: CircleAvatar(
            radius: widget.radius,
            backgroundImage: (isBlank(downloadString)
                ? isNotBlank(widget.defaultAssetImage)
                      ? AssetImage(widget.defaultAssetImage!)
                      : const AssetImage(ImageConstants.storeLogoDefault)
                : kIsWeb
                ? getIt<FlutterNetworkImage>().asImageProviderByUrl(
                    downloadString!,
                    height: AppVariables.listImageHeight,
                    width: AppVariables.listImageWidth,
                    headers: {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${AppVariables.store!.state.token!}',
                    },
                  )
                : getIt<FlutterNetworkImage>().asImageProviderByUrl(
                    downloadString!,
                    height: AppVariables.listImageHeight,
                    width: AppVariables.listImageWidth,
                    headers: {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${AppVariables.store!.state.token!}',
                    },
                  )),
            child: snapshot.connectionState != ConnectionState.done
                ? const AppProgressIndicator()
                : null,
          ),
        );
      },
    );
  }
}
