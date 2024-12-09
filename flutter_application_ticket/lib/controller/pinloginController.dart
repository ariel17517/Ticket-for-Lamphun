import 'dart:convert';
import 'package:flutter_application_ticket/constant/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class pinLoginController {
  Future<bool> verifyPin(String pin) async {
    try {
      const String url = "https://dev-api.lamphunwarriors.com/api/app/auth/pin";
      final Map<String, String> payload = {'pin': pin};

      print("Request URL: $url");
      print("Request Headers: $headers");
      print("Request Body: ${jsonEncode(payload)}");

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('token') &&
            responseData['token'] != null) {
          final String token = responseData['token'];
          print("Token: $token");
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);

          return true;
        } else {
          print("No token found in the response");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("Error occurred: $e");
      return false;
    }
  }
}
