import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime currentMonth = DateTime(2025, 10);
  int today = 14;

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
      bool isToday = (day == today);
      bool isPeriodDay = day >= 13 && day <= 17;
      bool hasDot = day == 1 || day == 10;

      dayTiles.add(
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color:
            isPeriodDay ? Colors.red.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border:
            isToday ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          alignment: Alignment.center,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "$day",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              if (hasDot)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
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
                  _circleIcon(Icons.chevron_left),
                  const SizedBox(width: 10),
                  _circleIcon(Icons.chevron_right),
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

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
      child: Icon(icon, size: 20),
    );
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
              _legendCircle(Colors.red.shade200),
              const SizedBox(width: 6),
              const Text("Light"),
              const SizedBox(width: 14),
              _legendCircle(Colors.red.shade400),
              const SizedBox(width: 6),
              const Text("Medium"),
              const SizedBox(width: 14),
              _legendCircle(Colors.red),
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
              _legendCircle(Colors.blue),
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
      decoration:
      BoxDecoration(color: color, shape: BoxShape.circle),
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
