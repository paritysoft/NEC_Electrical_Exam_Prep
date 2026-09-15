import 'package:flutter/material.dart';
import '../../widgets/responsive_layout.dart';
import '../data/upadansonghro.dart';
import 'CategoryQuestionDataList.dart';
import 'CompletionChart.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});
  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late final _stats = UpadanSonghro().getCompletionStats();
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width >= 700 ? 32 : 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          'Your progress',
          subtitle: 'See what you have learned and where to focus next.',
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FutureBuilder<Map<String, int>>(
              future: _stats,
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Text(
                    'Progress is unavailable. Please try again later.',
                  );
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                return CompletionProgress(
                  answered: snapshot.data!['answered'] ?? 0,
                  total: snapshot.data!['total'] ?? 0,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
        const SectionHeading('Progress by topic'),
        CategoryQuestionDataList(),
      ],
    ),
  );
}
