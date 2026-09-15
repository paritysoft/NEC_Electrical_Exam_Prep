import 'package:shared_preferences/shared_preferences.dart';
import 'package:electrician/util/app_constants.dart';
import 'package:flutter/material.dart';
import '../../../util/AppColors.dart';
import '../data/QuestionCache.dart';
import '../home_updated.dart';
import 'custom_onboarding_page_view_model.dart';

class OnboardingScreen extends StatefulWidget {
  static const String id = 'onboarding screen';
  const OnboardingScreen({super.key, this.onComplete, this.prepareQuestions});

  final VoidCallback? onComplete;
  final Future<void> Function()? prepareQuestions;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  bool _moving = false;
  bool _finished = false;

  static const _pages = [
    CustomOnboardingPageViewModel(
      imageUrl: 'assets/images/onbImage1.jpg',
      modelTitle: onboardT1,
      modelDescription: onboardD1,
    ),
    CustomOnboardingPageViewModel(
      imageUrl: 'assets/images/onbImage2.jpg',
      modelTitle: onboardT2,
      modelDescription: onboardD2,
    ),
    CustomOnboardingPageViewModel(
      imageUrl: 'assets/images/onbImage3.jpg',
      modelTitle: onboardT3,
      modelDescription: onboardD3,
    ),
    CustomOnboardingPageViewModel(
      imageUrl: 'assets/images/onbImage4.jpg',
      modelTitle: onboardT4,
      modelDescription: onboardD4,
    ),
  ];

  Future<void> _goTo(int index) async {
    if (_moving || _finished || index < 0 || index >= _pages.length) return;
    setState(() => _moving = true);
    await _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
    if (mounted) setState(() => _moving = false);
  }

  Future<void> _complete() async {
    if (_finished) return;
    setState(() => _finished = true);
    try {
      if (widget.onComplete == null || widget.prepareQuestions != null) {
        await (widget.prepareQuestions ?? loadQuestions)();
      }
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setBool('onboarding_completed', true)) {
        throw StateError('Could not save onboarding completion');
      }
      if (!mounted) return;
      if (widget.onComplete != null) {
        widget.onComplete!();
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const QuizHomePage()),
      );
    } catch (error, stackTrace) {
      debugPrint('Unable to complete onboarding: $error\n$stackTrace');
      if (!mounted) return;
      setState(() => _finished = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load your questions. Please try again.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lastPage = _page == _pages.length - 1;
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 16, 0),
                  child: Row(
                    children: [
                      Icon(Icons.bolt_rounded, color: primary, size: 24),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'NEC • 2027',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            color: Color(0xFF202632),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _finished ? null : _complete,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(72, 48),
                          foregroundColor: const Color(0xFF505867),
                        ),
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (value) => setState(() => _page = value),
                    children: _pages,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Semantics(
                          label: 'Page ${_page + 1} of ${_pages.length}',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (
                                var index = 0;
                                index < _pages.length;
                                index++
                              )
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  height: 6,
                                  width: index == _page ? 28 : 8,
                                  decoration: BoxDecoration(
                                    color: index == _page
                                        ? primary
                                        : const Color(0xFFD7D9DE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            if (_page > 0) ...[
                              IconButton.outlined(
                                tooltip: 'Back',
                                onPressed: _moving || _finished
                                    ? null
                                    : () => _goTo(_page - 1),
                                style: IconButton.styleFrom(
                                  minimumSize: const Size(56, 56),
                                ),
                                icon: const Icon(Icons.arrow_back_rounded),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: FilledButton(
                                key: const ValueKey('onboarding-next'),
                                onPressed: _moving || _finished
                                    ? null
                                    : () => lastPage
                                          ? _complete()
                                          : _goTo(_page + 1),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(56),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  backgroundColor: primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _finished
                                            ? 'Loading…'
                                            : lastPage
                                            ? 'Get Started'
                                            : 'Continue',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
