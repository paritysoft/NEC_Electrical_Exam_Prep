import 'dart:io';
import 'package:commonquiz/ui/pages/explore_screen/pdf_viewer.dart';
import 'package:commonquiz/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../util/AppColors.dart';
import 'package:flutter/services.dart';  // For loading assets

import 'package:path_provider/path_provider.dart';  // For getting the directory
import 'dart:io';


class YourQuestionsScreen extends StatefulWidget {
  @override
  _YourQuestionsScreenState createState() => _YourQuestionsScreenState();
}

class _YourQuestionsScreenState extends State<YourQuestionsScreen> {
  List<String> _categories = [
    "Electrical Safety",
    "Basic Circuits (Ohm's Law, series/parallel circuits)",
    "Electrical Tools",
    "Wiring and Installations",
    "National Electric Code (NEC)",
    "Troubleshooting Electrical Systems"
  ]; // List to store categories

  bool _isLoading = false; // Loading state
  String yourKey = dotenv.env["YOUR_KEY"]!;

  @override
  void initState() {
    super.initState();
  }

  String? _pdfPath;

  Future<void> openDecryptedPDF() async {
    // Decrypt the password-protected PDF
    File decryptedPDF = await decryptPasswordProtectedPDFFromAssets(
      'assets/pdf/electrical_safe_questions_pass.pdf',
      // Replace with your actual file path
      yourKey, // Replace with your PDF password
    );
    print("decryptedPDF  ${decryptedPDF}");
    setState(() {
      _pdfPath = decryptedPDF.path;
    });

    // Navigate to PDF Viewer
    if (_pdfPath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerPage(pdfPath: _pdfPath!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: title15BoldColor(context, 'Your Questions', color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while data is being fetched
          : Container(
              color: background,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2, // Adds shadow to the card
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                      ),
                      child: ListTile(
                        title: smallLabel(context, _categories[index]),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          openDecryptedPDF();

                          // Handle on tap
                          // List<ElectricianQuestion>? questions =
                          //     QuestionCache().getQuestions();
                          // if (questions != null) {
                          //   List<ElectricianQuestion>? filterQuestions =
                          //       QuestionCache().filterQuestionsByCategory(
                          //           questions, _categories[index]);
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (_) => QuizPage(
                          //                 questions: filterQuestions,
                          //                 category: _categories[index],
                          //               )));
                          // }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}




Future<File> decryptPasswordProtectedPDFFromAssets(String assetPath, String password) async {
  // Load the PDF file from assets
  final ByteData bytes = await rootBundle.load(assetPath);
  final Uint8List pdfBytes = bytes.buffer.asUint8List();

  PdfDocument document;

  try {
    // Try to open and decrypt the PDF using Syncfusion
    document = PdfDocument(inputBytes: pdfBytes, password: password);

    // If decryption fails, it will throw an exception
    if (document.pages == 0) {
      throw Exception("The decrypted PDF document has no pages.");
    }

    // Get the application's document directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String outputPath = "${appDocDir.path}/decrypted_pdf.pdf"; // Append the filename to the directory
    final File file = File(outputPath);

    // Write the decrypted content to the file
    await file.writeAsBytes(document.saveSync());

    // Dispose of the document to free up resources
    document.dispose();

    // Return the file path for use in the PDF viewer
    return file;
  } catch (e) {
    // Handle exceptions related to PDF opening or password issues
    print("Error decrypting PDF: $e");

    throw Exception("PDF decryption failed. Please check the password or file integrity.");
  }
}
