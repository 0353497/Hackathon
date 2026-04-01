import 'package:care_alert/domain/models/ticket.dart';
import 'package:care_alert/domain/utils/api_service.dart';
import 'package:care_alert/presentation/components/layout.dart';
import 'package:care_alert/presentation/components/ticket_card.dart';
import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late Future<List<Ticket>> _ticketsFuture;
  String? _selectedSeverity;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = _loadTickets();
  }

  Future<List<Ticket>> _loadTickets() async {
    final response = await ApiService.fetchTickets();
    if (!response.success) {
      throw Exception(response.message);
    }

    final tickets = response.data?['tickets'];
    if (tickets is List<Ticket>) {
      return tickets;
    }

    return [];
  }

  Future<void> _refresh() async {
    setState(() {
      _ticketsFuture = _loadTickets();
    });
    await _ticketsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      child: Column(
        children: [
          // Filter header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
        
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                DropdownButton<String?>(
                  value: _selectedSeverity,
                  hint: const Text('Alle prioriteiten'),
                  underline: SizedBox.shrink(),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: const Text('Alle prioriteiten'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'low',
                      child: Text('Laag'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'medium',
                      child: Text('Gemiddeld'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'high',
                      child: Text('Hoog'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'critical',
                      child: Text('Kritiek'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverity = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Tickets list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<Ticket>>(
                future: _ticketsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        Icon(
                          Icons.cloud_off,
                          size: 56,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Kon meldingen niet ophalen: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  var tickets = snapshot.data ?? const <Ticket>[];

                  // Apply severity filter
                  if (_selectedSeverity != null) {
                    tickets = tickets
                        .where(
                          (t) =>
                              t.severity.toLowerCase() ==
                              _selectedSeverity!.toLowerCase(),
                        )
                        .toList();
                  }

                  if (tickets.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 80),
                        Icon(
                          Icons.inbox_outlined,
                          size: 56,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Center(child: Text('Geen meldingen gevonden.')),
                      ],
                    );
                  }

                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return TicketCard(ticket: ticket);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: tickets.length,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
