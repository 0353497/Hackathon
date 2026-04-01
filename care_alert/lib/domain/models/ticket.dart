class Ticket {
  final String adress;
  final String category;
  final String client;
  final DateTime date;
  final String description;
  final String email_team_leader;
  final String employee;
  final String latitude;
  final String longitude;
  final String room_id;
  final String severity;
  final String status;
  final String ticket;
  final String title;

  Ticket({
    required this.adress,
    required this.category,
    required this.client,
    required this.date,
    required this.description,
    required this.email_team_leader,
    required this.employee,
    required this.latitude,
    required this.longitude,
    required this.room_id,
    required this.severity,
    required this.status,
    required this.ticket,
    required this.title,
  });

  Ticket copyWith({
    String? adress,
    String? category,
    String? client,
    DateTime? date,
    String? description,
    String? email_team_leader,
    String? employee,
    String? latitude,
    String? longitude,
    String? room_id,
    String? severity,
    String? status,
    String? ticket,
    String? title,
  }) {
    return Ticket(
      adress: adress ?? this.adress,
      category: category ?? this.category,
      client: client ?? this.client,
      date: date ?? this.date,
      description: description ?? this.description,
      email_team_leader: email_team_leader ?? this.email_team_leader,
      employee: employee ?? this.employee,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      room_id: room_id ?? this.room_id,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      ticket: ticket ?? this.ticket,
      title: title ?? this.title,
    );
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    DateTime parseDate(dynamic dateValue) {
      if (dateValue is int) {
        // Support unix timestamps in either seconds or milliseconds.
        final isMilliseconds = dateValue > 1000000000000;
        return DateTime.fromMillisecondsSinceEpoch(
          isMilliseconds ? dateValue : dateValue * 1000,
        );
      } else if (dateValue is double) {
        final intValue = dateValue.toInt();
        final isMilliseconds = intValue > 1000000000000;
        return DateTime.fromMillisecondsSinceEpoch(
          isMilliseconds ? intValue : intValue * 1000,
        );
      } else if (dateValue is String) {
        final numericValue = int.tryParse(dateValue);
        if (numericValue != null) {
          final isMilliseconds = numericValue > 1000000000000;
          return DateTime.fromMillisecondsSinceEpoch(
            isMilliseconds ? numericValue : numericValue * 1000,
          );
        }
        return DateTime.tryParse(dateValue) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return Ticket(
      adress: parseString(json['adress'] ?? json['address']),
      category: parseString(json['category']),
      client: parseString(json['client']),
      date: parseDate(json['date'] ?? json['dateTime']),
      description: parseString(json['description']),
      email_team_leader: parseString(json['email_team_leader']),
      employee: parseString(json['employee']),
      latitude: parseString(json['latitude']),
      longitude: parseString(json['longitude']),
      room_id: parseString(json['room_id']),
      severity: parseString(json['severity']),
      status: parseString(json['status']),
      ticket: parseString(json['ticket'] ?? json['ticket_id']),
      title: parseString(json['title']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': adress,
      'adress': adress,
      'category': category,
      'client': client,
      'date': date.millisecondsSinceEpoch ~/ 1000,
      'description': description,
      'email_team_leader': email_team_leader,
      'employee': employee,
      'latitude': latitude,
      'longitude': longitude,
      'room_id': room_id,
      'severity': severity,
      'status': status,
      'ticket_id': ticket,
      'ticket': ticket,
      'title': title,
    };
  }
}

enum severity { low, medium, high, critical }
enum status { open, in_progress, closed }
enum category {
  MIC,
  MIM,
  Brandmelding,
  ongevalBijnaIncident,
  agressieGeweld,
  it,
}
