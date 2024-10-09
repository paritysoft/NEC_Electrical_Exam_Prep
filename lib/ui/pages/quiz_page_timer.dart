import 'dart:async';

import 'package:commonquiz/ui/pages/quiz_finished.dart';
import 'package:commonquiz/ui/widgets/common_widget.dart';
import 'package:commonquiz/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';
import '../widgets/TimerScreen.dart';
import 'data/QuestionCache.dart';
import 'data/model/ElectricianQuestion.dart';

var isSetData = false;

class QuizPageTimer extends StatefulWidget {
  final List<ElectricianQuestion> questions;
  final String? category;
  final int? playTime;

  const QuizPageTimer(
      {Key? key, required this.questions, this.category, this.playTime})
      : super(key: key);

  @override
  _QuizPageTimerState createState() => _QuizPageTimerState();
}

class _QuizPageTimerState extends State<QuizPageTimer> {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.black);
  late Timer _timer;
  int remainingTime = 10;
  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  List<String> options = [];
  String? selectedAnswer;

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when widget is disposed
    super.dispose();
  }

  @override
  void initState() {
    // Load and shuffle the options only once in initState

    options = getShuffledOptions(widget.questions[_currentIndex]);
    startTimer();
    remainingTime = widget.playTime ?? 120;
    super.initState();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          _timer.cancel();
          // You can also add logic to auto-submit the quiz or show a message.
          print("Time's up!");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //   ElectricianQuestion question = widget.questions[_currentIndex];
    // //  final List<dynamic> options = question.incorrectAnswer as List;
    //   List<dynamic> options = jsonDecode(question.incorrectAnswer);
    //
    //
    //   if (!options.contains(question.correctAnswer)) {
    //     options.add(question.correctAnswer);
    //       options.shuffle();
    //       isSetData = true;
    //
    //   }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: appBarCustom(context, widget.category ?? ""),
        body: Stack(
          children: <Widget>[
            // ClipPath(
            //   clipper: WaveClipperTwo(),
            //   child: Container(
            //     decoration:
            //         BoxDecoration(color: Theme.of(context).primaryColor),
            //     height: 300,
            //   ),
            // ),

            // Text(
            //   formatTime(_remainingTime),
            //   style: const TextStyle(fontSize: 24),
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TimerWidget(initialTime: remainingTime),
                  Card(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: smallLabel(context,
                              "${_currentIndex + 1}/${widget.questions.length}",
                              color: Colors.black, textSize: 10),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            HtmlUnescape().convert(
                                widget.questions[_currentIndex].question),
                            softWrap: true,
                            style: MediaQuery.of(context).size.width > 800
                                ? _questionStyle.copyWith(fontSize: 20.0)
                                : _questionStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...options.map((option) => RadioListTile(
                              title: smallLabel(context, option),
                              groupValue: _answers[_currentIndex],
                              value: option,
                              onChanged: (dynamic value) {
                                setState(() {
                                  _answers[_currentIndex] = option;
                                });
                              },
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: MediaQuery.of(context).size.width > 800
                              ? const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 64.0)
                              : null,
                        ),
                        child: smallLabel(
                            context,
                            _currentIndex == (widget.questions.length - 1)
                                ? "Submit"
                                : "Next",
                            color: primary),
                        onPressed: _nextSubmit,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: smallLabel(context, "You must select an answer to continue."),
      ));
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
        options = getShuffledOptions(widget.questions[_currentIndex]);
      });
    } else {
      _timer.cancel();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: widget.questions, answers: _answers)));
    }
  }

  Future<bool> _onWillPop() async {
    final resp = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: smallLabel(context,
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: smallLabel(context, "Warning!"),
            actions: <Widget>[
              TextButton(
                child: smallLabel(context, "Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: smallLabel(context, "No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
    return resp ?? false;
  }
}
