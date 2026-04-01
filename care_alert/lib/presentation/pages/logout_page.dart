import 'package:care_alert/presentation/core/auth_controller.dart';
import 'package:flutter/material.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    await AuthController.to.logout();

    if (!mounted) {
      return;
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uitloggen')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Wil je uitloggen?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Na uitloggen moet je opnieuw inloggen en daarna ontgrendelen met biometrie.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoggingOut ? null : _logout,
                  icon: const Icon(Icons.logout),
                  label: Text(_isLoggingOut ? 'Bezig met uitloggen...' : 'Ja, uitloggen'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoggingOut ? null : () => Navigator.of(context).pop(),
                  child: const Text('Annuleren'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
