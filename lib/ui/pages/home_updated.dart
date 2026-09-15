import 'package:flutter/material.dart';
import '../../util/app_constants.dart';
import '../widgets/responsive_layout.dart';
import 'analysis_screen/analysis_screen.dart';
import 'explore_screen/explore_screen.dart';
import 'settings_screen/settings_screen.dart';
import '../widgets/common_widget.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});
  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) => AdaptiveAppShell(
    selectedIndex: _index,
    onSelected: (index) => setState(() => _index = index),
    child: [ExploreScreen(), AnalysisScreen(), SettingsScreen()][_index],
  );
}

class AdaptiveAppShell extends StatelessWidget {
  const AdaptiveAppShell({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;
  static const labels = ['Home', 'Analysis', 'Settings'];
  static const icons = [
    Icons.home_outlined,
    Icons.bar_chart_rounded,
    Icons.settings_outlined,
  ];
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      final desktop = bounds.maxWidth >= 1000;
      final tablet = bounds.maxWidth >= 700;
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 20,
          title: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
                radius: 20,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  app_title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Study motivation',
              icon: const Icon(Icons.bolt_rounded, color: Colors.amber),
              onPressed: () =>
                  snackBar(context, 'Keep learning, one question at a time.'),
            ),
          ],
        ),
        body: Row(
          children: [
            if (tablet)
              Container(
                width: desktop ? 232 : 88,
                color: appNavy,
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      for (var index = 0; index < labels.length; index++)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: desktop ? 12 : 8,
                            vertical: 5,
                          ),
                          child: Material(
                            color: selectedIndex == index
                                ? Colors.white.withValues(alpha: .16)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => onSelected(index),
                              child: Semantics(
                                selected: selectedIndex == index,
                                button: true,
                                label: labels[index],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 16,
                                  ),
                                  child: desktop
                                      ? Row(
                                          children: [
                                            Icon(
                                              icons[index],
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                labels[index],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Tooltip(
                                          message: labels[index],
                                          child: Icon(
                                            icons[index],
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: SafeArea(top: false, child: ContentWidth(child: child)),
            ),
          ],
        ),
        bottomNavigationBar: tablet
            ? null
            : NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: onSelected,
                destinations: [
                  for (var i = 0; i < labels.length; i++)
                    NavigationDestination(
                      icon: Icon(icons[i]),
                      label: labels[i],
                    ),
                ],
              ),
      );
    },
  );
}
