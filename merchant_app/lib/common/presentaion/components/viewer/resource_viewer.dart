import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/pages/pdf_viewer/local_pdf_viewer_page.dart';
import 'package:littlefish_merchant/common/presentaion/pages/web_view_screen.dart';

class ResourceViewer extends StatelessWidget {
  final String url;
  final bool isAsset;
  final String title;
  const ResourceViewer({
    super.key,
    required this.url,
    required this.title,
    this.isAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    return _isUrlPdf(url)
        ? LocalPdfViewerPage(
            title: title,
            pdfSource: isAsset ? PdfSource.isAsset : PdfSource.isNetwork,
            path: url,
          )
        : WebViewScreen(title: title, url: url, isAsset: isAsset);
  }

  bool _isUrlPdf(String url) {
    return url.endsWith('.pdf') || url.endsWith('.PDF');
  }
}
