import 'dart:async';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import '../data/today_questions_service.dart';
import '../../widgets/common_widget.dart';
import '../../widgets/quiz_options_dialog.dart';
import '../../widgets/quiz_options_timer_dialog.dart';
import '../../widgets/responsive_layout.dart';
import '../data/QuestionCache.dart';
import '../quiz_page_today.dart';
import '../subscription/PurchasePlanDialog.dart';
import '../subscription/subscription_service.dart';
import 'mock_quiz_screen.dart';
import 'practice_by_topic_screen.dart';
import 'records_screen.dart';
import 'your_questions_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _readToday = 0;
  Timer? _dailyTimer;
  bool get _subscribed => SubscriptionService.instance.isSubscribed;
  @override
  void initState() {
    super.initState();
    requestTrackingPermission();
    _refresh();
    _dailyTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _refreshDailyProgress(),
    );
  }

  @override
  void dispose() {
    _dailyTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshDailyProgress() async {
    final read = await TodayQuestionsService().getQuestionsReadToday();
    if (mounted && read != _readToday) setState(() => _readToday = read);
  }

  Future<void> _refresh() async {
    await SubscriptionService.instance.refresh();
    await _refreshDailyProgress();
  }

  Future<void> _open(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    if (mounted) await _refresh();
  }

  Future<void> _purchase() async {
    await PurchasePlanDialog.show(context);
    if (mounted) await _refresh();
  }

  void _premium(VoidCallback action) {
    if (_subscribed) {
      action();
    } else {
      _purchase();
    }
  }

  Future<void> _options({bool timed = false}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .85,
        ),
        child: timed
            ? const QuizOptionsTimerDialog(category: 'Time Quiz')
            : QuizOptionsDialog(
                category: 'Random Question',
                isSubscribed: _subscribed,
              ),
      ),
    );
    if (mounted) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final mobile =
        platform == TargetPlatform.iOS || platform == TargetPlatform.android;
    final count = QuestionCache().getQuestions()?.length;
    return LayoutBuilder(
      builder: (context, bounds) => SingleChildScrollView(
        padding: EdgeInsets.all(bounds.maxWidth >= 700 ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(bounds.maxWidth >= 700 ? 28 : 22),
                decoration: BoxDecoration(
                  color: appNavy,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prepare with confidence',
                      style: TextStyle(
                        fontSize: bounds.maxWidth >= 700 ? 30 : 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Practice, review explanations, and build exam-ready knowledge at your own pace.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _badge(
                          count == null
                              ? 'NEC exam practice'
                              : '$count Questions',
                        ),
                        _badge('Learn at your own pace'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const SectionHeading('Keep learning'),
            ],
            Card(
              margin: EdgeInsets.zero,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _open(const QuizPageToday(category: 'Today Quiz')),
                child: Padding(
                  padding: EdgeInsets.all(mobile ? 14 : 22),
                  child: Row(
                    children: [
                      const Icon(Icons.flag_rounded, color: appNavy, size: 32),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Task',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              '10 Questions',
                              style: TextStyle(color: appMuted),
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: (_readToday / 10).clamp(0.0, 1.0),
                              minHeight: 5,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                const Text('Progress'),
                                Text('$_readToday/10'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!mobile) ...[
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _subscribed
                      ? snackBar(context, 'All your features are unlocked')
                      : _purchase(),
                  icon: const Icon(Icons.stars_rounded),
                  label: Text(
                    _subscribed
                        ? 'All features unlocked'
                        : 'Learn Without Limits',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: mobile ? 18 : 30),
            if (mobile)
              const SectionHeading('Study tools')
            else
              const SectionHeading(
                'Choose how you want to study',
                subtitle:
                    'Open a study tool and continue your exam preparation.',
              ),
            AdaptiveGrid(
              minItemWidth: 220,
              children: [
                StudyTile(
                  compact: mobile,
                  title: 'Random Question',
                  subtitle: _subscribed
                      ? 'Unlimited practice'
                      : '5 Easy questions, anytime',
                  icon: Icons.shuffle_rounded,
                  onTap: _options,
                ),
                StudyTile(
                  compact: mobile,
                  title: 'Practice By Topic',
                  subtitle: count == null
                      ? 'Explore your question bank'
                      : '$count Questions',
                  icon: Icons.topic_outlined,
                  premium: true,
                  onTap: () =>
                      _open(PracticeByTopic(isSubscribed: _subscribed)),
                ),
                StudyTile(
                  compact: mobile,
                  title: 'Mock Quiz',
                  subtitle: 'Build confidence for exam day',
                  icon: Icons.quiz_outlined,
                  premium: true,
                  onTap: () => _open(MockQuizScreen(isSubscribed: _subscribed)),
                ),
                StudyTile(
                  compact: mobile,
                  title: 'Time Quiz',
                  subtitle: 'Practice against the clock',
                  icon: Icons.timelapse,
                  premium: true,
                  onTap: () => _premium(() => _options(timed: true)),
                ),
                StudyTile(
                  compact: mobile,
                  title: 'Your Questions',
                  subtitle: 'Review your saved questions',
                  icon: Icons.bookmark_outline,
                  premium: true,
                  onTap: () => _premium(() => _open(YourQuestionsScreen())),
                ),
                StudyTile(
                  compact: mobile,
                  title: 'Records',
                  subtitle: 'Review your achievements',
                  icon: Icons.inventory_2_outlined,
                  premium: true,
                  onTap: () => _premium(() => _open(RecordsScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .14),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
  );
}

Future<void> requestTrackingPermission() async {
  if (!Platform.isIOS) return;
  if (await AppTrackingTransparency.trackingAuthorizationStatus ==
      TrackingStatus.notDetermined) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}
