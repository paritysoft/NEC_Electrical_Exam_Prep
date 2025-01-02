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


    dbHelper.getQuestionByUUID("c9d8cf1c-0915-4b43-bee7-af514b9f4573").then((value) {
      print('Future finished successfully i.e. without error');
      print('QuestionByUUID: ${value?.givenAnswer}');
    }).catchError((error) {
      print('Future finished with error');
    }).whenComplete(() {
      print('Either of then or catchError has run at this point');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom(context, 'All Records List'),
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
                          // Handle on tap
                          List<ElectricianQuestion>? questions =
                              QuestionCache().getQuestions();
                          if (questions != null) {
                            List<ElectricianQuestion>? filterQuestions =
                                QuestionCache().filterQuestionsByCategory(
                                    questions, _categories[index]);

                            List<ElectricianQuestion>? filterQuestionByGivenAnswer =
                            QuestionCache().filterQuestionsByGivenAnswer(
                                filterQuestions);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => RecordsAnswersScreen(
                                          questions: filterQuestionByGivenAnswer,
                                        )));
                          }
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
