import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:electrician/util/AppColors.dart';
import 'package:flutter/material.dart';
import '../pages/data/QuestionCache.dart';
import '../pages/data/model/ElectricianQuestion.dart';
import '../pages/error.dart';
import '../pages/quiz_page.dart';

class QuizOptionsDialog extends StatefulWidget {
  final String? category;
  final bool isSubscribed;
  const QuizOptionsDialog({
    super.key,
    this.category,
    required this.isSubscribed,
  });

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int? noOfQuestions;
  String? _difficulty;
  late bool processing;

  @override
  void initState() {
    super.initState();
    noOfQuestions = 5;
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
              child: title15BoldColor(
                context,
                widget.category ?? "",
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.0),
            smallLabel(
              context,
              widget.isSubscribed
                  ? "For premium users, all features are unlocked."
                  : "Free: 5 Easy questions per quiz, as often as you like. Locked options require Premium.",
              textSize: 15,
            ),
            smallLabel(context, "Select Total Number of Questions"),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 16.0,
                spacing: 16.0,
                children: [
                  for (final count in [5, 10, 15, 20])
                    _optionChip(
                      '$count',
                      noOfQuestions == count,
                      widget.isSubscribed || count == 5,
                      () => _selectNumberOfQuestions(count),
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
                children: [
                  _optionChip(
                    'Any',
                    _difficulty == null,
                    widget.isSubscribed,
                    () => _selectDifficulty(null),
                  ),
                  _optionChip(
                    'Easy',
                    _difficulty == 'easy',
                    true,
                    () => _selectDifficulty('easy'),
                  ),
                  _optionChip(
                    'Medium',
                    _difficulty == 'medium',
                    widget.isSubscribed,
                    () => _selectDifficulty('medium'),
                  ),
                  _optionChip(
                    'Hard',
                    _difficulty == 'hard',
                    widget.isSubscribed,
                    () => _selectDifficulty('hard'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            processing
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: title15BoldColor(
                      context,
                      "Start Quiz",
                      color: Colors.white,
                    ),
                    onPressed: _startQuiz,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        primary,
                      ),
                    ),
                  ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _optionChip(
    String label,
    bool selected,
    bool enabled,
    VoidCallback onPressed,
  ) {
    return ActionChip(
      label: smallLabel(
        context,
        label,
        color: enabled ? Colors.white : Colors.grey.shade700,
      ),
      avatar: enabled
          ? null
          : Icon(Icons.lock_outline, size: 14, color: Colors.grey.shade700),
      tooltip: enabled ? label : '$label — Premium only',
      backgroundColor: selected ? primary : Colors.grey.shade600,
      disabledColor: Colors.grey.shade200,
      onPressed: enabled ? onPressed : null,
    );
  }

  void _selectNumberOfQuestions(int count) {
    if (!widget.isSubscribed && count != 5) return;
    setState(() => noOfQuestions = count);
  }

  void _selectDifficulty(String? difficulty) {
    if (!widget.isSubscribed && difficulty != 'easy') return;
    setState(() => _difficulty = difficulty);
  }

  Future<void> _startQuiz() async {
    if (processing) return;
    setState(() => processing = true);
    final navigator = Navigator.of(context);
    final category = widget.category ?? '';
    try {
      final questions = await selectRandomQuizQuestions(
        QuestionCache().getQuestions() ?? [],
        isSubscribed: widget.isSubscribed,
        count: noOfQuestions ?? 5,
        difficulty: _difficulty,
      );
      if (!mounted) return;
      navigator.pop();
      navigator.push(
        MaterialPageRoute(
          builder: (_) => questions.isEmpty
              ? ErrorPage(
                  message:
                      'There are no questions available for the selected difficulty.',
                )
              : QuizPage(questions: questions, category: category),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => processing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to start the quiz. Please try again.'),
        ),
      );
    }
  }
}

/// Free quizzes can be repeated without a daily or lifetime attempt limit.
Future<List<ElectricianQuestion>> selectRandomQuizQuestions(
  List<ElectricianQuestion> questions, {
  required bool isSubscribed,
  required int count,
  String? difficulty,
}) {
  final selectedDifficulty = isSubscribed ? difficulty : 'easy';
  final level = switch (selectedDifficulty) {
    'easy' => 1,
    'medium' => 2,
    'hard' => 3,
    _ => null,
  };
  final eligible = level == null
      ? questions
      : questions.where((question) => question.level == level).toList();
  return getRandomQuestions(eligible, isSubscribed ? count : 5);
}
