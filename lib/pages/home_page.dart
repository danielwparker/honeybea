import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      ),
    );
  }
}

/// --------------------------------------------
/// CURRENT CYCLE STATUS CARD
/// --------------------------------------------
class _CurrentCycleStatusCard extends StatelessWidget {
  const _CurrentCycleStatusCard();

  @override
  Widget build(BuildContext context) {
    return _AppCard(
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
                  icon: Icons.bedtime,
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
    );
  }
}

/// --------------------------------------------
/// TIMELINE
/// --------------------------------------------
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
      ...List.filled(4, menstruation),
      ...List.filled(6, follicular),
      ...List.filled(4, ovulation),
      ...List.filled(6, luteal),
      ...List.filled(8, Colors.purple),
    ];

    // Labels at: 2nd, 7th, 12th, 17th, 22nd, 27th
    const labelDays = [1, 6, 11, 16, 21, 26];

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        // dot size
        double dotSize =
            (maxWidth - (spacing * (totalDays - 1))) / totalDays;
        dotSize = dotSize.clamp(6.0, 14.0);

        // dot centers
        final dotCenters = List.generate(totalDays, (i) {
          return i * (dotSize + spacing) + dotSize / 2;
        });

        // label positions + texts
        List<double> labelLefts = [];
        List<String> labelTexts = [];

        final DateTime start = DateTime(2024, 11, 1);

        for (int i = 0; i < labelDays.length; i++) {
          final int index = labelDays[i];

          final int extraDay = (i == 0) ? 0 : 1;
          final DateTime date =
          start.add(Duration(days: index + extraDay));
          final String label = "${date.month}/${date.day}";

          final tp = TextPainter(
            text: TextSpan(
              text: label,
              style: const TextStyle(fontSize: 10),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          final double labelWidth = tp.width;
          final double left = dotCenters[index] - (labelWidth / 2);

          labelLefts.add(left);
          labelTexts.add(label);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: spacing,
              children: List.generate(totalDays, (i) {
                bool isToday = i == 10;

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
              }),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: maxWidth,
              height: 16,
              child: Stack(
                children: List.generate(labelDays.length, (i) {
                  return Positioned(
                    left: labelLefts[i],
                    child: Text(
                      labelTexts[i],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// --------------------------------------------
/// LEGEND
/// --------------------------------------------
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
      children: items.map((e) {
        return Row(
          children: [
            CircleAvatar(radius: 4, backgroundColor: e.$2),
            const SizedBox(width: 4),
            Text(e.$1, style: const TextStyle(fontSize: 11)),
          ],
        );
      }).toList(),
    );
  }
}

/// --------------------------------------------
/// OVULATION PHASE CARD
/// --------------------------------------------
class _OvulationPhaseCard extends StatelessWidget {
  const _OvulationPhaseCard();

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.wb_sunny_outlined,
      "You may experience increased energy and heightened senses"),
      (Icons.opacity, "Clear, stretchy cervical fluid is common"),
      (Icons.info_outline,
      "Last cycle: Mild cramps, increased energy, clear discharge"),
    ];

    return _AppCard(
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
          ...items.map((e) => Padding(
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
          )),
        ],
      ),
    );
  }
}

/// --------------------------------------------
/// Decorative separator
/// --------------------------------------------
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

/// --------------------------------------------
/// PREDICTED BODY CHANGES
/// --------------------------------------------
class _PredictedBodyChangesCard extends StatelessWidget {
  const _PredictedBodyChangesCard();

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
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

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Hormones",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
              const SizedBox(width: 16),
              Text("Basal Temperature",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
              const SizedBox(width: 16),
              Text("Weight",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            alignment: Alignment.center,
            child: const Text("Chart Placeholder"),
          ),

          const SizedBox(height: 16),
          const _CycleTimeline(),
        ],
      ),
    );
  }
}

/// --------------------------------------------
/// REUSABLE HELPERS
/// --------------------------------------------
class _AppCard extends StatelessWidget {
  final Widget child;
  const _AppCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _MetaBox extends StatelessWidget {
  final IconData icon;
  final String title;      // subtle top line
  final String subtitle;   // emphasized line
  final String details;    // supporting line

  static final AutoSizeGroup subtitleGroup = AutoSizeGroup();

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
        crossAxisAlignment: CrossAxisAlignment.center,  // ⬅ Center vertically
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),   // ⬅ removed top padding
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
                // Subtle top label
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                // Bold main info (auto-scaling)
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

                // Supporting third line
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 11.0,
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
