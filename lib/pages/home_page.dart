import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

/// ------------------------------------------------------
/// Shared chart / text helpers
/// ------------------------------------------------------

final FlTitlesData _minimalTitles = FlTitlesData(
  show: true,
  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
);

final AutoSizeGroup subtitleGroup = AutoSizeGroup();

final FlGridData _minimalGrid = FlGridData(
  show: true,
  drawVerticalLine: false,
  getDrawingHorizontalLine: (value) => FlLine(
    color: Colors.grey.withOpacity(0.12),
    strokeWidth: 1,
  ),
);

const int _currentDayIndex = 13; // Day 14 marker (0-based index)

enum ChartType { hormones, basalTemp, weight }

/// Creates tooltip behavior with line labels
LineTouchData _touchEnabledWithLabels(List<String> labels) {
  return LineTouchData(
    enabled: true,
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.black.withOpacity(0.85),
      fitInsideHorizontally: true,
      fitInsideVertically: true,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((spot) {
          final label = labels[spot.barIndex];
          return LineTooltipItem(
            "$label: ${spot.y.toStringAsFixed(1)}",
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          );
        }).toList();
      },
    ),
    getTouchedSpotIndicator:
        (LineChartBarData barData, List<int> indicators) {
      return indicators
          .map(
            (index) => TouchedSpotIndicatorData(
          FlLine(color: Colors.black, strokeWidth: 1),
          FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeColor: Colors.black,
                strokeWidth: 2,
              );
            },
          ),
        ),
      )
          .toList();
    },
  );
}

/// ------------------------------------------------------
/// PAGE START
/// ------------------------------------------------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Prevents infinite-width exceptions
                  minWidth: constraints.maxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 8),
                    _CurrentCycleStatusCard(),
                    SizedBox(height: 24),
                    _OvulationPhaseCard(),
                    SizedBox(height: 24),
                    _SeparatorSquiggle(),
                    SizedBox(height: 24),
                    _PredictedBodyChangesCard(),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ------------------------------------------------------
/// CURRENT CYCLE STATUS CARD
/// ------------------------------------------------------

class _CurrentCycleStatusCard extends StatelessWidget {
  const _CurrentCycleStatusCard();

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Current Cycle Status",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Day 14 of 28",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            const _CycleTimeline(),
            const SizedBox(height: 12),
            const _CycleLegend(),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: _MetaBox(
                    icon: Icons.nightlight_round,
                    title: "Current Phase",
                    subtitle: "Ovulation",
                    details: "11/16 - 11/19",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _MetaBox(
                    icon: Icons.calendar_today,
                    title: "Next Period",
                    subtitle: "In 14 days",
                    details: "12/1",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------
/// CYCLE TIMELINE
/// ------------------------------------------------------

class _CycleTimeline extends StatelessWidget {
  const _CycleTimeline();

  @override
  Widget build(BuildContext context) {
    const totalDays = 28;
    const spacing = 4.0;

    const menstruation = Colors.red;
    const follicular = Colors.teal;
    const ovulation = Colors.blue;
    const luteal = Colors.purple;

    List<Color> colors = [
      ...List.filled(5, menstruation),
      ...List.filled(7, follicular),
      ...List.filled(4, ovulation),
      ...List.filled(12, luteal),
    ];

    const labelDays = [1, 6, 11, 16, 21, 26];

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        double dotSize = (maxWidth - (spacing * (totalDays - 1))) / totalDays;
        dotSize = dotSize.clamp(6.0, 14.0);

        final dotCenters = List.generate(
          totalDays,
              (i) => i * (dotSize + spacing) + dotSize / 2,
        );

        List<double> labelLefts = [];
        List<String> labelTexts = [];

        final DateTime start = DateTime(2024, 11, 1);

        for (int i = 0; i < labelDays.length; i++) {
          final int index = labelDays[i];
          final int extraDay = i == 0 ? 0 : 1;

          final date = start.add(Duration(days: index + extraDay));
          final label = "${date.month}/${date.day}";

          final tp = TextPainter(
            text: TextSpan(
              text: label,
              style: const TextStyle(fontSize: 10),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          labelLefts.add(dotCenters[index] - tp.width / 2);
          labelTexts.add(label);
        }

        return Column(
          children: [
            Wrap(
              spacing: spacing,
              children: List.generate(
                totalDays,
                    (i) {
                  bool isToday = i == _currentDayIndex;
                  return Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: isToday ? Colors.white : colors[i],
                      border: isToday
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: maxWidth,
              height: 16,
              child: Stack(
                children: List.generate(
                  labelDays.length,
                      (i) => Positioned(
                        left: max(0, min(labelLefts[i], maxWidth - 30)),
                        child: Text(
                      labelTexts[i],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// ------------------------------------------------------
/// CYCLE LEGEND
/// ------------------------------------------------------

class _CycleLegend extends StatelessWidget {
  const _CycleLegend();

  @override
  Widget build(BuildContext context) {
    const items = [
      ("Menstruation", Colors.red),
      ("Follicular", Colors.teal),
      ("Ovulation", Colors.blue),
      ("Luteal", Colors.purple),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items
          .map(
            (e) => Row(
          children: [
            CircleAvatar(radius: 4, backgroundColor: e.$2),
            const SizedBox(width: 4),
            Text(
              e.$1,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      )
          .toList(),
    );
  }
}

/// ------------------------------------------------------
/// OVULATION PHASE CARD
/// ------------------------------------------------------

class _OvulationPhaseCard extends StatelessWidget {
  const _OvulationPhaseCard();

  @override
  Widget build(BuildContext context) {
    final items = [
      (
      Icons.wb_sunny_outlined,
      "You may experience increased energy and heightened senses"
      ),
      (Icons.opacity, "Clear, stretchy cervical fluid is common"),
      (
      Icons.info_outline,
      "Last cycle: Mild cramps, increased energy, clear discharge"
      ),
    ];

    return _AppCard(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ovulation Phase",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              "Days 13–16 of your cycle",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ...items.map(
                  (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(e.$1, size: 18, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        e.$2,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------
/// SEPARATOR
/// ------------------------------------------------------

class _SeparatorSquiggle extends StatelessWidget {
  const _SeparatorSquiggle();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      alignment: Alignment.center,
      child: const Text(
        "~~~~~~~~~~~~~~~~~~~~~~~",
        style: TextStyle(color: Colors.black26, letterSpacing: 4),
      ),
    );
  }
}

/// ------------------------------------------------------
/// PREDICTED BODY CHANGES CARD
/// ------------------------------------------------------

class _PredictedBodyChangesCard extends StatefulWidget {
  const _PredictedBodyChangesCard();

  @override
  State<_PredictedBodyChangesCard> createState() =>
      _PredictedBodyChangesCardState();
}

class _PredictedBodyChangesCardState
    extends State<_PredictedBodyChangesCard> {
  ChartType active = ChartType.hormones;

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Predicted Body Changes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Hormones and physical changes throughout your cycle",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Cupertino segmented control
            CupertinoSlidingSegmentedControl<ChartType>(
              groupValue: active,
              thumbColor: Colors.white,
              backgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.all(4),
              onValueChanged: (value) {
                if (value != null) {
                  setState(() => active = value);
                }
              },
              children: const {
                ChartType.hormones: _CupertinoSegmentLabel("Hormones"),
                ChartType.basalTemp:
                _CupertinoSegmentLabel("Basal\nTemperature"),
                ChartType.weight: _CupertinoSegmentLabel("Weight"),
              },
            ),

            const SizedBox(height: 16),

            // Chart area
            SizedBox(
              height: 200,
              child: _buildChart(),
            ),

            const SizedBox(height: 12),

            // Legend (depends on active chart)
            _buildLegend(),

            const SizedBox(height: 20),

            // Small timeline for context
            const _CycleTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    switch (active) {
      case ChartType.hormones:
        return const _HormoneChart();
      case ChartType.basalTemp:
        return const _BasalTempChart();
      case ChartType.weight:
        return const _WeightChart();
    }
  }

  Widget _buildLegend() {
    switch (active) {
      case ChartType.hormones:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: Colors.red, label: "Estrogen"),
            SizedBox(width: 20),
            _LegendDot(color: Colors.blue, label: "Progesterone"),
          ],
        );
      case ChartType.basalTemp:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: Colors.orange, label: "Basal Temperature"),
          ],
        );
      case ChartType.weight:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: Colors.green, label: "Weight"),
          ],
        );
    }
  }
}

/// ------------------------------------------------------
/// CHARTS
/// ------------------------------------------------------

class _HormoneChart extends StatelessWidget {
  const _HormoneChart();

  @override
  Widget build(BuildContext context) {
    final estrogen = <double>[
      5, 10, 18, 25, 32, 40, 48, 56, 63, 70, 76, 80, 83, 85, 82, 75, 68,
      60, 52, 45, 38, 32, 26, 20, 15, 10, 6, 3
    ];

    final progesterone = <double>[
      2, 2, 2, 3, 4, 5, 7, 10, 15, 20, 28, 35, 42, 50, 58, 63, 66, 68,
      67, 62, 55, 48, 38, 30, 22, 14, 8, 4
    ];

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        lineBarsData: [
          _line(estrogen, Colors.red),
          _line(progesterone, Colors.blue),
        ],
        minX: 0,
        maxX: 27,
        minY: 0,
        maxY: 100,
        lineTouchData: _touchEnabledWithLabels(
          ["Estrogen", "Progesterone"],
        ),
        titlesData: _minimalTitles,
        gridData: _minimalGrid,
        extraLinesData: ExtraLinesData(
          verticalLines: [
            VerticalLine(
              x: _currentDayIndex.toDouble(),
              strokeWidth: 2,
              color: Colors.black,
              dashArray: [4, 4],
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _line(List<double> vals, Color color) {
    return LineChartBarData(
      spots: vals
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: FlDotData(show: false),
    );
  }
}

class _BasalTempChart extends StatelessWidget {
  const _BasalTempChart();

  @override
  Widget build(BuildContext context) {
    final temps = <double>[
      97.1, 97.2, 97.3, 97.4, 97.4, 97.5, 97.6, 97.7, 97.8, 97.9, 98.1, 98.4,
      98.6, 98.7, 98.8, 98.9, 98.9, 98.9, 98.8, 98.7, 98.5, 98.3, 98.1, 97.9,
      97.8, 97.7, 97.6, 97.5,
    ];

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: temps
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
        minX: 0,
        maxX: 27,
        lineTouchData: _touchEnabledWithLabels(
          ["Basal Temperature"],
        ),
        titlesData: _minimalTitles,
        gridData: _minimalGrid,
        extraLinesData: ExtraLinesData(
          verticalLines: [
            VerticalLine(
              x: _currentDayIndex.toDouble(),
              strokeWidth: 2,
              color: Colors.black,
              dashArray: [4, 4],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  const _WeightChart();

  @override
  Widget build(BuildContext context) {
    final weights = <double>[
      138, 137.5, 137, 136.5, 136, 135.3, 135, 134.8, 134.9, 135.2, 136, 137.5,
      139, 140, 141, 141.2, 141, 140.5, 140, 139.5, 139, 138.5, 138.2, 138,
      137.8, 137.6, 137.5, 137.4,
    ];

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: weights
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
        minX: 0,
        maxX: 27,
        lineTouchData: _touchEnabledWithLabels(["Weight"]),
        titlesData: _minimalTitles,
        gridData: _minimalGrid,
        extraLinesData: ExtraLinesData(
          verticalLines: [
            VerticalLine(
              x: _currentDayIndex.toDouble(),
              strokeWidth: 2,
              color: Colors.black,
              dashArray: [4, 4],
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------
/// CUPERTINO SEGMENT LABEL
/// ------------------------------------------------------

class _CupertinoSegmentLabel extends StatelessWidget {
  final String text;

  const _CupertinoSegmentLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, // Gives predictable layout; prevents intrinsic sizing crash
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------
/// LEGEND DOT
/// ------------------------------------------------------

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}

/// ------------------------------------------------------
/// META BOX
/// ------------------------------------------------------

class _MetaBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String details;

  const _MetaBox({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                AutoSizeText(
                  subtitle,
                  maxLines: 1,
                  minFontSize: 10,
                  maxFontSize: 16,
                  group: subtitleGroup,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------
/// CARD WRAPPER
/// ------------------------------------------------------

class _AppCard extends StatelessWidget {
  final Widget child;
  const _AppCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
