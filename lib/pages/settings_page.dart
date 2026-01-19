import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedPrivacy = "local";
  Map<String, bool> _notificationPrefs = {
    "period": false,
    "cycle": false,
    "birth": false,
    "ovulation": false,
    "fertile": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () {
            // Go back to the previous screen
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _dataPrivacySection(),
              const SizedBox(height: 24),
              _localBackupButton(),
              const SizedBox(height: 24),
              _aboutPrivacy(),
              const SizedBox(height: 24),
              const _Squiggle(),
              const SizedBox(height: 24),
              _notificationsSection(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  /// --------------------------------------------
  /// Data Privacy
  /// --------------------------------------------
  Widget _dataPrivacySection() {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Privacy",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text("Choose how your period tracking data is stored",
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          _privacyTile(
            value: "local",
            icon: Icons.security,
            title: "Fully Local Hosted",
            body:
            "All data is stored only on this device. Most private option, but data will be lost if device is lost or reset.",
          ),
          const SizedBox(height: 16),
          _privacyTile(
            value: "cloud",
            icon: Icons.cloud,
            title: "Cloud Backup",
            body:
            "Data is continuously synced via End to End Encryption to cloud storage. Lets access data across multiple devices.",
          ),
        ],
      ),
    );
  }

  Widget _privacyTile({
    required String value,
    required IconData icon,
    required String title,
    required String body,
  }) {
    final bool isSelected = _selectedPrivacy == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedPrivacy = value),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(body,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.black38,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  /// --------------------------------------------
  /// Local Backup CTA
  /// --------------------------------------------
  Widget _localBackupButton() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEE8C),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.folder_open, size: 18),
            SizedBox(width: 8),
            Text("Set up Local Backup",
                style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  /// --------------------------------------------
  /// About Privacy
  /// --------------------------------------------
  Widget _aboutPrivacy() {
    return const _AppCard(
      child: Text(
        "We take your privacy seriously. All cloud backups are encrypted end-to-end, "
            "and your data is never shared with third parties. You can change this setting at any time.",
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  /// --------------------------------------------
  /// Notifications
  /// --------------------------------------------
  Widget _notificationsSection() {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Notifications",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text("Choose which notifications you want to receive",
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          _notificationTile("Period Reminder", "period",
              icon: Icons.notifications),
          _notificationTile("Cycle Phase Changes", "cycle",
              icon: Icons.notifications_active),
          _notificationTile("Birth Control", "birth",
              icon: Icons.medication),
          _notificationTile("Ovulation Reminder", "ovulation",
              icon: Icons.water_drop),
          _notificationTile("Fertile Window", "fertile",
              icon: Icons.energy_savings_leaf),
        ],
      ),
    );
  }

  Widget _notificationTile(String title, String key,
      {required IconData icon}) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _notificationPrefs[key]!,
          onChanged: (value) =>
              setState(() => _notificationPrefs[key] = value),
          title: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          subtitle: Text(
            _buildNotificationSubtitle(title),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
        if (key != "fertile") const Divider(),
      ],
    );
  }

  String _buildNotificationSubtitle(String title) {
    switch (title) {
      case "Period Reminder":
        return "Receive a reminder when your period is due.";
      case "Cycle Phase Changes":
        return "Receive notifications when your cycle phase changes.";
      case "Birth Control":
        return "Receive reminders for your birth control.";
      case "Ovulation Reminder":
        return "Receive a reminder when you are ovulating.";
      default:
        return "Receive a reminder when you are in your fertile window.";
    }
  }
}

/// --------------------------------------------
/// Helpers
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

class _Squiggle extends StatelessWidget {
  const _Squiggle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "~~~~~~~~~~~~~~~~~~~~~~~",
      style: TextStyle(color: Colors.black26, letterSpacing: 4),
    );
  }
}
