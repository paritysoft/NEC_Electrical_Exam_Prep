import 'package:electrician/ui/pages/quiz_finished.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:electrician/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/QuestionCache.dart';
import 'data/model/ElectricianQuestion.dart';
import 'data/today_questions_service.dart';

var isSetData = false;

class QuizPageToday extends StatefulWidget {
  final String? category;

  const QuizPageToday({Key? key, this.category})
      : super(key: key);

  @override
  _QuizPageTodayState createState() => _QuizPageTodayState();
}

class _QuizPageTodayState extends State<QuizPageToday> {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  List<String> options = [];
  String? selectedAnswer;
  TodayQuestionsService? questionService;
  int questionsReadToday = 0;
  List<ElectricianQuestion> questions10 = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }


  Future<void> _loadData() async {
    QuestionCache questionCache = QuestionCache();
    List<ElectricianQuestion>? questionList = questionCache.getQuestions();

    print("questionList length: ${questionList?.length}");

    if (questionList == null || questionList.isEmpty) {
      print("No questions available to load.");
      return;
    }

    questionService = TodayQuestionsService();

    try {
      // Fetch today's questions
      List<ElectricianQuestion>? loadedQuestions = await questionService?.getTodaysQuestions(questionList);

      // Ensure state is updated with the loaded questions
      setState(() {
        questions10 = loadedQuestions ?? [];
      });

      // Log the result
      if (questions10.isEmpty) {
        print("No questions available for today.");
      } else {
        print("Loaded ${questions10.length} questions for today.");
      }
    } catch (e) {
      print("Error loading questions: $e");
    }
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      questionsReadToday = prefs.getInt('questions_read_today') ?? 0;
      _currentIndex = questionsReadToday;
    });
    options = getShuffledOptions(questions10[_currentIndex]);

  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: appBarCustom(context, widget.category ?? ""),
        body: questions10.isEmpty || _currentIndex > 9
            ? Center(child: Text('No questions available for today.'))
            : Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: smallLabel(context, "${_currentIndex + 1}/${questions10.length}", color: Colors.black, textSize: 10),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          HtmlUnescape().convert(
                              questions10[_currentIndex].question ?? ""),
                          softWrap: true,
                          style: MediaQuery.of(context).size.width > 800
                              ? _questionStyle.copyWith(fontSize: 30.0)
                              : _questionStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...options.map((option) => RadioListTile(
                              title: smallLabel(context, option ),
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
                        child: smallLabel(context,
                          _currentIndex == ((questions10?.length ?? 0)- 1)
                              ? "Submit"
                              : "Next", color: primary
                        ),
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
    if (_currentIndex < (questions10.length - 1)) {
      setState(() {
        _currentIndex++;
        options = getShuffledOptions(questions10[_currentIndex]);
      });
      questionService?.updateQuestionsReadToday(_currentIndex);
    } else {
      questionService?.updateQuestionsReadToday(_currentIndex+1);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: questions10, answers: _answers)));
    }
  }

  Future<bool> _onWillPop() async {
    final resp = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: smallLabel(context,
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: smallLabel(context,"Warning!"),
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
