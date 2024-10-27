import 'package:commonquiz/ui/pages/explore_screen/explore_screen.dart';
import 'package:flutter/material.dart';

import '../../models/question.dart';
import '../../util/AppColors.dart';
import '../widgets/common_widget.dart';
import 'check_answers.dart';
import 'data/QuestionCache.dart';
import 'data/model/ElectricianQuestion.dart';
import 'data/upadansonghro.dart';

class QuizFinishedPage extends StatefulWidget {
  final List<ElectricianQuestion> questions;
  final Map<int, dynamic> answers;

  QuizFinishedPage({Key? key, required this.questions, required this.answers})
      : super(key: key);

  @override
  _QuizFinishedPageState createState() => _QuizFinishedPageState();
}

class _QuizFinishedPageState extends State<QuizFinishedPage> {
  int? correctAnswers;

  @override
  void initState() {
    super.initState();

  }

  Future<void> saveAddData(ElectricianQuestion question, String givenAnswer, int correctCount, int incorrectCount) async {
    final upadanSonghro = await  UpadanSonghro();
    upadanSonghro.updateQuestion(question, givenAnswer,correctCount, incorrectCount );

  }
  @override
  Widget build(BuildContext context) {

    int correct = 0;
    this.widget.answers.forEach((index, value) {
      if (cleanedString(this.widget.questions[index].correctAnswer)
              .replaceAll('"', '') ==
          value) {
        correct++;
        print("Answers correct  ${this.widget.answers[index]}");
        saveAddData(this.widget.questions[index], value, 1, 0);
      }else{
        print("Answers incorrect Answers ${this.widget.answers[index]}");
        saveAddData(this.widget.questions[index], value, 0, 1);
      }
    });

    return Scaffold(
      appBar: appBarCustom(context, 'Result'),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: smallLabel(context, "Total Questions"),
                  trailing: trailingStyle(
                    context,
                    "${widget.questions.length}",
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: smallLabel(
                    context,
                    "Score",
                  ),
                  trailing: trailingStyle(
                    context,
                    "${(correct / widget.questions.length * 100).toInt()}%",
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: smallLabel(
                    context,
                    "Correct Answers",
                  ),
                  trailing: trailingStyle(
                    context,
                    "$correct/${widget.questions.length}",
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: smallLabel(
                    context,
                    "Incorrect Answers",
                  ),
                  trailing: trailingStyle(
                    context,
                    "${widget.questions.length - correct}/${widget.questions.length}",
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.8),
                    ),
                    child:
                        smallLabel(context, "Goto Home", color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: smallLabel(context, "Check Answers",
                        color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CheckAnswersPage(
                                questions: widget.questions,
                                answers: widget.answers,
                              )));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
