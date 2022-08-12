import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;


class PdfPreviewPage extends StatelessWidget {
  final Uint8List pdf;
  const PdfPreviewPage(this.pdf,{Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => pdf,
      ),
    );
  }
}