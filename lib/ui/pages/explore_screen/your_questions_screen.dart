import 'package:electrician/ui/widgets/responsive_layout.dart';
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
    "Troubleshooting Electrical Systems",
  ]; // List to store categories

  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    appBar: appBarCustom(context, 'Your Questions'),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            'Your study library',
            subtitle: 'Choose a subject to review your learning materials.',
          ),
          AdaptiveGrid(
            children: [
              for (var index = 0; index < _categories.length; index++)
                StudyTile(
                  title: _categories[index],
                  subtitle: 'Open study guide',
                  icon: Icons.menu_book_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PDFViewerPage(
                        pdfPath: 'assets/pdf/st${index + 1}.pdf',
                        title: _categories[index],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
