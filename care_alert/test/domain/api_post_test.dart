import 'package:care_alert/domain/models/ticket.dart';
import 'package:care_alert/domain/utils/api_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sendAlert returns failure for missing required fields in ticket', () async {
      final ticket = Ticket(
        title: "test",
        description: "teuiuk68i57",
        employee: "Employee 1",
        client: "Client A",
        severity: "High",
        category: "Geweld",
        room_id: "Room 101",
        latitude: "52.370216",
        longitude: "4.895168",
        email_team_leader: "leader@test.com",
        adress: "Test Street 123",
        date: DateTime.now(),
        status: "Open", 
        ticket: '',
        
      );

      final response = await ApiService.sendAlert(ticket);
      print(response.message);

      expect(response.success, false);
    });

    test("get data", () async {
      final response = await ApiService.fetchTickets();
      print(response.message);

      print( response.data);
    });
}