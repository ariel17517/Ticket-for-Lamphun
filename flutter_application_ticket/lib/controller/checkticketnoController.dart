import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CheckTicketNoController {
  final String _apiUrl =
      'https://dev-api.lamphunwarriors.com/api/app/ticket/tracking';

  String formatDateToThaiTime() {
    DateTime now = DateTime.now();
    return DateFormat('dd/MM/yyyy HH:mm').format(now);
  }
  Future<Map<String, String>> checkTicket(
      {required String ticketNo, required String token}) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'ticketNo': ticketNo}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        String formattedDate = formatDateToThaiTime();
        return {
          'เลขที่ตั๋ว': data['ticketNo'] ?? '-',
          'สถานะ': data['statusName'] ?? '-',
          'ชื่อรายการแข่งขัน': data['tournamentName'] ?? '-',
          'วันที่': formattedDate,
          'โซนที่นั่ง': data['zoneName'] ?? '-',
        };
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
