import 'package:care_alert/domain/models/ticket.dart';
import 'package:care_alert/domain/utils/api_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiService - sendAlert', () {
    test('sendAlert returns failure for missing required fields in ticket', () async {
      final ticket = Ticket(
        adress: '',
        category: 'fall',
        client: 'Client 1',
        date: DateTime.now(),
        description: 'Test description',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test',
      );

      final response = await ApiService.sendAlert(ticket);

      expect(response.success, false);
      expect(response.message, 'Missing required fields.');
    });

    test('sendAlert returns failure when category is empty', () async {
      final ticket = Ticket(
        adress: 'Test Address',
        category: '',
        client: 'Client 1',
        date: DateTime.now(),
        description: 'Test description',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test',
      );

      final response = await ApiService.sendAlert(ticket);

      expect(response.success, false);
      expect(response.message, 'Missing required fields.');
    });

    test('sendAlert returns failure when description is empty', () async {
      final ticket = Ticket(
        adress: 'Test Address',
        category: 'fall',
        client: 'Client 1',
        date: DateTime.now(),
        description: '',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test',
      );

      final response = await ApiService.sendAlert(ticket);

      expect(response.success, false);
      expect(response.message, 'Missing required fields.');
    });

    test('sendAlert returns failure when severity is empty', () async {
      final ticket = Ticket(
        adress: 'Test Address',
        category: 'fall',
        client: 'Client 1',
        date: DateTime.now(),
        description: 'Test description',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: '',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test',
      );

      final response = await ApiService.sendAlert(ticket);

      expect(response.success, false);
      expect(response.message, 'Missing required fields.');
    });

    test('sendAlert trims whitespace from ticket fields', () async {
      final ticket = Ticket(
        adress: '  Test Address  ',
        category: '  fall  ',
        client: 'Client 1',
        date: DateTime.now(),
        description: '  Test description  ',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: '  high  ',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test',
      );
      print('Testing with ticket: ${ticket.toJson()}');
      print('URL: http://192.168.137.49:5000/tickets');

      final response = await ApiService.sendAlert(ticket);
print('Received response: success=${response.success}, message="${response.message}", statusCode=${response.statusCode}');
      expect(response.success, isFalse);
      expect(response.statusCode, isNotNull);
    });

    test('sendAlert handles network errors gracefully', () async {
      final ticket = Ticket(
        adress: 'Test Address',
        category: 'fall',
        client: 'Client 1',
        date: DateTime.now(),
        description: 'Test description',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test',
      );

      final response = await ApiService.sendAlert(ticket);

      expect(response, isNotNull);
      expect(response.message, isNotEmpty);
    });

    test('sendAlert correctly serializes ticket to JSON', () async {
      final dateTime = DateTime(2026, 4, 1, 10, 0, 0);
      final ticket = Ticket(
        adress: 'Test Address',
        category: 'fall',
        client: 'Client 1',
        date: dateTime,
        description: 'Test description',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test Ticket',
      );

      final json = ticket.toJson();

      expect(json['category'], 'fall');
      expect(json['adress'], 'Test Address');
      expect(json['description'], 'Test description');
      expect(json['severity'], 'high');
      expect(json['date'], isA<int>());
    });
  });

  group('Ticket Model - Serialization', () {
    test('Ticket.fromJson correctly parses unix timestamp from int', () {
      final unixTime = 1743465600; // 2026-04-01 00:00:00 UTC
      final json = {
        'adress': 'Test Address',
        'category': 'fall',
        'client': 'Client 1',
        'date': unixTime,
        'description': 'Test description',
        'email_team_leader': 'leader@test.com',
        'employee': 'Employee 1',
        'latitude': '52.52',
        'longitude': '13.40',
        'room_id': '101',
        'severity': 'high',
        'status': 'open',
        'ticket': 'TKT001',
        'title': 'Test Ticket',
      };

      final ticket = Ticket.fromJson(json);

      expect(ticket.adress, 'Test Address');
      expect(ticket.category, 'fall');
      expect(ticket.description, 'Test description');
      expect(ticket.ticket, 'TKT001');
      expect(ticket.date.millisecondsSinceEpoch, unixTime * 1000);
    });

    test('Ticket.fromJson handles missing fields with defaults', () {
      final json = {
        'category': 'fall',
        'client': 'Client 1',
        'date': 1743465600,
      };

      final ticket = Ticket.fromJson(json);

      expect(ticket.adress, '');
      expect(ticket.description, '');
      expect(ticket.category, 'fall');
    });

    test('Ticket.toJson converts DateTime to unix timestamp as int', () {
      final dateTime = DateTime(2026, 4, 1, 10, 0, 0);
      final expectedUnixTime = dateTime.millisecondsSinceEpoch ~/ 1000;

      final ticket = Ticket(
        adress: 'Test Address',
        category: 'fall',
        client: 'Client 1',
        date: dateTime,
        description: 'Test description',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test Ticket',
      );

      final json = ticket.toJson();

      expect(json['date'], isA<int>());
      expect(json['date'], expectedUnixTime);
      expect(json['adress'], 'Test Address');
      expect(json['category'], 'fall');
    });

    test('Ticket.toJson includes all required fields', () {
      final ticket = Ticket(
        adress: 'Test Address',
        category: 'fall',
        client: 'Client 1',
        date: DateTime.now(),
        description: 'Test description',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test Ticket',
      );

      final json = ticket.toJson();

      expect(json.containsKey('adress'), true);
      expect(json.containsKey('category'), true);
      expect(json.containsKey('client'), true);
      expect(json.containsKey('date'), true);
      expect(json.containsKey('description'), true);
      expect(json.containsKey('email_team_leader'), true);
      expect(json.containsKey('employee'), true);
      expect(json.containsKey('latitude'), true);
      expect(json.containsKey('longitude'), true);
      expect(json.containsKey('room_id'), true);
      expect(json.containsKey('severity'), true);
      expect(json.containsKey('status'), true);
      expect(json.containsKey('ticket'), true);
      expect(json.containsKey('title'), true);
    });

    test('Ticket.copyWith creates modified copy correctly', () {
      final originalDate = DateTime(2026, 4, 1);
      final ticket = Ticket(
        adress: 'Address 1',
        category: 'fall',
        client: 'Client 1',
        date: originalDate,
        description: 'Description 1',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Title 1',
      );

      final modifiedTicket = ticket.copyWith(
        status: 'closed',
        severity: 'critical',
      );

      expect(modifiedTicket.status, 'closed');
      expect(modifiedTicket.severity, 'critical');
      expect(modifiedTicket.adress, 'Address 1');
      expect(modifiedTicket.description, 'Description 1');
      expect(modifiedTicket.date, originalDate);
    });

    test('Ticket.copyWith with all fields', () {
      final originalTicket = Ticket(
        adress: 'Address 1',
        category: 'fall',
        client: 'Client 1',
        date: DateTime(2026, 4, 1),
        description: 'Description 1',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Title 1',
      );

      final newDate = DateTime(2026, 4, 2);
      final modifiedTicket = originalTicket.copyWith(
        adress: 'New Address',
        category: 'aggression',
        client: 'New Client',
        date: newDate,
        description: 'New Description',
        email_team_leader: 'newleader@test.com',
        employee: 'New Employee',
        latitude: '51.50',
        longitude: '0.13',
        room_id: '202',
        severity: 'critical',
        status: 'closed',
        ticket: 'TKT002',
        title: 'New Title',
      );

      expect(modifiedTicket.adress, 'New Address');
      expect(modifiedTicket.category, 'aggression');
      expect(modifiedTicket.client, 'New Client');
      expect(modifiedTicket.date, newDate);
      expect(modifiedTicket.description, 'New Description');
      expect(modifiedTicket.severity, 'critical');
      expect(modifiedTicket.status, 'closed');
      expect(modifiedTicket.ticket, 'TKT002');
    });

    test('Ticket roundtrip: toJson -> fromJson preserves data', () {
      final originalDate = DateTime(2026, 4, 1, 10, 30, 45);
      final originalTicket = Ticket(
        adress: 'Test Address',
        category: 'medical',
        client: 'Client 1',
        date: originalDate,
        description: 'Test description',
        email_team_leader: 'leader@test.com',
        employee: 'Employee 1',
        latitude: '52.52',
        longitude: '13.40',
        room_id: '101',
        severity: 'high',
        status: 'open',
        ticket: 'TKT001',
        title: 'Test Ticket',
      );

      final json = originalTicket.toJson();
      final reconstructedTicket = Ticket.fromJson(json);

      expect(reconstructedTicket.adress, originalTicket.adress);
      expect(reconstructedTicket.category, originalTicket.category);
      expect(reconstructedTicket.client, originalTicket.client);
      expect(reconstructedTicket.date.millisecondsSinceEpoch ~/ 1000,
          originalDate.millisecondsSinceEpoch ~/ 1000);
      expect(reconstructedTicket.description, originalTicket.description);
      expect(reconstructedTicket.severity, originalTicket.severity);
      expect(reconstructedTicket.status, originalTicket.status);
      expect(reconstructedTicket.ticket, originalTicket.ticket);
    });
  });

  group('Ticket - Null Safety Edge Cases', () {
    test('Ticket.fromJson handles string date falling back to DateTime.now()',
        () {
      final json = {
        'adress': 'Test',
        'category': 'fall',
        'client': 'Client',
        'date': 'invalid-date-format',
        'description': 'Test',
        'email_team_leader': 'test@test.com',
        'employee': 'Employee',
        'latitude': '0',
        'longitude': '0',
        'room_id': '1',
        'severity': 'high',
        'status': 'open',
        'ticket': 'TKT001',
        'title': 'Test',
      };

      final ticket = Ticket.fromJson(json);
      expect(ticket.date, isNotNull);
    });

    test('Ticket.fromJson handles null date field', () {
      final json = {
        'adress': 'Test',
        'category': 'fall',
        'client': 'Client',
        'date': null,
        'description': 'Test',
        'email_team_leader': 'test@test.com',
        'employee': 'Employee',
        'latitude': '0',
        'longitude': '0',
        'room_id': '1',
        'severity': 'high',
        'status': 'open',
        'ticket': 'TKT001',
        'title': 'Test',
      };

      final ticket = Ticket.fromJson(json);
      expect(ticket.date, isNotNull);
    });
  });
}

