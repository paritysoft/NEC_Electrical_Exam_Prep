import 'package:electrician/ui/pages/explore_screen/pdf_viewer.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../util/AppColors.dart';


String yourKey = dotenv.env["YOUR_KEY"]!;
class YourQuestionsScreen extends StatefulWidget {
  @override
  _YourQuestionsScreenState createState() => _YourQuestionsScreenState();
}

class _YourQuestionsScreenState extends State<YourQuestionsScreen> {
  List<String> _categories = [
    "Cardiology",
    "Diagnostic and Therapeutic Procedures",
    "Advanced Pathophysiology",
    "Evidence-Based Practice and Clinical Decision-Making",
    "Evidence-Based Systems and Multisystem Failure",
    "Acute Illness and Injury Management"
  ]; // List to store categories

  bool _isLoading = false; // Loading state


  @override
  void initState() {
    super.initState();
  }

  // String? _pdfPath;
  //
  // Future<void> openDecryptedPDF() async {
  //   // Decrypt the password-protected PDF
  //   File decryptedPDF = await decryptPasswordProtectedPDFFromAssets(
  //     'assets/pdf/st1.pdf',
  //     // Replace with your actual file path
  //     yourKey, // Replace with your PDF password
  //   );
  //   print("decryptedPDF  ${decryptedPDF}");
  //   setState(() {
  //     _pdfPath = decryptedPDF.path;
  //   });
  //
  //   // Navigate to PDF Viewer
  //   if (_pdfPath != null) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PDFViewerPage(pdfPath: _pdfPath!),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom(context, 'Your Questions'),

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

                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewerPage(pdfPath: "assets/pdf/acnp${index+1}.pdf", title: _categories[index],),
                                    ));


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



