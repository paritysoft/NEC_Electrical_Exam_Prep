import '../../widgets/responsive_layout.dart';
import 'package:electrician/ui/pages/data/upadansonghro.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/quiz_options_dialog_topic.dart';
import '../data/QuestionCache.dart';
import '../data/model/ElectricianQuestion.dart';
import '../quiz_page.dart';
import '../subscription/PurchasePlanDialog.dart';
import '../subscription/subscription_service.dart';

class PracticeByTopic extends StatefulWidget {
  final bool isSubscribed;

  PracticeByTopic({Key? key, required this.isSubscribed});

  @override
  _PracticeByTopicState createState() => _PracticeByTopicState();
}

class _PracticeByTopicState extends State<PracticeByTopic> {
  List<String> _categories = []; // List to store categories
  bool _isLoading = true; // Loading state
  // Loading state
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.isSubscribed;
    _checkSubscriptionStatus();
    _fetchUniqueCategories(); // Fetch categories when the screen loads
  }

  Future<void> _checkSubscriptionStatus() async {
    await SubscriptionService.instance.refresh();
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSubscribed = prefs.getBool('isSubscribed') ?? false; // Default to false
      print("isSubscribed  $isSubscribed");
      //  purchasedPlan = prefs.getString('purchasedPlan') ?? ''; // Default to empty string
    });
  }

  Future<void> _fetchUniqueCategories() async {
    UpadanSonghro dbHelper = UpadanSonghro();
    List<String> categories = await dbHelper.getUniqueCategories();

    if (!mounted) return;
    setState(() {
      _categories = categories; // Update categories list
      _isLoading = false; // Stop the loading indicator
    });
  }

  Future<void> _openTopic(String topic) async {
    if (!isSubscribed) {
      PurchasePlanDialog.show(context).then((_) {
        if (mounted) _checkSubscriptionStatus();
      });
      return;
    }
    final questions = QuestionCache().getQuestions();
    if (questions == null) return;
    final selectedQuestions = await showDialog<List<ElectricianQuestion>>(
      context: context,
      builder: (_) => QuizOptionsDialogTopic(
        category: topic,
        allQuestions: QuestionCache().filterQuestionsByCategory(
          questions,
          topic,
        ),
      ),
    );
    if (!mounted || selectedQuestions == null || selectedQuestions.isEmpty) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(questions: selectedQuestions, category: topic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    appBar: appBarCustom(context, 'Practice By Topic'),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : TopicSelectionView(topics: _categories, onSelected: _openTopic),
  );
}

class TopicSelectionView extends StatelessWidget {
  const TopicSelectionView({
    super.key,
    required this.topics,
    required this.onSelected,
  });
  final List<String> topics;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width >= 700 ? 32 : 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          'Choose a topic',
          subtitle: 'Select a topic to start your practice session.',
        ),
        if (topics.isEmpty) const Text('No topics available yet.'),
        AdaptiveGrid(
          minItemWidth: 250,
          children: [
            for (var index = 0; index < topics.length; index++)
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  title: Text('${index + 1}. ${topics[index]}'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => onSelected(topics[index]),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
