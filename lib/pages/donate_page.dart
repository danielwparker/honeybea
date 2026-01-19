import 'package:flutter/material.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              _SupportMissionCard(),
              SizedBox(height: 24),
              _Squiggle(),
              SizedBox(height: 24),
              _CustomAmountCard(),
              SizedBox(height: 24),
              _MonthlySupportCard(),
              SizedBox(height: 24),
              _ThankYouCard(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

/// --------------------------------------------
/// Support Our Mission Card
/// --------------------------------------------
class _SupportMissionCard extends StatelessWidget {
  const _SupportMissionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFBE7F4),
            Colors.white.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: const [
          Icon(Icons.favorite, color: Colors.blue, size: 34),
          SizedBox(height: 12),
          Text(
            "Support Our Mission",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text(
            "Help us keep Cycle Tracker free and accessible for everyone",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87),
          ),
          SizedBox(height: 8),
          Text(
            "Your donation helps us maintain and improve this app, keeping it free for all users who need it.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

/// --------------------------------------------
/// Custom Donation Card
/// --------------------------------------------
class _CustomAmountCard extends StatefulWidget {
  const _CustomAmountCard();

  @override
  State<_CustomAmountCard> createState() => _CustomAmountCardState();
}

class _CustomAmountCardState extends State<_CustomAmountCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Custom Amount",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: "\$ ",
              hintText: "Enter amount",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Donate Now",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --------------------------------------------
/// Monthly Support Card
/// --------------------------------------------
class _MonthlySupportCard extends StatelessWidget {
  const _MonthlySupportCard();

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Become a Monthly Supporter",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text("Recurring donations help us plan for the future",
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Set Up Monthly Donation",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --------------------------------------------
/// Thank You Card
/// --------------------------------------------
class _ThankYouCard extends StatelessWidget {
  const _ThankYouCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFFFFFFF),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: const [
          Icon(Icons.favorite_border, color: Colors.blue, size: 32),
          SizedBox(height: 12),
          Text("Thank you for considering a donation!",
              style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text(
            "Every contribution, no matter the size, makes a real difference in keeping this project alive and growing.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

/// --------------------------------------------
/// Squiggle
/// --------------------------------------------
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

/// --------------------------------------------
/// Shared Helper
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
