import 'dart:convert';

import 'package:care_alert/domain/models/ticket.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  const ApiResponse({
    required this.success,
    required this.message,
    this.statusCode,
    this.data,
  });

  final bool success;
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? data;
}

class ApiService {
  static const String baseUrl = 'http://145.97.93.252:5000';
  static const Duration _timeout = Duration(seconds: 15);

  static Future<ApiResponse> sendAlert(Ticket ticket) async {
    if (ticket.category.trim().isEmpty ||
        ticket.adress.trim().isEmpty ||
        ticket.description.trim().isEmpty ||
        ticket.severity.trim().isEmpty) {
      return const ApiResponse(
        success: false,
        message: 'Missing required fields.',
      );
    }

    final uri = Uri.parse('$baseUrl/tickets');
    final payload = ticket.toJson();

    try {
      final response = await http
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(_timeout);

      Map<String, dynamic>? body;
      if (response.body.isNotEmpty) {
        final parsed = jsonDecode(response.body);
        if (parsed is Map<String, dynamic>) {
          body = parsed;
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          message: (body?['message'] as String?) ?? 'Alert sent successfully.',
          statusCode: response.statusCode,
          data: body,
        );
      }

      return ApiResponse(
        success: false,
        message:
            (body?['message'] as String?) ?? 'Failed to send alert to server.',
        statusCode: response.statusCode,
        data: body,
      );
    } on FormatException {
      return const ApiResponse(
        success: false,
        message: 'Invalid server response format.',
      );
    } catch (_) {
      return const ApiResponse(
        success: false,
        message: 'Network error while sending alert.',
      );
    }
  }

  static Future<ApiResponse> fetchTickets() async {
    final uri = Uri.parse('$baseUrl/tickets');

    try {
      final response = await http
          .get(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final parsed = jsonDecode(response.body);
        List<Ticket> tickets = [];

        if (parsed is List) {
          tickets = parsed
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .map(Ticket.fromJson)
              .toList();
        }

        return ApiResponse(
          success: true,
          message: 'Tickets fetched successfully.',
          statusCode: response.statusCode,
          data: {'tickets': tickets},
        );
      }

      return ApiResponse(
        success: false,
        message: 'Failed to fetch tickets.',
        statusCode: response.statusCode,
      );
    } catch (_) {
      return const ApiResponse(
        success: false,
        message: 'Network error while fetching tickets.',
      );
    }
  }

  static Future<ApiResponse> fetchTicketById(String ticketId) async {
    final uri = Uri.parse('$baseUrl/tickets/$ticketId');

    try {
      final response = await http
          .get(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final parsed = jsonDecode(response.body);
        final ticket = Ticket.fromJson(parsed as Map<String, dynamic>);

        return ApiResponse(
          success: true,
          message: 'Ticket fetched successfully.',
          statusCode: response.statusCode,
          data: {'ticket': ticket},
        );
      }

      return ApiResponse(
        success: false,
        message: 'Failed to fetch ticket.',
        statusCode: response.statusCode,
      );
    } catch (_) {
      return const ApiResponse(
        success: false,
        message: 'Network error while fetching ticket.',
      );
    }
  }

  static Future<ApiResponse> updateTicket(Ticket ticket) async {
    final uri = Uri.parse('$baseUrl/tickets/${ticket.ticket}');

    try {
      final response = await http
          .put(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(ticket.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final parsed = jsonDecode(response.body);
        final updatedTicket = Ticket.fromJson(parsed as Map<String, dynamic>);

        return ApiResponse(
          success: true,
          message: 'Ticket updated successfully.',
          statusCode: response.statusCode,
          data: {'ticket': updatedTicket},
        );
      }

      return ApiResponse(
        success: false,
        message: 'Failed to update ticket.',
        statusCode: response.statusCode,
      );
    } catch (_) {
      return const ApiResponse(
        success: false,
        message: 'Network error while updating ticket.',
      );
    }
  }
}
