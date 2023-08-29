import 'package:dartz/dartz.dart';
import 'package:reporting_system/data/models/report.dart';

typedef EitherReport<T> = Future<Either<String, T>>;

abstract class BaseReportRepository {
  EitherReport<List<Report>> getAllReports();
  Future<void> addReport(Report report);
  Future<void> deleteReport(String reportId);
}
