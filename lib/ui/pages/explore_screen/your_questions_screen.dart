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
    "Electrical Safety",
    "Basic Circuits (Ohm's Law, series/parallel circuits)",
    "Electrical Tools",
    "Wiring and Installations",
    "National Electric Code (NEC)",
    "Troubleshooting Electrical Systems"
  ]; // List to store categories

  bool _isLoading = false; // Loading state


  @override
  void initState() {
    super.initState();
  }


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
                          builder: (context) => PDFViewerPage(pdfPath: "assets/pdf/st${index+1}.pdf", title: _categories[index],),
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