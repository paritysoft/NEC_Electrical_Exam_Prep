import 'dart:io';

import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import '../../util/AppColors.dart';
import '../../util/app_constants.dart';
import '../pages/data/QuestionCache.dart';
import '../pages/data/model/ElectricianQuestion.dart';
import '../pages/error.dart';
import '../pages/quiz_page.dart';
import '../pages/quiz_page_timer.dart';


class QuizOptionsTimerDialog extends StatefulWidget {
  final String? category;
  const QuizOptionsTimerDialog({super.key, this.category});

  @override
  _QuizOptionsTimerDialogState createState() => _QuizOptionsTimerDialogState();
}

class _QuizOptionsTimerDialogState extends State<QuizOptionsTimerDialog> {
  int? noOfQuestions;
  int? timeForQuiz;
  String? _difficulty;
  late bool processing;

  @override
  void initState() {
    super.initState();
    noOfQuestions = 5;
    timeForQuiz = 40;
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
                    label: smallLabel(context,"5"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: noOfQuestions == 5
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectNumberOfQuestions(5),
                  ),
                  ActionChip(
                    label: smallLabel(context,"10"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: noOfQuestions == 10
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectNumberOfQuestions(10),
                  ),
                  ActionChip(
                    label: smallLabel(context,"15"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: noOfQuestions == 15
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectNumberOfQuestions(15),
                  ),
                  ActionChip(
                    label: smallLabel(context,"20"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: noOfQuestions == 20
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectNumberOfQuestions(20),
                  ),
                  // ActionChip(
                  //   label: smallLabel(context,"50"),
                  //   labelStyle: TextStyle(color: Colors.white),
                  //   backgroundColor: _noOfQuestions == 50
                  //       ? primary
                  //       : Colors.grey.shade600,
                  //   onPressed: () => _selectNumberOfQuestions(50),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            smallLabel(context, "Select Time"),
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
                    backgroundColor: timeForQuiz == 10
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectTime(10),
                  ),
                  ActionChip(
                    label: smallLabel(context,"20"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: timeForQuiz == 20
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectTime(20),
                  ),
                  ActionChip(
                    label: smallLabel(context,"30"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: timeForQuiz == 30
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectTime(30),
                  ),
                  ActionChip(
                    label: smallLabel(context,"40"),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: timeForQuiz == 40
                        ? primary
                        : Colors.grey.shade600,
                    onPressed: () => _selectTime(40),
                  ),
                  // ActionChip(
                  //   label: smallLabel(context,"50"),
                  //   labelStyle: TextStyle(color: Colors.white),
                  //   backgroundColor: _noOfQuestions == 50
                  //       ? primary
                  //       : Colors.grey.shade600,
                  //   onPressed: () => _selectNumberOfQuestions(50),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // smallLabel(context, "Select Difficulty"),
            // SizedBox(
            //   width: double.infinity,
            //   child: Wrap(
            //     alignment: WrapAlignment.center,
            //     runAlignment: WrapAlignment.center,
            //     runSpacing: 16.0,
            //     spacing: 16.0,
            //     children: <Widget>[
            //       SizedBox(width: 0.0),
            //       ActionChip(
            //         label: smallLabel(context, "Any"),
            //         labelStyle: TextStyle(color: Colors.white),
            //         backgroundColor: _difficulty == null
            //             ? primary
            //             : Colors.grey.shade600,
            //         onPressed: () => _selectDifficulty(null),
            //       ),
            //       ActionChip(
            //         label: smallLabel(context,"Easy"),
            //         labelStyle: TextStyle(color: Colors.white),
            //         backgroundColor: _difficulty == "easy"
            //             ? primary
            //             : Colors.grey.shade600,
            //         onPressed: () => _selectDifficulty("easy"),
            //       ),
            //       ActionChip(
            //         label: smallLabel(context, "Medium"),
            //         labelStyle: TextStyle(color: Colors.white),
            //         backgroundColor: _difficulty == "medium"
            //             ? primary
            //             : Colors.grey.shade600,
            //         onPressed: () => _selectDifficulty("medium"),
            //       ),
            //       ActionChip(
            //         label: smallLabel(context, "Hard"),
            //         labelStyle: TextStyle(color: Colors.white),
            //         backgroundColor: _difficulty == "hard"
            //             ? primary
            //             : Colors.grey.shade600,
            //         onPressed: () => _selectDifficulty("hard"),
            //       ),
            //     ],
            //   ),
            // ),
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
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      noOfQuestions = i;
    });
  }
  _selectTime(int i) {
    setState(() {
      timeForQuiz = i;
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
      List<ElectricianQuestion>? questions = QuestionCache().getQuestions();

      print("questions  ${questions?.length}    ${questions?.last.incorrectAnswer} ");
      Navigator.pop(context);
      if ((questions?.length ?? 0)< 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorPage(
                  message:
                      "There are not enough questions in the category, with the options you selected.",
                )));
        return;
      }
      if(questions != null) {
        loadRandomQuestions(questions, noOfQuestions ?? 10);
      }
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
  void loadRandomQuestions(List<ElectricianQuestion> questions, int count) async {
    List<ElectricianQuestion> randomQuestions = await getRandomQuestions(questions, count);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => QuizPageTimer(
              questions: randomQuestions,
              category: widget.category ?? "",
              playTime: (noOfQuestions ?? 1) * (timeForQuiz ?? 1),
            )));
    print(randomQuestions);
  }
}
