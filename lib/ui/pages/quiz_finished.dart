import 'package:electrician/ui/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import '../../util/AppColors.dart';
import '../widgets/common_widget.dart';
import 'analysis_screen/ScoreBarChart.dart';
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
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    // Persist each answer once; resizing a desktop window rebuilds the view.
    widget.answers.forEach((index, value) {
      final correct = widget.questions[index].correctAnswer == value;
      if (correct) correctAnswers++;
      saveAddData(
        widget.questions[index],
        value,
        correct ? 1 : 0,
        correct ? 0 : 1,
      );
    });
  }

  Future<void> saveAddData(
    ElectricianQuestion question,
    String givenAnswer,
    int correctCount,
    int incorrectCount,
  ) async {
    final upadanSonghro = await UpadanSonghro();
    upadanSonghro.updateQuestion(
      question,
      givenAnswer,
      correctCount,
      incorrectCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final correct = correctAnswers;
    final percent = widget.questions.isEmpty
        ? 0
        : (correct / widget.questions.length * 100).round();
    return AppScaffold(
      maxWidth: 980,
      appBar: appBarCustom(context, 'Quiz Results'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeading(
              'Your results',
              subtitle: 'Review your answers and keep building your knowledge.',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      percent >= 70
                          ? Icons.emoji_events_outlined
                          : Icons.school_outlined,
                      size: 48,
                      color: appNavy,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: appNavy,
                      ),
                    ),
                    Text(
                      percent >= 70
                          ? 'Well done! You passed.'
                          : 'Keep practicing. You can try again.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            AdaptiveGrid(
              minItemWidth: 180,
              children: [
                _stat('Total questions', '${widget.questions.length}'),
                _stat('Correct answers', '$correct'),
                _stat(
                  'Incorrect answers',
                  '${widget.questions.length - correct}',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go to Home'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CheckAnswersPage(
                        questions: widget.questions,
                        answers: widget.answers,
                      ),
                    ),
                  ),
                  child: const Text('Check Answers'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String title, String value) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: appNavy,
            ),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    ),
  );
}
