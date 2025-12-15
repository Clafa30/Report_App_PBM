import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2/report_app/reapp_api";

  /// ================= LOGIN =================
  static Future<Map<String, dynamic>> login(
    String phone,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/users/login.php"),
      body: {
        "phone": phone,
        "password": password,
      },
    );

    return jsonDecode(res.body);
  }

  /// ================= REGISTER =================
  static Future<Map<String, dynamic>> register(
    String name,
    String phone,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/users/register.php"),
      body: {
        "name": name,
        "phone": phone,
        "password": password,
      },
    );

    return jsonDecode(res.body);
  }

  /// ================= GET REPORTS =================
  static Future<Map<String, dynamic>> getReports(String userId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/reports/get_reports.php?user_id=$userId"),
    );

    return jsonDecode(res.body);
  }

  /// ================= UPLOAD REPORT =================
  static Future<Map<String, dynamic>> uploadReport({
    required String userId,
    required String description,
    File? beforeFile,
    File? afterFile,
  }) async {
    final uri = Uri.parse("$baseUrl/reports/upload_report.php");
    final request = http.MultipartRequest("POST", uri);

    request.fields["user_id"] = userId;
    request.fields["description"] = description;

    if (beforeFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("before", beforeFile.path),
      );
    }

    if (afterFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("after", afterFile.path),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    debugPrint("UPLOAD RESPONSE: ${response.body}");

    return jsonDecode(response.body);
  }

    /// ================= USER PAGE =================
    static Future<Map<String, dynamic>> updateProfile({
      required String userId,
      required String name,
      required String phone,
    }) async {
      final res = await http.post(
        Uri.parse("$baseUrl/users/update_profile.php"),
        body: {
          "user_id": userId,
          "name": name,
          "phone": phone,
        },
      );

      return jsonDecode(res.body);
    }

    /// ================= COMMENTS =================
    static Future<Map<String, dynamic>> getComments(String reportId) async {
      final url =
          "$baseUrl/comments/get_comment.php?report_id=$reportId";

      debugPrint("GET COMMENTS URL: $url");

      final res = await http.get(Uri.parse(url));

      debugPrint("GET COMMENTS RESPONSE: ${res.body}");

      return jsonDecode(res.body);
    }

    static Future<Map<String, dynamic>> sendComment({
      required String reportId,
      required String userId,
      required String comment,
    }) async {
      final res = await http.post(
        Uri.parse("$baseUrl/comments/add_comment.php"),
        body: {
          "report_id": reportId,
          "user_id": userId,
          "comment": comment,
        },
      );

      return jsonDecode(res.body);
    }
}
