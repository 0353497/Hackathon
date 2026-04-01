import 'package:flutter/material.dart';
import 'package:care_alert/domain/models/ticket.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${ticket.date.day.toString().padLeft(2, '0')}-${ticket.date.month.toString().padLeft(2, '0')}-${ticket.date.year} ${ticket.date.hour.toString().padLeft(2, '0')}:${ticket.date.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ticket.title.isEmpty ? 'Onbekende melding' : ticket.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _StatusBadge(status: ticket.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ticket.description.isEmpty
                  ? 'Geen beschrijving beschikbaar'
                  : ticket.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Pill(label: 'Prioriteit: ${ticket.severity}'),
                _Pill(label: 'Categorie: ${ticket.category}'),
                _Pill(label: 'Ticket: ${ticket.ticket}'),
              ],
            ),
            const SizedBox(height: 14),
            _InfoRow(label: 'Client', value: ticket.client),
            _InfoRow(label: 'Medewerker', value: ticket.employee),
            _InfoRow(label: 'Teamlead e-mail', value: ticket.email_team_leader),
            _InfoRow(label: 'Adres', value: ticket.adress),
            _InfoRow(label: 'Kamer', value: ticket.room_id),
            _InfoRow(label: 'Datum', value: dateText),
            _InfoRow(label: 'Latitude', value: ticket.latitude),
            _InfoRow(label: 'Longitude', value: ticket.longitude),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.blue.shade900),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.trim().toLowerCase();
    final color = switch (normalized) {
      'closed' => Colors.green,
      'in_progress' || 'in progress' => Colors.orange,
      _ => Colors.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.isEmpty ? 'unknown' : status,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
