import 'dart:async';
import '../widgets/quiz_session_view.dart';
import 'package:electrician/ui/pages/quiz_finished.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'data/QuestionCache.dart';
import 'data/model/ElectricianQuestion.dart';
import 'data/today_questions_service.dart';

var isSetData = false;

class QuizPageToday extends StatefulWidget {
  final String? category;

  const QuizPageToday({Key? key, this.category}) : super(key: key);

  @override
  _QuizPageTodayState createState() => _QuizPageTodayState();
}

class _QuizPageTodayState extends State<QuizPageToday> {
  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  List<String> options = [];
  String? selectedAnswer;
  TodayQuestionsService? questionService;
  bool _saving = false;
  Timer? _dayTimer;
  String? _loadedDay;
  List<ElectricianQuestion> questions10 = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _dayTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_loadedDay != null && _loadedDay != questionService?.currentDay) {
        _loadedDay = null;
        _loadData();
      }
    });
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    QuestionCache questionCache = QuestionCache();
    List<ElectricianQuestion>? questionList = questionCache.getQuestions();

    if (questionList == null || questionList.isEmpty) return;
    questionService ??= TodayQuestionsService();
    final loadedQuestions = await questionService!.getTodaysQuestions(
      questionList,
    );
    if (!mounted) return;
    setState(() {
      questions10 = loadedQuestions;
      _answers
        ..clear()
        ..addAll(questionService!.answers);
      _currentIndex = _answers.length.clamp(0, questions10.length);
      _loadedDay = questionService!.currentDay;
      if (_currentIndex < questions10.length) {
        options = getShuffledOptions(questions10[_currentIndex]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: appBarCustom(context, widget.category ?? 'Quiz'),
        body: questions10.isEmpty || _currentIndex >= questions10.length
            ? Center(
                child: Text(
                  questions10.isEmpty
                      ? 'No questions available.'
                      : 'Daily quiz complete! Come back tomorrow for 10 new questions.',
                ),
              )
            : QuizSessionView(
                question: questions10[_currentIndex].question,
                options: options,
                index: _currentIndex,
                total: questions10.length,
                selected: _answers[_currentIndex] as String?,
                onSelected: (value) =>
                    setState(() => _answers[_currentIndex] = value),
                onNext: _nextSubmit,
              ),
      ),
    );
  }

  Future<void> _nextSubmit() async {
    if (_saving) return;
    if (_answers[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: smallLabel(
            context,
            "You must select an answer to continue.",
            color: Colors.white,
          ),
        ),
      );
      return;
    }
    _saving = true;
    final saved = await questionService!.saveAnswers(_answers);
    _saving = false;
    if (!mounted) return;
    if (!saved) {
      await _loadData();
      return;
    }
    if (_currentIndex < (questions10.length - 1)) {
      setState(() {
        _currentIndex++;
        options = getShuffledOptions(questions10[_currentIndex]);
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              QuizFinishedPage(questions: questions10, answers: _answers),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    final resp = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: smallLabel(
            context,
            "Are you sure you want to quit the quiz? Your completed answers are saved for today.",
          ),
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
      },
    );
    return resp ?? false;
  }
}
