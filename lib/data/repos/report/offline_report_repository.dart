import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reporting_system/data/models/report.dart';
import 'package:reporting_system/data/repos/report/base_report_repository.dart';
import 'package:http/http.dart' as http;

class OfflineReportRepository implements BaseReportRepository {
  final String apiUrl = 'http://localhost:3006/reports';
  @override
  EitherReport<Report> addReport(Report report) async {
    try {
      const storage = FlutterSecureStorage();
      final String? jwtToken = await storage.read(key: 'token');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(report.toMap()),
      );
      if (response.statusCode == 200) {
        return right(report); // No error
      } else {
        return left(
            'Unauthorized: Token may be expired or invalid'); // Return the error message
      }
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherReport<String> deleteReport(String reportId) async {
    const storage = FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'token');
    final Uri uri = Uri.parse('$apiUrl/$reportId');
    final response = await http.delete(uri, headers: {
      'Authorization': 'Bearer $jwtToken',
    });
    if (response.statusCode == 200) {
      return right(jsonDecode(response.body)['message']);
    } else {
      // Handle errors
      return left('error deleting report');
    }
  }

  @override
  EitherReport<List<Report>> getAllReports() async {
    const storage = FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'token');
    final Uri uri = Uri.parse(apiUrl);
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $jwtToken',
    });
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> reportsJson = jsonDecode(response.body);

      // Convert the JSON data to a list of Report objects
      final List<Report> reports = List<Report>.from(
        reportsJson.map((report) => Report.fromJson(report)),
      );

      return right(reports);
    } else {
      // Handle errors
      return left('error fetching reports');
    }
  }
}
