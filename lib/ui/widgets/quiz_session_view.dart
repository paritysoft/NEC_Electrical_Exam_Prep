import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'responsive_layout.dart';

class QuizSessionView extends StatelessWidget {
  const QuizSessionView({
    super.key,
    required this.question,
    required this.options,
    required this.index,
    required this.total,
    required this.selected,
    required this.onSelected,
    required this.onNext,
    this.timer,
  });
  final String question;
  final List<String> options;
  final int index, total;
  final String? selected;
  final ValueChanged<String> onSelected;
  final VoidCallback onNext;
  final Widget? timer;
  @override
  Widget build(BuildContext context) => ContentWidth(
    maxWidth: 980,
    child: LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        padding: EdgeInsets.all(box.maxWidth >= 700 ? 28 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (timer != null) ...[timer!, const SizedBox(height: 16)],
            Container(
              padding: EdgeInsets.all(box.maxWidth >= 700 ? 28 : 20),
              decoration: BoxDecoration(
                color: appNavy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}/$total',
                          style: const TextStyle(
                            color: appNavy,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Text(
                          HtmlUnescape().convert(question),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: box.maxWidth >= 700 ? 23 : 18,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (var i = 0; i < options.length; i++) ...[
                          RadioListTile<String>(
                            value: options[i],
                            groupValue: selected,
                            onChanged: (value) {
                              if (value != null) onSelected(value);
                            },
                            selected: selected == options[i],
                            selectedTileColor: appNavy.withValues(alpha: .045),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            title: Text(
                              options[i],
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Color(0xFF20252B),
                              ),
                            ),
                          ),
                          if (i < options.length - 1) const Divider(height: 1),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: box.maxWidth < 500 ? box.maxWidth - 32 : 160,
                ),
                child: FilledButton(
                  onPressed: onNext,
                  child: Text(index == total - 1 ? 'Submit' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
