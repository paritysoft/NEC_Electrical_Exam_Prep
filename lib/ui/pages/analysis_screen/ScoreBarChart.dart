import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ScoreGaugeChart extends StatefulWidget {
  final int totalQuestions;
  final int score;

  ScoreGaugeChart({
    required this.totalQuestions,
    required this.score,
  });

  @override
  _ScoreGaugeChartState createState() => _ScoreGaugeChartState();
}

class _ScoreGaugeChartState extends State<ScoreGaugeChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double percentage = 0.0;

  @override
  void initState() {
    super.initState();
    percentage = (widget.score / widget.totalQuestions) * 100;

    // Animation controller for smooth effects
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPassed = percentage >= 70;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Text(
              isPassed ? "🎉 Congratulations! You Passed! 🎉" : "❌ Try Again! You Failed!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isPassed ? Colors.green : Colors.red,
                shadows: isPassed
                    ? [
                  Shadow(
                    blurRadius: 15,
                    color: Colors.green.withOpacity(0.7),
                    offset: Offset(0, 0),
                  )
                ]
                    : [],
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
        SizedBox(height: 20),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SizedBox(
              height: 250,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue: 70,
                        color: Colors.redAccent,
                      ),
                      GaugeRange(
                        startValue: 70,
                        endValue: 100,
                        color: Colors.green,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: _animation.value,
                        enableAnimation: true,
                        animationType: AnimationType.easeOutBack,
                        needleEndWidth: 5,
                        needleColor: isPassed ? Colors.green : Colors.red,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Text(
                              "${_animation.value.toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isPassed ? Colors.green : Colors.red,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: isPassed
                                        ? Colors.green.withOpacity(0.7)
                                        : Colors.red.withOpacity(0.7),
                                    offset: Offset(0, 0),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
