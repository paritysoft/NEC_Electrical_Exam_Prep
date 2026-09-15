import 'package:electrician/ui/widgets/responsive_layout.dart';
import 'package:electrician/ui/pages/data/upadansonghro.dart';
import 'package:electrician/ui/pages/explore_screen/records_answers_screen.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import '../../../util/AppColors.dart';
import '../data/QuestionCache.dart';
import '../data/model/ElectricianQuestion.dart';
import '../quiz_page.dart';

class RecordsScreen extends StatefulWidget {
  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<String> _categories = []; // List to store categories
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchUniqueCategories(); // Fetch categories when the screen loads
  }

  Future<void> _fetchUniqueCategories() async {
    UpadanSonghro dbHelper = UpadanSonghro();
    List<String> categories = await dbHelper.getUniqueCategories();
    setState(() {
      _categories = categories; // Update categories list
      _isLoading = false; // Stop the loading indicator
    });

    dbHelper
        .getQuestionByUUID("c9d8cf1c-0915-4b43-bee7-af514b9f4573")
        .then((value) {
          print('Future finished successfully i.e. without error');
          print('QuestionByUUID: ${value?.givenAnswer}');
        })
        .catchError((error) {
          print('Future finished with error');
        })
        .whenComplete(() {
          print('Either of then or catchError has run at this point');
        });
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    appBar: appBarCustom(context, 'Records'),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  'Your study records',
                  subtitle: 'Review your answers by topic.',
                ),
                AdaptiveGrid(
                  minItemWidth: 250,
                  children: [
                    for (final category in _categories)
                      Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          title: Text(category),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final questions = await UpadanSonghro()
                                .getQuestionsByCategory(category);
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecordsAnswersScreen(
                                  questions: QuestionCache()
                                      .filterQuestionsByGivenAnswer(
                                        questions ?? [],
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
  );
}
