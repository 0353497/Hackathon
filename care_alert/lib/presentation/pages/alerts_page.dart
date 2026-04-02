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
  late Future<ApiResponse> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = ApiService.fetchTickets();
  }

  Future<void> _reloadTickets() async {
    setState(() {
      _ticketsFuture = ApiService.fetchTickets();
    });
    await _ticketsFuture;
  }

  List<Ticket> _extractTickets(ApiResponse response) {
    final raw = response.data?['tickets'];
    if (raw is List<Ticket>) {
      return raw;
    }
    return <Ticket>[];
  }

  void _showTicketDetails(Ticket ticket) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (context, controller) {
            return ListView(
              controller: controller,
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ticket.title.isEmpty ? 'Zonder titel' : ticket.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _detailRow('Ticket', ticket.ticket),
                _detailRow('Status', ticket.status),
                _detailRow('Categorie', ticket.category),
                _detailRow('Ernst', ticket.severity),
                _detailRow('Cliënt', ticket.client),
                _detailRow('Medewerker', ticket.employee),
                _detailRow('Adres', ticket.adress),
                _detailRow('Kamer', ticket.room),
                _detailRow('Teamleider e-mail', ticket.email_team_leader),
                const SizedBox(height: 12),
                const Text(
                  'Beschrijving',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  ticket.description.isEmpty
                      ? 'Geen beschrijving beschikbaar.'
                      : ticket.description,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      child: RefreshIndicator(
        onRefresh: _reloadTickets,
        child: FutureBuilder<ApiResponse>(
          future: _ticketsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Text(
                    'Er ging iets mis bij het laden van meldingen.',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              );
            }

            final response = snapshot.data;
            if (response == null || !response.success) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    response?.message ?? 'Geen data ontvangen.',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              );
            }

            final tickets = _extractTickets(response)
              ..sort((a, b) => b.date.compareTo(a.date));

            if (tickets.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: const [Text('Er zijn nog geen meldingen beschikbaar.')],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: tickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return TicketCard(
                  ticket: ticket,
                  onTap: () => _showTicketDetails(ticket),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
