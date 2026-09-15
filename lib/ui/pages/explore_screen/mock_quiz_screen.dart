import 'package:electrician/ui/widgets/responsive_layout.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/AppColors.dart';
import '../data/QuestionCache.dart';
import '../data/model/ElectricianQuestion.dart';
import '../quiz_page.dart';
import '../subscription/PurchasePlanDialog.dart';
import '../subscription/subscription_service.dart';

class MockQuizScreen extends StatefulWidget {
  final bool isSubscribed;

  const MockQuizScreen({Key? key, required this.isSubscribed});

  @override
  State<MockQuizScreen> createState() => _MockQuizScreenState();
}

class _MockQuizScreenState extends State<MockQuizScreen> {
  // Example string array
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.isSubscribed;
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    await SubscriptionService.instance.refresh();
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSubscribed = prefs.getBool('isSubscribed') ?? false; // Default to false
      print("isSubscribed  ${isSubscribed}");
      //  purchasedPlan = prefs.getString('purchasedPlan') ?? ''; // Default to empty string
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = QuestionCache().getQuestions() ?? <ElectricianQuestion>[];
    final total = questions.length ~/ 20;
    return AppScaffold(
      appBar: appBarCustom(context, 'Mock Quiz'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              'Choose a mock test',
              subtitle: 'Practice with a focused set of 20 questions.',
            ),
            AdaptiveGrid(
              children: [
                for (var index = 0; index < total; index++)
                  StudyTile(
                    title: 'Mock Test ${index + 1}',
                    subtitle: '20 questions',
                    icon: Icons.quiz_outlined,
                    premium: true,
                    onTap: () {
                      if (!isSubscribed) {
                        PurchasePlanDialog.show(context).then((_) {
                          if (mounted) _checkSubscriptionStatus();
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPage(
                              questions: questions.sublist(
                                index * 20,
                                (index + 1) * 20,
                              ),
                              category: 'Mock Quiz ${index + 1}',
                            ),
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
            if (total == 0) const Text('No mock tests available yet.'),
          ],
        ),
      ),
    );
  }
}
