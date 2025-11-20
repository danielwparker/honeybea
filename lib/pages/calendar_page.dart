import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const Color _lightFlowColor = Color(0xFFFFEEF1);
  static const Color _mediumFlowColor = Color(0xFFFFD6DC);
  static const Color _heavyFlowColor = Color(0xFFFFBAC5);
  static const Color _flowOutlineColor = Color(0xFFB71C1C);
  static const List<String> _flowLabels = ["None", "Light", "Medium", "Heavy"];
  static const List<String> _spottingOptions = ["None", "Brown", "Red"];
  static const List<String> _dischargeOptions = [
    "None",
    "Sticky",
    "Creamy",
    "Eggwhite",
    "Atypical"
  ];
  static const List<String> _intensityLabels = [
    "None",
    "Very Light",
    "Mild",
    "Moderate",
    "Severe"
  ];
  final List<DateTime> _availableMonths = [
    DateTime(2025, 9),
    DateTime(2025, 10),
    DateTime(2025, 11),
  ];

  int _monthIndex = 1;
  final int _mockToday = 14;
  late final Map<String, JournalEntry> _mockEntries = {
    _dateKey(DateTime(2025, 9, 5)): JournalEntry(
      date: DateTime(2025, 9, 5),
      flowIndex: 0,
      spottingIndex: 0,
      dischargeIndex: 1,
      notes: "Pre-period check-in, light discharge only.",
      physicalSymptoms: {
        "Bloating": 1.0,
      },
      emotionalSymptoms: {
        "Mood swings": 1.0,
      },
    ),
    _dateKey(DateTime(2025, 9, 22)): JournalEntry(
      date: DateTime(2025, 9, 22),
      flowIndex: 1,
      spottingIndex: 0,
      dischargeIndex: 2,
      notes: "Cycle starting soon, energy levels steady.",
      physicalSymptoms: {
        "Back pain": 1.0,
      },
      emotionalSymptoms: <String, double>{},
    ),
    _dateKey(DateTime(2025, 10, 14)): JournalEntry(
      date: DateTime(2025, 10, 14),
      flowIndex: 2,
      spottingIndex: 1,
      dischargeIndex: 2,
      notes: "Felt energized after morning yoga. Slight cramps later.",
      physicalSymptoms: {
        "Cramps": 2.0,
        "Fatigue": 1.0,
      },
      emotionalSymptoms: {
        "Mood swings": 1.0,
        "Stress": 2.0,
      },
    ),
    _dateKey(DateTime(2025, 10, 15)): JournalEntry(
      date: DateTime(2025, 10, 15),
      flowIndex: 2,
      spottingIndex: 0,
      dischargeIndex: 3,
      notes: "Keeping hydrated, medium flow throughout the day.",
      physicalSymptoms: {
        "Headache": 1.0,
      },
      emotionalSymptoms: {
        "Low energy": 1.0,
      },
    ),
    _dateKey(DateTime(2025, 10, 16)): JournalEntry(
      date: DateTime(2025, 10, 16),
      flowIndex: 3,
      spottingIndex: 0,
      dischargeIndex: 4,
      notes: "Noticed heavier flow today but spirits are good.",
      physicalSymptoms: {
        "Back pain": 3.0,
        "Headache": 1.0,
      },
      emotionalSymptoms: {
        "Low energy": 2.0,
      },
    ),
    _dateKey(DateTime(2025, 11, 3)): JournalEntry(
      date: DateTime(2025, 11, 3),
      flowIndex: 1,
      spottingIndex: 0,
      dischargeIndex: 1,
      notes: "Light movement day, short walk in evening.",
      physicalSymptoms: {
        "Fatigue": 1.0,
      },
      emotionalSymptoms: {
        "Stress": 1.0,
      },
    ),
    _dateKey(DateTime(2025, 11, 18)): JournalEntry(
      date: DateTime(2025, 11, 18),
      flowIndex: 2,
      spottingIndex: 0,
      dischargeIndex: 2,
      notes: "Cycle nearing end, feeling calm.",
      physicalSymptoms: {
        "Cramps": 1.0,
      },
      emotionalSymptoms: {
        "Mood swings": 1.0,
      },
    ),
  };

  DateTime get currentMonth => _availableMonths[_monthIndex];
  bool get _canGoPrevious => _monthIndex > 0;
  bool get _canGoNext => _monthIndex < _availableMonths.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _calendarCard(),
              const SizedBox(height: 24),
              _legendCard(),
              const SizedBox(height: 24),
              const _Squiggle(),
              const SizedBox(height: 24),
              _recentCyclesCard(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calendarCard() {
    int daysInMonth =
    DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);

    List<Widget> dayTiles = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final dateKey = _dateKey(date);
      final hasTrackedEntry = _mockEntries.containsKey(dateKey);
      bool isToday = _isMockToday(day);
      bool isPeriodDay = day >= 13 && day <= 17;
      bool isMediumDay =
          currentMonth.year == 2025 && currentMonth.month == 10 && (day == 15 || day == 16);
      bool hasDot = hasTrackedEntry;
      Color tileColor;

      if (isMediumDay) {
        tileColor = _mediumFlowColor;
      } else if (isPeriodDay) {
        tileColor = _lightFlowColor;
      } else {
        tileColor = Colors.white;
      }

      Color? borderColor;
      double borderWidth = 0;
      if (isToday) {
        borderColor = Colors.blue;
        borderWidth = 2;
      } else if (tileColor != Colors.white) {
        borderColor = _flowOutlineColor;
        borderWidth = 1.5;
      }

      dayTiles.add(
        GestureDetector(
          onTap: hasTrackedEntry ? () => _handleDayTap(day) : null,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(14),
              border: borderColor != null
                  ? Border.all(color: borderColor, width: borderWidth)
                  : null,
            ),
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double dotSize = 6;
                final textStyle = TextStyle(
                  fontSize: 16,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isMediumDay
                      ? Colors.black
                      : isToday
                      ? Colors.blue
                      : Colors.black,
                );
                final textPainter = TextPainter(
                  text: TextSpan(
                    text: "$day",
                    style: textStyle,
                  ),
                  textDirection: TextDirection.ltr,
                )..layout();

                final textBottom =
                    (constraints.maxHeight / 2) + (textPainter.height / 2);
                final dotCenterY = (textBottom + constraints.maxHeight) / 2;
                final dotTop = dotCenterY - (dotSize / 2);

                return Stack(
                  children: [
                    Center(
                      child: Text(
                        "$day",
                        style: textStyle,
                      ),
                    ),
                    if (hasDot)
                      Positioned(
                        top: dotTop,
                        left: (constraints.maxWidth - dotSize) / 2,
                        child: Container(
                          width: dotSize,
                          height: dotSize,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }

    return _AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_monthName(currentMonth.month)} ${currentMonth.year}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  _circleIcon(
                    Icons.chevron_left,
                    _goToPreviousMonth,
                    isEnabled: _canGoPrevious,
                  ),
                  const SizedBox(width: 10),
                  _circleIcon(
                    Icons.chevron_right,
                    _goToNextMonth,
                    isEnabled: _canGoNext,
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 16),

          // Days of Week Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text("Sun"),
              Text("Mon"),
              Text("Tue"),
              Text("Wed"),
              Text("Thu"),
              Text("Fri"),
              Text("Sat"),
            ],
          ),

          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: dayTiles,
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap,
      {bool isEnabled = true}) {
    return Opacity(
      opacity: isEnabled ? 1 : 0.4,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          customBorder: const CircleBorder(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12),
            ),
            child: Icon(icon, size: 20),
          ),
        ),
      ),
    );
  }

  void _goToPreviousMonth() {
    if (!_canGoPrevious) return;
    setState(() {
      _monthIndex--;
    });
  }

  void _goToNextMonth() {
    if (!_canGoNext) return;
    setState(() {
      _monthIndex++;
    });
  }

  bool _isMockToday(int day) {
    return currentMonth.year == 2025 &&
        currentMonth.month == 10 &&
        day == _mockToday;
  }

  void _handleDayTap(int day) {
    final tappedDate = DateTime(currentMonth.year, currentMonth.month, day);
    final entry = _mockEntries[_dateKey(tappedDate)];
    if (entry == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _JournalSummarySheet(
              entry: entry,
              flowLabels: _flowLabels,
              spottingOptions: _spottingOptions,
              dischargeOptions: _dischargeOptions,
              intensityLabels: _intensityLabels,
            ),
          ),
        );
      },
    );
  }

  String _dateKey(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  Widget _legendCard() {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Legend",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Period Days
          const Text("Period Days:"),
          const SizedBox(height: 8),
          Row(
            children: [
              _legendCircle(_lightFlowColor),
              const SizedBox(width: 6),
              const Text("Light"),
              const SizedBox(width: 14),
              _legendCircle(_mediumFlowColor),
              const SizedBox(width: 6),
              const Text("Medium"),
              const SizedBox(width: 14),
              _legendCircle(_heavyFlowColor),
              const SizedBox(width: 6),
              const Text("Heavy"),
            ],
          ),

          const SizedBox(height: 16),

          // Forecasted Period
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text("Forecasted Period"),
            ],
          ),

          const SizedBox(height: 16),

          // Tracked Day
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text("Tracked Day"),
            ],
          ),

          const SizedBox(height: 16),

          // Today
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
              ),
              const SizedBox(width: 8),
              const Text("Today"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendCircle(Color color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: _flowOutlineColor, width: 1.5),
      ),
    );
  }

  Widget _recentCyclesCard() {
    return _AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _cycleTile("Current Cycle", "In Progress", isExpanded: true),
          const Divider(height: 0),
          _cycleTimeline(),
          const Divider(height: 0),
          _cycleTile("Previous Cycle", "28 days"),
          const Divider(height: 0),
          _cycleTile("August Cycle", "28 days"),
        ],
      ),
    );
  }

  Widget _cycleTile(String title, String status,
      {bool isExpanded = false}) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: const Text("Started Oct 13, 2025"),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isExpanded ? const Color(0xFFFFEE8C) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(status),
      ),
    );
  }

  Widget _cycleTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(20, (i) {
          Color color;
          if (i < 4) color = Colors.red;
          else if (i < 10) color = Colors.teal;
          else if (i < 14) color = Colors.blue;
          else color = Colors.purple;

          return CircleAvatar(radius: 4, backgroundColor: color);
        }),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return names[month - 1];
  }
}

class JournalEntry {
  final DateTime date;
  final int flowIndex;
  final int spottingIndex;
  final int dischargeIndex;
  final String notes;
  final Map<String, double> physicalSymptoms;
  final Map<String, double> emotionalSymptoms;

  JournalEntry({
    required this.date,
    required this.flowIndex,
    required this.spottingIndex,
    required this.dischargeIndex,
    required this.notes,
    this.physicalSymptoms = const <String, double>{},
    this.emotionalSymptoms = const <String, double>{},
  });

  List<MapEntry<String, double>> get activePhysicalSymptoms =>
      physicalSymptoms.entries.where((e) => (e.value) > 0).toList();

  List<MapEntry<String, double>> get activeEmotionalSymptoms =>
      emotionalSymptoms.entries.where((e) => (e.value) > 0).toList();
}

class _JournalSummarySheet extends StatelessWidget {
  final JournalEntry entry;
  final List<String> flowLabels;
  final List<String> spottingOptions;
  final List<String> dischargeOptions;
  final List<String> intensityLabels;

  const _JournalSummarySheet({
    required this.entry,
    required this.flowLabels,
    required this.spottingOptions,
    required this.dischargeOptions,
    required this.intensityLabels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final physical = entry.activePhysicalSymptoms;
    final emotional = entry.activeEmotionalSymptoms;
    final dateLabel = MaterialLocalizations.of(context).formatFullDate(entry.date);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24),
                    const Text(
                      "Journal Entry",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    dateLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _SummaryOptionRow(
                  label: "Flow",
                  options: flowLabels,
                  selectedIndex:
                      entry.flowIndex.clamp(0, flowLabels.length - 1).toInt(),
                ),
                const SizedBox(height: 16),
                _SummaryOptionRow(
                  label: "Spotting",
                  options: spottingOptions,
                  selectedIndex: entry.spottingIndex
                      .clamp(0, spottingOptions.length - 1)
                      .toInt(),
                ),
                const SizedBox(height: 16),
                _SummaryOptionRow(
                  label: "Discharge",
                  options: dischargeOptions,
                  selectedIndex: entry.dischargeIndex
                      .clamp(0, dischargeOptions.length - 1)
                      .toInt(),
                ),
                if (entry.notes.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Notes",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(entry.notes),
                      ],
                    ),
                  ),
                ],
                if (physical.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const _SummarySectionHeader("Physical Symptoms"),
                  const SizedBox(height: 12),
                  ...physical.map(
                    (symptom) => _SymptomSliderRow(
                      label: symptom.key,
                      value: symptom.value,
                      intensityLabels: intensityLabels,
                    ),
                  ),
                ],
                if (emotional.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const _SummarySectionHeader("Emotional Symptoms"),
                  const SizedBox(height: 12),
                  ...emotional.map(
                    (symptom) => _SymptomSliderRow(
                      label: symptom.key,
                      value: symptom.value,
                      intensityLabels: intensityLabels,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryOptionRow extends StatelessWidget {
  final String label;
  final List<String> options;
  final int selectedIndex;

  const _SummaryOptionRow({
    required this.label,
    required this.options,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(options.length, (index) {
            final bool isSelected = index == selectedIndex;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                options[index],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SummarySectionHeader extends StatelessWidget {
  final String title;
  const _SummarySectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SymptomSliderRow extends StatelessWidget {
  final String label;
  final double value;
  final List<String> intensityLabels;

  const _SymptomSliderRow({
    required this.label,
    required this.value,
    required this.intensityLabels,
  });

  @override
  Widget build(BuildContext context) {
    final double clampedValue =
        value.clamp(0, (intensityLabels.length - 1).toDouble()).toDouble();
    final endLabel = intensityLabels[clampedValue.round()];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                endLabel,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 4),
          IgnorePointer(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 4,
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey.shade300,
              ),
              child: Slider(
                value: clampedValue,
                max: (intensityLabels.length - 1).toDouble(),
                onChanged: (_) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --------------------------------------------
/// Helpers
/// --------------------------------------------

class _AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _AppCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _Squiggle extends StatelessWidget {
  const _Squiggle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "~~~~~~~~~~~~~~~~~~~~~~~",
      style:
      TextStyle(color: Colors.black26, letterSpacing: 4),
    );
  }
}
