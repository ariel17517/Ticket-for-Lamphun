import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReAccessTicketNoController {
  Future<Map<String, dynamic>> reAccessTicket({
    required String ticketNo,
    required String cusName,
    required String cusTel,
    required String cusEmail,
  }) async {
    const String url =
        "https://dev-api.lamphunwarriors.com/api/app/ticket/reaccess";

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');
      if (token == null) {
        return {"error": "ไม่มี Token กรุณาเข้าสู่ระบบใหม่"};
      }

      final Map<String, dynamic> body = {
        "ticketNo": ticketNo,
        "cusName": cusName,
        "cusTel": cusTel,
        "cusEmail": cusEmail,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey("statusName")) {
          final String statusName = data["statusName"];
          final bool success = statusName == "พร้อมใช้งาน" ||
              statusName == "ให้เข้าใช้งานอีกครั้ง";

          return {
            "statusName": statusName,
            "success": success,
          };
        } else {
          return {"error": "ไม่สำเร็จ"};
        }
      } else {
        return {"error": "ไม่สำเร็จ"};
      }
    } catch (e) {
      return {"error": "ไม่สำเร็จ"};
    }
  }
}
