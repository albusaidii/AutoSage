import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:3000/api";

  // ======================
  // LOGIN
  // ======================
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == true) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("token", data["token"]);
      await prefs.setInt("user_id", data["user"]["id"]);
      await prefs.setString("user_name", data["user"]["name"]);
      await prefs.setString("user_email", data["user"]["email"]);
    }

    return data;
  }

  // ======================
  // SIGNUP
  // ======================
  static Future<Map<String, dynamic>> signup(
      String name,
      String email,
      String phone,
      String password,
      ) async {
    final url = Uri.parse("$baseUrl/signup");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }


  // ======================
  // TOKEN HELPERS
  // ======================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }

// ======================
// USER PROFILE
// ======================

  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String phone,
  }) async {
    final url = Uri.parse("$baseUrl/profile/$userId");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
      }),
    );

    return jsonDecode(response.body);
  }

}



