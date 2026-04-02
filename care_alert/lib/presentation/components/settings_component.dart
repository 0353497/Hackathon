import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../pages/logout_page.dart';
import '../core/theme_provider.dart';

class SettingsComponent extends StatefulWidget {
  const SettingsComponent({Key? key}) : super(key: key);

  @override
  State<SettingsComponent> createState() => _SettingsComponentState();
}

class _SettingsComponentState extends State<SettingsComponent> {
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool urgentOnly = false;
  String autoLogout = '30';
  String language = 'nl';
  String role = 'Medewerker';

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Instellingen opgeslagen')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profiel
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text('Profiel', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Naam', style: TextStyle(color: Colors.grey)),
                  const Text('Sarah Peters'),
                  const SizedBox(height: 8),
                  const Text('E-mail', style: TextStyle(color: Colors.grey)),
                  const Text('sarah.peters@carealert.nl'),
                  const SizedBox(height: 8),
                  const Text('Rol', style: TextStyle(color: Colors.grey)),
                  DropdownButton<String>(
                    value: role,
                    onChanged: (value) => setState(() => role = value!),
                    items: const [
                      DropdownMenuItem(value: 'Medewerker', child: Text('Medewerker')),
                      DropdownMenuItem(value: 'Teamleider', child: Text('Teamleider')),
                      DropdownMenuItem(value: 'Veiligheidsfunctionaris', child: Text('Veiligheidsfunctionaris')),
                      DropdownMenuItem(value: 'Beheerder', child: Text('Beheerder')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Wachtwoord wijzigen'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Notificaties
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.notifications),
                      SizedBox(width: 8),
                      Text('Notificaties', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SwitchListTile(
                    title: const Text('E-mail notificaties'),
                    subtitle: const Text('Ontvang updates via e-mail'),
                    value: emailNotifications,
                    onChanged: (v) => setState(() => emailNotifications = v),
                  ),
                  SwitchListTile(
                    title: const Text('Push notificaties'),
                    subtitle: const Text('Ontvang meldingen op je apparaat'),
                    value: pushNotifications,
                    onChanged: (v) => setState(() => pushNotifications = v),
                  ),
                  SwitchListTile(
                    title: const Text('Alleen urgente meldingen'),
                    subtitle: const Text('Ontvang alleen hoge prioriteit meldingen'),
                    value: urgentOnly,
                    onChanged: (v) => setState(() => urgentOnly = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Beveiliging
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.security),
                      SizedBox(width: 8),
                      Text('Beveiliging', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Automatisch uitloggen na', style: TextStyle(color: Colors.grey)),
                  DropdownButton<String>(
                    value: autoLogout,
                    onChanged: (value) => setState(() => autoLogout = value!),
                    items: const [
                      DropdownMenuItem(value: '15', child: Text('15 minuten')),
                      DropdownMenuItem(value: '30', child: Text('30 minuten')),
                      DropdownMenuItem(value: '60', child: Text('1 uur')),
                      DropdownMenuItem(value: 'never', child: Text('Nooit')),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Uiterlijk
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.dark_mode),
                      SizedBox(width: 8),
                      Text('Uiterlijk', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return SwitchListTile(
                        title: const Text('Donkere modus'),
                        subtitle: const Text('Gebruik donker thema'),
                        value: themeProvider.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(value ? 'Donkere modus ingeschakeld' : 'Lichte modus ingeschakeld')),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Taal & Regio
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.language),
                      SizedBox(width: 8),
                      Text('Taal & Regio', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Taal', style: TextStyle(color: Colors.grey)),
                  DropdownButton<String>(
                    value: language,
                    onChanged: (value) => setState(() => language = value!),
                    items: const [
                      DropdownMenuItem(value: 'nl', child: Text('Nederlands')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Privacy Info
          Card(
            color: Colors.blueAccent.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.shield, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Privacy & Beveiliging', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        SizedBox(height: 4),
                        Text(
                          'CareAlert voldoet aan AVG en NEN 7510 normen. Alle gegevens worden versleuteld opgeslagen en alleen gedeeld met bevoegde personen.',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Opslaan/Annuleren
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  child: const Text('Instellingen opslaan'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Annuleren'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Sessie', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Beheer je actieve sessie'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LogoutPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Ga naar uitlogpagina'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
