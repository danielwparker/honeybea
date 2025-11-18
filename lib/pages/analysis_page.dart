import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _metricsGrid(),
            const SizedBox(height: 24),
            const _Squiggle(),
            const SizedBox(height: 24),
            _symptomIntensityCard(),
            const SizedBox(height: 24),
            _commonSymptomsCard(),
            const SizedBox(height: 24),
            _insightsCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  /// --------------------------------------------
  /// Metrics Grid
  /// --------------------------------------------
  Widget _metricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.8,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _MetricBox(title: "Average Cycle", value: "28 days"),
        _MetricBox(title: "Variation", value: "±2 days"),
        _MetricBox(title: "Flow Length", value: "5 days"),
        _MetricBox(title: "Tracking Streak", value: "15 days"),
      ],
    );
  }

  /// --------------------------------------------
  /// Symptom Intensity by Cycle Phase Chart
  /// --------------------------------------------
  Widget _symptomIntensityCard() {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Symptom Intensity by Cycle Phase",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text("Average symptom severity throughout your cycle",
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: 8,
                barGroups: _makeSymptomBars(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          "Day 1-2",
                          "Day 3-5",
                          "Day 6-10",
                          "Day 11-14",
                          "Day 15-20",
                          "Day 21-25",
                          "Day 26-28",
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _LegendItem(color: Colors.purple, label: "Emotional"),
              SizedBox(width: 24),
              _LegendItem(color: Colors.red, label: "Physical"),
            ],
          )
        ],
      ),
    );
  }

  List<BarChartGroupData> _makeSymptomBars() {
    List<int> emotional = [6, 4, 2, 3, 2, 4, 6];
    List<int> physical = [8, 6, 3, 1, 2, 5, 7];

    return List.generate(7, (i) {
      return BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              toY: emotional[i].toDouble(),
              width: 14,
              color: Colors.purple),
          BarChartRodData(
              toY: physical[i].toDouble(),
              width: 14,
              color: Colors.red),
        ],
      );
    });
  }

  /// --------------------------------------------
  /// Most Common Symptoms Chart
  /// --------------------------------------------
  Widget _commonSymptomsCard() {
    const labels = [
      "Cramps",
      "Mood swings",
      "Bloating",
      "Fatigue",
      "Headache",
      "Irritability",
    ];

    const values = [12.0, 10.0, 9.0, 8.0, 6.5, 5.0];

    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Most Common Symptoms",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text(
            "Tracked over the last 3 months",
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 230,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                maxY: 12,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(labels.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i],
                        color: Colors.blue,
                        width: 22,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        getTitlesWidget: (value, _) => Text(
                          labels[value.toInt()],
                          style: const TextStyle(fontSize: 12),
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------
  /// Insights Section
  /// --------------------------------------------
  Widget _insightsCard() {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Insights",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text("Based on your tracked data",
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 16),
          _insightTile("Peak Pain Days",
              "You typically experience the most physical symptoms on days 1–2 of your period.",
              bg: Color(0xFFFFE4E6)),
          const SizedBox(height: 12),
          _insightTile("Emotional Patterns",
              "Emotional symptoms tend to increase in the week before your period (days 21–28).",
              bg: Color(0xFFEDE7F6)),
          const SizedBox(height: 12),
          _insightTile("Regular Cycle",
              "Your cycle has been very consistent at 28 days with minimal variation.",
              bg: Color(0xFFE3F2FD)),
        ],
      ),
    );
  }

  Widget _insightTile(String title, String body,
      {required Color bg}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.black),
            ),
            TextSpan(
              text: body,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------
/// Shared Helpers
/// --------------------------------------------

class _AppCard extends StatelessWidget {
  final Widget child;
  const _AppCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: child,
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String title;
  final String value;

  const _MetricBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Squiggle extends StatelessWidget {
  const _Squiggle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "~~~~~~~~~~~~~~~~~~~~~",
      style: TextStyle(
        color: Colors.black26,
        letterSpacing: 4,
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
