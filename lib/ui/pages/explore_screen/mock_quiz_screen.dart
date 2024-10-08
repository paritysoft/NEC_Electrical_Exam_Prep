import 'package:commonquiz/ui/widgets/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../util/AppColors.dart';
import '../data/QuestionCache.dart';
import '../data/model/ElectricianQuestion.dart';
import '../quiz_page.dart';

class MockQuizScreen extends StatefulWidget {
  @override
  State<MockQuizScreen> createState() => _MockQuizScreenState();
}

class _MockQuizScreenState extends State<MockQuizScreen> {
  // Example string array
  @override
  Widget build(BuildContext context) {

    List<ElectricianQuestion>? questions =
    QuestionCache().getQuestions();

    double totalItem = ((questions?.length ?? 0)  / 20);
    return Scaffold(
        appBar: appBarCustom(context, 'Mock Quiz'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 8.0, // Spacing between columns
              mainAxisSpacing: 8.0, // Spacing between rows
              childAspectRatio: 3 / 2, // Aspect ratio for each grid item
            ),
            itemCount:  totalItem.toInt(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  List<ElectricianQuestion>? questionsMock =
                  QuestionCache().getQuestions();
                  if (questionsMock != null) {
                    List<ElectricianQuestion>? questions = questionsMock.sublist((index+1)*20,(index+1)*20 + 20);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => QuizPage(
                              questions: questions,
                              category: "Mock Quiz ${index+1}",
                            )));
                  }
                },
                child: Card(
                  color: randomColor(),
                  elevation: 2, // Shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  child: index != totalItem  ? Center(
                      child: titleLabel(context,
                        "Mock Test ${index + 1}",
                      )) : null,
                ),
              );
            },
          ),
        ),
    );
  }
}