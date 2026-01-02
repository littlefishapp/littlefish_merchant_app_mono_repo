import 'package:flutter/widgets.dart';

abstract class FlutterNetworkImage {
  ImageProvider<Object> asImageProviderByUrl(
    String image, {
    Map<String, String>? headers,
    double? width,
    double? height,
  });

  ImageProvider<Object> asImageProviderById({
    required String id,
    required String category,
    String legacyUrl,
    Map<String, String>? headers,
    double? width,
    double? height,
  });

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
  });

  Widget asWidgetUri({
    required String uri,
    BoxFit? fit,
    Color? color,
    Map<String, String>? httpHeaders,
    double? width,
    double? height,
    Widget Function(BuildContext, String, Object)? errorWidget,
    Widget Function(BuildContext, String)? placeholder,
  });
}
