import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'scaffolds/app_scaffold.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String? title;
  final bool isAsset;

  const WebViewScreen({
    Key? key,
    required this.url,
    this.title,
    this.isAsset = false,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  String? title;
  String? url;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    url = widget.url;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('### Progress: $progress%');
          },
          onPageStarted: (String url) {
            debugPrint('### Page started loading: $url');
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            debugPrint('### Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
              '### Resource error: ${error.description}, Code: ${error.errorCode}, URL: ${error.url}',
            );
            setState(() {
              _isLoading = false;
            });
            // Fallback for errors
            if (error.errorCode == -1) {
              // Generic error code for ERR_HTTP_RESPONSE_CODE_FAILURE
              _controller.loadHtmlString('''
                <html><body><h1>Error Loading Page</h1><p>${error.description}</p></body></html>
              ''');
            }
          },
          onHttpError: (HttpResponseError error) {
            debugPrint(
              '### HTTP error: Status ${error.response?.statusCode}, URL: ${error.request?.uri}',
            );
            setState(() {
              _isLoading = false;
            });
          },
          onHttpAuthRequest: (request) {
            debugPrint('### HTTP auth request: ${request.host}');
          },
          onUrlChange: (change) {
            debugPrint('### URL changed: ${change.url}');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('### Navigation request: ${request.url}');
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate; // Allow for testing
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return AppScaffold(
      actions: [
        if (widget.isAsset)
          InkWell(
            onTap: () {
              _launchInBrowser(widget.url);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.open_in_new),
            ),
          ),
      ],
      title: widget.title ?? '',
      enableProfileAction: !isTablet,
      body: Stack(
        children: <Widget>[
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(
                backgroundColor: Theme.of(
                  context,
                ).extension<AppliedSurface>()?.brandSubTitle,
                color: Theme.of(context).extension<AppliedSurface>()?.brand,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    final launchUri = Uri.parse(url);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('### Could not launch $url');
    }
  }
}
