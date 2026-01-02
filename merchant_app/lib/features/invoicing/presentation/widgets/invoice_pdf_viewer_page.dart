import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

class PdfViewerPage extends StatelessWidget {
  final File file;

  const PdfViewerPage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Invoice PDF',
      onBackPressed: () {
        Navigator.of(context).pop();
      },
      body: SfPdfViewer.file(file),
    );
  }
}
