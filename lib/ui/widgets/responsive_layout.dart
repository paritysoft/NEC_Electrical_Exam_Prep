import 'package:flutter/material.dart';

const appNavy = Color(0xFF0C3158);
const appCanvas = Color(0xFFF3F5F9);
const appMuted = Color(0xFF71829C);
const appBorder = Color(0xFFE0E6EF);

class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 1280});
  final Widget child;
  final double maxWidth;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

/// Uses available content width, including when a sidebar is visible.
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 240,
    this.spacing = 16,
  });
  final List<Widget> children;
  final double minItemWidth, spacing;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final scaledWidth =
          minItemWidth *
          MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.5);
      final columns = ((box.maxWidth + spacing) / (scaledWidth + spacing))
          .floor()
          .clamp(1, 4);
      final width = (box.maxWidth - spacing * (columns - 1)) / columns;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(color: appMuted, fontSize: 16, height: 1.5),
          ),
        ],
      ],
    ),
  );
}

class StudyTile extends StatelessWidget {
  const StudyTile({
    super.key,
    this.compact = false,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.premium = false,
  });
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool premium;
  final bool compact;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: compact
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, color: appNavy, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(subtitle, style: const TextStyle(color: appMuted)),
                        if (premium)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'Premium',
                              style: TextStyle(color: appNavy, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: appNavy),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: appNavy.withValues(alpha: .07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: appNavy, size: 28),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(color: appMuted, height: 1.5),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          premium ? 'Premium' : 'Start learning',
                          style: const TextStyle(color: appNavy),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: appNavy,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    ),
  );
}

/// Constrains secondary pages without changing their scroll or navigation behavior.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.scaffoldKey,
    this.maxWidth = 1200,
    this.resizeToAvoidBottomInset,
  });
  final PreferredSizeWidget? appBar;
  final Widget? body, bottomNavigationBar, floatingActionButton;
  final Color? backgroundColor;
  final Key? scaffoldKey;
  final bool? resizeToAvoidBottomInset;
  final double maxWidth;
  @override
  Widget build(BuildContext context) => Scaffold(
    key: scaffoldKey,
    appBar: appBar,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    backgroundColor: backgroundColor ?? appCanvas,
    body: SafeArea(
      child: ContentWidth(
        maxWidth: maxWidth,
        child: SizedBox(width: double.infinity, child: body),
      ),
    ),
    bottomNavigationBar: bottomNavigationBar,
    floatingActionButton: floatingActionButton,
  );
}
