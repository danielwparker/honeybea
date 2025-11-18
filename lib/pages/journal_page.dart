import 'package:flutter/material.dart';
import 'settings_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController notesController = TextEditingController();

  String selectedSpotting = "None";
  String selectedDischarge = "None";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Period Journal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
          )
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _journalCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Notes",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    _noteInput(),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _journalCard(child: _FlowSpottingDischargeSection()),

              const _SquiggleSeparator(),

              const SizedBox(height: 12),
              _journalCard(child: _SymptomSection(
                title: "Physical Symptoms",
                desc: "Rate the intensity from 0 (none) to 4 (very severe)",
                symptoms: physicalSymptoms,
                onChanged: (symptom, value) {
                  setState(() => physicalSymptoms[symptom] = value);
                },
              )),

              const SizedBox(height: 20),
              _journalCard(child: _SymptomSection(
                title: "Emotional Symptoms",
                desc: "Rate the intensity from 0 (none) to 4 (very severe)",
                symptoms: emotionalSymptoms,
                onChanged: (symptom, value) {
                  setState(() => emotionalSymptoms[symptom] = value);
                },
              )),

              const SizedBox(height: 90), // space above button
            ],
          ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

/// --------------------------------------------
/// Flow, Spotting, Discharge Section
/// --------------------------------------------
class _FlowSpottingDischargeSection extends StatelessWidget {
  const _FlowSpottingDischargeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Flow", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFFFFEE8C),
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(value: 0, onChanged: (_) {}),
        ),

        const SizedBox(height: 16),
        const Text("Spotting", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        _discreteSelector(["None", "Brown", "Red"], selected: 0),

        const SizedBox(height: 20),
        const Text("Discharge", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        _discreteSelector(["None", "Sticky", "Creamy", "Eggwhite", "Atypical"], selected: 0),
      ],
    );
  }

  Widget _discreteSelector(List<String> options, {required int selected}) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((label) {
        bool isSelected = label == options[selected];
        return Container(
          width: 95,
          height: 65,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFEE8C) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(label),
        );
      }).toList(),
    );
  }
}

/// --------------------------------------------
/// Symptoms Section
/// --------------------------------------------
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 12),

        ...symptoms.keys.map((symptom) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.circle_outlined, color: Color(0xFFFFEE8C)),
              const SizedBox(width: 10),
              Expanded(child: Text(symptom)),
              Slider(
                value: symptoms[symptom]!,
                min: 0,
                max: 4,
                divisions: 4,
                activeColor: const Color(0xFFFFEE8C),
                inactiveColor: Colors.grey.shade300,
                onChanged: (val) => onChanged(symptom, val),
              ),
              SizedBox(
                width: 20,
                child: Text(
                  symptoms[symptom]!.round().toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ))
      ],
    );
  }
}

/// --------------------------------------------
/// Squiggle (temporary placeholder)
/// --------------------------------------------
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
