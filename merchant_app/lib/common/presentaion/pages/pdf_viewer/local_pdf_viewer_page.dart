import 'dart:io';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

enum PdfSource { isAsset, isFile, isNetwork }

class LocalPdfViewerPage extends StatefulWidget {
  static const String route = 'pdfViewer';
  final String? title;
  final String path;
  final PdfSource pdfSource;
  const LocalPdfViewerPage({
    super.key,
    this.path = '',
    this.title,
    this.pdfSource = PdfSource.isAsset,
  });

  @override
  State<LocalPdfViewerPage> createState() =>
      _LocalPdfViewerPagePdfViewerPageState();
}

class _LocalPdfViewerPagePdfViewerPageState extends State<LocalPdfViewerPage> {
  bool couldLoad = true;

  @override
  Widget build(BuildContext context) {
    File file = File('');
    if (widget.pdfSource == PdfSource.isFile) {
      file = File(widget.path);
    }
    return AppScaffold(
      centreTitle: false,
      title: widget.title ?? 'PDF Viewer',
      body: couldLoad
          ? widget.pdfSource == PdfSource.isAsset
                ? SfPdfViewer.asset(
                    widget.path,
                    onDocumentLoadFailed: (_) {
                      setState(() {
                        couldLoad = false;
                      });
                    },
                  )
                : widget.pdfSource == PdfSource.isFile
                ? SfPdfViewer.file(
                    file,
                    onDocumentLoadFailed: (_) {
                      setState(() {
                        couldLoad = false;
                      });
                    },
                  )
                : widget.pdfSource == PdfSource.isNetwork
                ? SfPdfViewer.network(
                    widget.path,
                    onDocumentLoadFailed: (_) {
                      setState(() {
                        couldLoad = false;
                      });
                    },
                  )
                : noLoadMessage()
          : noLoadMessage(),
    );
  }

  Center noLoadMessage() {
    return const Center(
      child: Text(
        'Oh no!\nCould not load document...',
        textAlign: TextAlign.center,
      ),
    );
  }
}
