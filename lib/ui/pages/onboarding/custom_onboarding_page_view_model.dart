import 'package:flutter/material.dart';

class CustomOnboardingPageViewModel extends StatelessWidget {
  const CustomOnboardingPageViewModel({
    super.key,
    required this.imageUrl,
    required this.modelTitle,
    required this.modelDescription,
  });

  final String imageUrl, modelTitle, modelDescription;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 650 &&
            constraints.maxWidth > constraints.maxHeight;
        final imageHeight = (constraints.maxHeight * (wide ? 0.85 : 0.52))
            .clamp(150.0, 420.0);
        final illustration = Container(
          height: imageHeight,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFEDE9E1)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              semanticLabel: modelTitle,
              filterQuality: FilterQuality.high,
            ),
          ),
        );
        final copy = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              modelTitle,
              style: TextStyle(
                fontSize: wide ? 30 : 28,
                height: 1.15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
                color: const Color(0xFF202632),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              modelDescription,
              style: const TextStyle(
                fontSize: 16,
                height: 1.55,
                color: Color(0xFF596170),
              ),
            ),
          ],
        );
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - 32).clamp(
                0.0,
                double.infinity,
              ),
            ),
            child: Center(
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: illustration),
                        const SizedBox(width: 36),
                        Expanded(child: copy),
                      ],
                    )
                  : ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          illustration,
                          const SizedBox(height: 28),
                          copy,
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
