import 'package:care_alert/domain/providers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InlogPage extends StatefulWidget {
  const InlogPage({super.key});

  @override
  State<InlogPage> createState() => _InlogPageState();
}

class _InlogPageState extends State<InlogPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _showPassword = false;
  String _error = '';

  static const Map<String, Map<String, String>> _credentials = {
    'medewerker': {'email': 'medewerker@zorg.nl', 'password': 'demo123'},
    'teamleider': {'email': 'teamleider@zorg.nl', 'password': 'demo123'},
    'veiligheid': {'email': 'veiligheid@zorg.nl', 'password': 'demo123'},
    'admin': {'email': 'admin@zorg.nl', 'password': 'admin123'},
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _credentials.values.any(
      (item) => item['email'] == email && item['password'] == password,
    );
  }

  Future<void> _handleSubmit() async {
    if (_isLoading) {
      return;
    }

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    setState(() {
      _error = '';
      _isLoading = true;
    });

    try {
      final success = await _login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Welkom bij CareAlert!')));

        AuthController.to.login();
      } else {
        setState(() {
          _error = 'Onjuist e-mailadres of wachtwoord';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login mislukt: controleer inloggegevens'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'Er is een fout opgetreden. Probeer het opnieuw.';
      });
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _fillDemoCredentials(String role) {
    final data = _credentials[role];
    if (data == null) {
      return;
    }
    setState(() {
      _emailController.text = data['email'] ?? '';
      _passwordController.text = data['password'] ?? '';
      _error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEFF6FF), Color(0xFFFFFFFF), Color(0xFFEEF2FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF4338CA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x332563EB),
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.security_rounded,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'CareAlert',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Meldingen en incidenten in de zorg',
                          style: TextStyle(color: Color(0xFF4B5563)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Card(
                      elevation: 14,
                      shadowColor: const Color(0x22000000),
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'E-mailadres',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                enabled: !_isLoading,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                  hintText: 'naam@zorginstelling.nl',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  final text = (value ?? '').trim();
                                  if (text.isEmpty) {
                                    return 'E-mailadres is verplicht';
                                  }
                                  if (!text.contains('@')) {
                                    return 'Vul een geldig e-mailadres in';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Wachtwoord',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                enabled: !_isLoading,
                                obscureText: !_showPassword,
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                    icon: Icon(
                                      _showPassword
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if ((value ?? '').isEmpty) {
                                    return 'Wachtwoord is verplicht';
                                  }
                                  return null;
                                },
                              ),
                              if (_error.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFFECACA),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Color(0xFFDC2626),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _error,
                                          style: const TextStyle(
                                            color: Color(0xFF991B1B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: _isLoading ? null : _handleSubmit,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: _isLoading
                                      ? const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text('Inloggen...'),
                                          ],
                                        )
                                      : const Text('Inloggen'),
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Divider(),
                              const SizedBox(height: 8),
                              const Center(
                                child: Text(
                                  'Demo Accounts',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 2.7,
                                children: [
                                  OutlinedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () => _fillDemoCredentials(
                                            'medewerker',
                                          ),
                                    child: const Text('Medewerker'),
                                  ),
                                  OutlinedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () => _fillDemoCredentials(
                                            'teamleider',
                                          ),
                                    child: const Text('Teamleider'),
                                  ),
                                  OutlinedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () => _fillDemoCredentials(
                                            'veiligheid',
                                          ),
                                    child: const Text('Veiligheid'),
                                  ),
                                  OutlinedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () => _fillDemoCredentials('admin'),
                                    child: const Text('Admin'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Card(
                      color: const Color(0xFFEFF6FF),
                      child: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Demo Inloggegevens',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Gebruik de demo knoppen hierboven om snel in te loggen als medewerker, teamleider, veiligheid of admin.',
                              style: TextStyle(
                                color: Color(0xFF1D4ED8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Copyright 2026 CareAlert - Veilig melden in de zorg',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
