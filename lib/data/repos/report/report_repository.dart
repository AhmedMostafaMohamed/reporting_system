import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:reporting_system/data/models/report.dart';
import 'package:reporting_system/data/repos/report/base_report_repository.dart';

class ReportRepository extends BaseReportRepository {
  final FirebaseFirestore _firebaseFirestore;
  ReportRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  EitherReport<Report> addReport(Report report) async {
    try {
      await _firebaseFirestore
          .collection('reports')
          .add({'report': report.toMap()});
      return right(report);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherReport<String> deleteReport(String reportId) async {
    try {
      await _firebaseFirestore.collection('reports').doc(reportId).delete();
      return right(reportId);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherReport<List<Report>> getAllReports() async {
    List<Report> reports = [];
    try {
      var snapshot = await _firebaseFirestore.collection('reports').get();
      reports = snapshot.docs.map((doc) => Report.fromSnapshot(doc)).toList();
      return right(reports);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }
}
