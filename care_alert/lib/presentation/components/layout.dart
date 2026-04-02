import 'package:flutter/material.dart';


class LayoutPage extends StatefulWidget {
  final Widget child;
  const LayoutPage({Key? key, required this.child}) : super(key: key);

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  bool showEmergencyPopup = false;
  String emergencyStep = 'confirm'; // 'confirm' or 'sent'
  int countdown = 10;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (showEmergencyPopup && emergencyStep == 'confirm' && countdown > 0) {
      setState(() {
        countdown--;
      });
      if (countdown == 0) {
        _handleConfirm();
      }
    }
  }

  void _handleEmergencyClick() {
    setState(() {
      showEmergencyPopup = true;
      emergencyStep = 'confirm';
      countdown = 10;
    });
    _ticker.start();
    // TODO: Play alarm sound
  }

  void _handleConfirm() {
    setState(() {
      emergencyStep = 'sent';
    });
    _ticker.stop();
    // TODO: Stop alarm sound
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showEmergencyPopup = false;
          emergencyStep = 'confirm';
        });
      }
    });
  }

  void _handleCancel() {
    setState(() {
      showEmergencyPopup = false;
      emergencyStep = 'confirm';
      countdown = 10;
    });
    _ticker.stop();
    // TODO: Stop alarm sound
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.favorite, color: Colors.blue, size: 32),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('CareAlert', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                              Text('Meldingen & Incidenten', style: TextStyle(fontSize: 12, color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),
                      Tooltip(
                        message: 'Noodmelding',
                        child: ElevatedButton(
                          onPressed: _handleEmergencyClick,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.all(12),
                            minimumSize: const Size(48, 48),
                            elevation: 4,
                          ),
                          child: const Icon(Icons.warning, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                // Main content
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
          // Emergency Popup
          if (showEmergencyPopup)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: emergencyStep == 'confirm'
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.red, Colors.redAccent],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.warning, color: Colors.white, size: 40),
                                ),
                                const SizedBox(height: 16),
                                Text('Noodmelding Bevestigen?', style: Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 8),
                                const Text('U staat op het punt een noodmelding te verzenden naar de veiligheidsdienst.'),
                                const SizedBox(height: 8),
                                Text('Automatische bevestiging over $countdown seconden', style: const TextStyle(color: Colors.orange)),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _handleCancel,
                                        child: const Text('Annuleren'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _handleConfirm,
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        child: const Text('Bevestigen'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.green, Colors.lightGreen],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_circle, color: Colors.white, size: 40),
                                ),
                                const SizedBox(height: 16),
                                Text('Noodmelding Verzonden!', style: Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 8),
                                const Text('Uw noodmelding is succesvol doorgestuurd naar de veiligheidsdienst. Hulp is onderweg.'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _handleCancel,
                                  child: const Text('Sluiten'),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Voor de countdown timer
class Ticker {
  Ticker(this.onTick);
  final void Function(Duration) onTick;
  bool _isActive = false;
  Duration _elapsed = Duration.zero;
  void start() {
    _isActive = true;
    _elapsed = Duration.zero;
    _tick();
  }
  void _tick() async {
    while (_isActive) {
      await Future.delayed(const Duration(seconds: 1));
      if (_isActive) {
        _elapsed += const Duration(seconds: 1);
        onTick(_elapsed);
      }
    }
  }
  void stop() {
    _isActive = false;
  }
  void dispose() {
    _isActive = false;
  }
}
