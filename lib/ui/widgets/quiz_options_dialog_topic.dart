import 'package:flutter/material.dart';
import '../pages/data/model/ElectricianQuestion.dart';

/// Returns the selected range to the topic screen before navigation begins.
class QuizOptionsDialogTopic extends StatefulWidget {
  const QuizOptionsDialogTopic({
    super.key,
    required this.category,
    required this.allQuestions,
  });

  final String category;
  final List<ElectricianQuestion> allQuestions;

  @override
  State<QuizOptionsDialogTopic> createState() => _QuizOptionsDialogTopicState();
}

class _QuizOptionsDialogTopicState extends State<QuizOptionsDialogTopic> {
  int _count = 30;
  int? _start;

  List<int> get _counts => {
    for (final count in [10, 20, 30, 40, 50])
      if (count <= widget.allQuestions.length) count,
    if (widget.allQuestions.isNotEmpty && widget.allQuestions.length < 50)
      widget.allQuestions.length,
  }.toList()..sort();

  @override
  void initState() {
    super.initState();
    if (_counts.isNotEmpty && !_counts.contains(_count)) {
      _count = _counts.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.allQuestions.length;
    return AlertDialog(
      title: Text(widget.category),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$total questions available'),
              const SizedBox(height: 16),
              if (total == 0)
                const Text('No questions available for this topic.')
              else ...[
                const Text('How many questions do you want to study?'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final count in _counts)
                      ChoiceChip(
                        label: Text('$count'),
                        selected: _count == count,
                        onSelected: (_) => setState(() {
                          _count = count;
                          _start = null;
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Choose a question range'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (var start = 0; start < total; start += _count)
                      ChoiceChip(
                        label: Text(
                          '${start + 1} – ${(start + _count).clamp(0, total)}',
                        ),
                        selected: _start == start,
                        onSelected: (_) => setState(() => _start = start),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _start == null
              ? null
              : () => Navigator.pop(
                  context,
                  widget.allQuestions.sublist(
                    _start!,
                    (_start! + _count).clamp(0, total),
                  ),
                ),
          child: const Text('Start Quiz'),
        ),
      ],
    );
  }
}
