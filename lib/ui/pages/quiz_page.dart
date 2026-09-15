import '../widgets/quiz_session_view.dart';
import 'package:electrician/ui/pages/quiz_finished.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:electrician/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';
import 'data/QuestionCache.dart';
import 'data/model/ElectricianQuestion.dart';

var isSetData = false;

class QuizPage extends StatefulWidget {
  final List<ElectricianQuestion> questions;
  final String? category;

  const QuizPage({Key? key, required this.questions, this.category})
    : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextStyle _questionStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  List<String> options = [];
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    // Load and shuffle the options only once in initState
    if (widget.questions.isNotEmpty)
      options = getShuffledOptions(widget.questions[_currentIndex]);
    print("questions options   $options  ${options.length}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: appBarCustom(context, widget.category ?? 'Quiz'),
        body:
            widget.questions.isEmpty || _currentIndex >= widget.questions.length
            ? const Center(child: Text('No questions available.'))
            : QuizSessionView(
                question: widget.questions[_currentIndex].question,
                options: options,
                index: _currentIndex,
                total: widget.questions.length,
                selected: _answers[_currentIndex] as String?,
                onSelected: (value) =>
                    setState(() => _answers[_currentIndex] = value),
                onNext: _nextSubmit,
              ),
      ),
    );
  }

  void _nextSubmit() {
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
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
        options = getShuffledOptions(widget.questions[_currentIndex]);
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              QuizFinishedPage(questions: widget.questions, answers: _answers),
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
            "Are you sure you want to quit the quiz? All your progress will be lost.",
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
