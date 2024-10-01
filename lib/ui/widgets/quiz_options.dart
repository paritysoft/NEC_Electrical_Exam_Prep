import 'dart:io';
import 'package:commonquiz/ui/widgets/common_widget.dart';
import 'package:commonquiz/util/AppColors.dart';
import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../resources/api_provider.dart';
import '../pages/error.dart';
import '../pages/quiz_page.dart';
import '../pages/upadansonghro/DatabaseHelper.dart';
import '../pages/upadansonghro/model/ElectricianQuestion.dart';
import '../pages/upadansonghro/upadansonghro.dart';

class QuizOptionsDialog extends StatefulWidget {
  final String? category;

  const QuizOptionsDialog({super.key, this.category});

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int? _noOfQuestions;
  String? _difficulty;
  late bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: background,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey.shade200,
              child: title15BoldColor(context,
                widget.category ?? "", color: Colors.black87
              ),
            ),
            SizedBox(height: 10.0),
            smallLabel(context, "Select Total Number of Questions"),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 16.0,
                spacing: 16.0,
                children: <Widget>[
                  SizedBox(width: 0.0),
                  ActionChip(
                    label: smallLabel(context,"10"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: _noOfQuestions == 10
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectNumberOfQuestions(10),
                  ),
                  ActionChip(
                    label: smallLabel(context,"20"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: _noOfQuestions == 20
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectNumberOfQuestions(20),
                  ),
                  ActionChip(
                    label: smallLabel(context,"30"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: _noOfQuestions == 30
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectNumberOfQuestions(30),
                  ),
                  ActionChip(
                    label: smallLabel(context,"40"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: _noOfQuestions == 40
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectNumberOfQuestions(40),
                  ),
                  ActionChip(
                    label: smallLabel(context,"50"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: _noOfQuestions == 50
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectNumberOfQuestions(50),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            smallLabel(context, "Select Difficulty"),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 16.0,
                spacing: 16.0,
                children: <Widget>[
                  SizedBox(width: 0.0),
                  ActionChip(
                    label: smallLabel(context, "Any"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: _difficulty == null
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectDifficulty(null),
                  ),
                  ActionChip(
                    label: smallLabel(context,"Easy"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: _difficulty == "easy"
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectDifficulty("easy"),
                  ),
                  ActionChip(
                    label: smallLabel(context, "Medium"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: _difficulty == "medium"
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectDifficulty("medium"),
                  ),
                  ActionChip(
                    label: smallLabel(context, "Hard"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: _difficulty == "hard"
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectDifficulty("hard"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            processing
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: title15BoldColor(context, "Start Quiz", color: Colors.white),
                    onPressed: _startQuiz,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.amber[600]!),
                  ),

                ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String? s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      List<ElectricianQuestion> questions =
          await UpadanSonghro().getAllQuestions();
      print("questions  ${questions.length}    ${questions.last.incorrectAnswer} ");
      Navigator.pop(context);
      if (questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorPage(
                  message:
                      "There are not enough questions in the category, with the options you selected.",
                )));
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => QuizPage(
                    questions: questions,
                    category: widget.category ?? "",
                  )));
    } on SocketException catch (_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message:
                        "Can't reach the servers, \n Please check your internet connection.",
                  )));
    } catch (e) {
      print(e.toString());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message: "Unexpected error trying to connect to the API",
                  )));
    }
    setState(() {
      processing = false;
    });
  }
}
