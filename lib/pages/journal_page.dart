import 'package:flutter/material.dart';
import 'settings_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController notesController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool showSaveButton = false;

  // Core day-level values
  double flowValue = 0;
  int spottingIndex = 0;
  int dischargeIndex = 0;

  Map<String, double> physicalSymptoms = {
    "Cramps": 0,
    "Headache": 0,
    "Bloating": 0,
    "Breast tenderness": 0,
    "Fatigue": 0,
    "Back pain": 0,
    "Nausea": 0,
    "Acne": 0,
    "Food cravings": 0,
  };

  Map<String, double> emotionalSymptoms = {
    "Mood swings": 0,
    "Irritability": 0,
    "Anxiety": 0,
    "Depression": 0,
    "Difficulty concentrating": 0,
    "Low energy": 0,
    "Heightened emotions": 0,
    "Stress": 0,
  };

  final List<String> flowLabels = ["None", "Light", "Medium", "Heavy"];
  final List<String> spottingOptions = ["None", "Brown", "Red"];
  final List<String> dischargeOptions = [
    "None",
    "Sticky",
    "Creamy",
    "Eggwhite",
    "Atypical"
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final pos = _scrollController.position;

      // OPTIONAL debug:
      // print("pixels: ${pos.pixels}, max: ${pos.maxScrollExtent}");

      bool atBottom = pos.pixels >= (pos.maxScrollExtent - 5);

      if (atBottom != showSaveButton) {
        setState(() => showSaveButton = atBottom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Period Journal",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            // ⭐ FULL SCREEN SCROLL VIEW
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
                // 👆 bottom padding ensures last card isn’t hidden behind button
                child: Column(
                  children: [
                    _journalCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Notes",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _noteInput(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _journalCard(
                      child: _FlowSpottingDischargeSection(
                        flowValue: flowValue,
                        flowLabel: flowLabels[flowValue.round()],
                        spottingIndex: spottingIndex,
                        dischargeIndex: dischargeIndex,
                        spottingOptions: spottingOptions,
                        dischargeOptions: dischargeOptions,
                        onFlowChanged: (v) => setState(() => flowValue = v),
                        onSpottingChanged: (i) => setState(() => spottingIndex = i),
                        onDischargeChanged: (i) => setState(() => dischargeIndex = i),
                      ),
                    ),

                    const _SquiggleSeparator(),
                    const SizedBox(height: 12),

                    _journalCard(
                      child: _SymptomSection(
                        title: "Physical Symptoms",
                        desc: "Rate the intensity from 0 (none) to 4 (very severe)",
                        symptoms: physicalSymptoms,
                        onChanged: (symptom, value) {
                          setState(() => physicalSymptoms[symptom] = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    _journalCard(
                      child: _SymptomSection(
                        title: "Emotional Symptoms",
                        desc: "Rate the intensity from 0 (none) to 4 (very severe)",
                        symptoms: emotionalSymptoms,
                        onChanged: (symptom, value) {
                          setState(() => emotionalSymptoms[symptom] = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ⭐ SAVE BUTTON FLOATS AT BOTTOM
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: showSaveButton
                    ? SizedBox(
                  key: const ValueKey("save_button"),
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => print("Save Entry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEE8C),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text("Save Entry"),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noteInput() {
    return TextField(
      controller: notesController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Add any notes about today...",
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _journalCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

/// ======================================================================
/// FLOW / SPOTTING / DISCHARGE
/// ======================================================================
class _FlowSpottingDischargeSection extends StatelessWidget {
  final double flowValue;
  final String flowLabel;

  final int spottingIndex;
  final int dischargeIndex;

  final List<String> spottingOptions;
  final List<String> dischargeOptions;

  final Function(double) onFlowChanged;
  final Function(int) onSpottingChanged;
  final Function(int) onDischargeChanged;

  const _FlowSpottingDischargeSection({
    required this.flowValue,
    required this.flowLabel,
    required this.spottingIndex,
    required this.dischargeIndex,
    required this.spottingOptions,
    required this.dischargeOptions,
    required this.onFlowChanged,
    required this.onSpottingChanged,
    required this.onDischargeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Flow",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(flowLabel, style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 10),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFFFFEE8C),
            inactiveTrackColor: Colors.grey.shade300,
            trackHeight: 6,
            tickMarkShape: SliderTickMarkShape.noTickMark,
            thumbShape: const CircleThumbShape(),
            overlayColor: Colors.transparent,
          ),
          child: Slider(
            value: flowValue,
            min: 0,
            max: 3,
            divisions: 3,
            onChanged: onFlowChanged,
          ),
        ),

        const SizedBox(height: 20),

        const Text("Spotting",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        _buildDiscreteSelector(
          options: spottingOptions,
          selectedIndex: spottingIndex,
          onSelect: onSpottingChanged,
        ),

        const SizedBox(height: 20),

        const Text("Discharge",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        _buildDiscreteSelector(
          options: dischargeOptions,
          selectedIndex: dischargeIndex,
          onSelect: onDischargeChanged,
        ),
      ],
    );
  }

  Widget _buildDiscreteSelector({
    required List<String> options,
    required int selectedIndex,
    required Function(int) onSelect,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final double spacing = 10;
        final double itemWidth = (totalWidth - (spacing * 2)) / 3;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(options.length, (i) {
            final bool selected = i == selectedIndex;

            return GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                width: itemWidth,
                height: 60,
                // you can adjust height slightly if needed
                decoration: BoxDecoration(
                  color:
                  selected ? const Color(0xFFFFEE8C) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  options[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// ======================================================================
/// SYMPTOMS SECTION
/// ======================================================================
class _SymptomSection extends StatelessWidget {
  final String title;
  final String desc;
  final Map<String, double> symptoms;
  final Function(String, double) onChanged;

  const _SymptomSection({
    required this.title,
    required this.desc,
    required this.symptoms,
    required this.onChanged,
  });

  static const Map<int, String> severityLabels = {
    0: "None",
    1: "Mild",
    2: "Moderate",
    3: "Severe",
    4: "Very Severe",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(desc,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 12),

        ...symptoms.keys.map((symptom) {
          final numeric = symptoms[symptom]!.round();
          final label = severityLabels[numeric]!;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(symptom, style: const TextStyle(fontSize: 15)),
                    Text("$numeric • $label",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),

                const SizedBox(height: 8),

                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFFFEE8C),
                    inactiveTrackColor: Colors.grey.shade300,
                    trackHeight: 6,
                    tickMarkShape: SliderTickMarkShape.noTickMark,
                    thumbShape: const CircleThumbShape(),
                    overlayColor: Colors.transparent,
                  ),
                  child: Slider(
                    value: symptoms[symptom]!,
                    min: 0,
                    max: 4,
                    divisions: 4,
                    onChanged: (val) => onChanged(symptom, val),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

/// ======================================================================
/// Decorative Divider
/// ======================================================================
class _SquiggleSeparator extends StatelessWidget {
  const _SquiggleSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      alignment: Alignment.center,
      child: const Text(
        "~~~~~~~~~~~~~~~~~~~~~",
        style: TextStyle(color: Colors.black26, letterSpacing: 4),
      ),
    );
  }
}

/// ======================================================================
/// Custom Slider Thumb
/// ======================================================================
class CircleThumbShape extends SliderComponentShape {
  final double outerRadius;
  final Color outerColor;

  const CircleThumbShape({
    this.outerRadius = 12.5,
    this.outerColor = const Color(0xFFFFEE8C),
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(outerRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter? labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final canvas = context.canvas;

    final outerPaint = Paint()
      ..color = outerColor
      ..style = PaintingStyle.fill;

    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, outerRadius, outerPaint);
    canvas.drawCircle(center, outerRadius * 0.75, innerPaint);
  }
}
