import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/calendar_page.dart';
import 'pages/analysis_page.dart';
import 'pages/donate_page.dart';
import 'pages/journal_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Scaffold',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CalendarPage(),
    AnalysisPage(),
    DonatePage(),
  ];

  void _openJournal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const JournalPage()),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _index == 0 ? "Your cycle" : ['Calendar', 'Analysis', 'Donate'][_index - 1],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),


      body: _pages[_index],

      floatingActionButton: Container(
        height: 62,
        width: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFEE8C), // Updated yellow
          /*border: Border.all(
            color: Colors.black.withOpacity(0.25), // Soft outline
            width: 1.5,
          ),*/
        ),
        child: FloatingActionButton(
          onPressed: _openJournal,
          elevation: 0,
          backgroundColor: Colors.transparent,
          splashColor: Colors.black12,
          highlightElevation: 0,
          child: const Icon(
            Icons.edit,
            color: Colors.black,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, -2),
              blurRadius: 12,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomAppBar(
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            elevation: 0,
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(
                    index: 0,
                    iconFilled: Icons.home,
                    iconOutlined: Icons.home_outlined,
                    label: "Home",
                  ),
                  _navItem(
                    index: 1,
                    iconFilled: Icons.calendar_today,
                    iconOutlined: Icons.calendar_today_outlined,
                    label: "Calendar",
                  ),
                  const SizedBox(width: 5), // Space under FAB
                  _navItem(
                    index: 2,
                    iconFilled: Icons.auto_graph,
                    iconOutlined: Icons.auto_graph_outlined,
                    label: "Analysis",
                  ),
                  _navItem(
                    index: 3,
                    iconFilled: Icons.favorite,
                    iconOutlined: Icons.favorite_border,
                    label: "Donate",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData iconFilled,
    required IconData iconOutlined,
    required String label,
  }) {
    final isSelected = _index == index;

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: InkWell(
        onTap: () => setState(() => _index = index),
        child: SizedBox(
          width: 60,
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? iconFilled : iconOutlined,
                size: 26,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
