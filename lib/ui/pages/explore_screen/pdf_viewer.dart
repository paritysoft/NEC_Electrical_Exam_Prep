import 'dart:async';

import 'package:electrician/ui/pages/data/upadansonghro.dart';
import 'package:electrician/ui/pages/explore_screen/your_questions_screen.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfPath;
  final String title;

  const PDFViewerPage({Key? key, required this.pdfPath, required this.title})
      : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 300), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarCustom(context,  widget.title),
        body: Center(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SfPdfViewer.asset(
                    widget.pdfPath,
                    canShowTextSelectionMenu: false,
                    password: yourKey, // Pass the correct user password
                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      // PDF document loaded successfully
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    onDocumentLoadFailed:
                        (PdfDocumentLoadFailedDetails details) {
                      // Handle document load failure (e.g., incorrect password or invalid PDF)
                      print("Failed to load document: ${details.error}");
                      print("Error description: ${details.description}");
                    },
                  )));
  }
}
