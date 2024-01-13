import 'package:dartz/dartz.dart';
import 'package:reporting_system/data/models/report.dart';

typedef EitherReport<T> = Future<Either<String, T>>;

abstract class BaseReportRepository {
  EitherReport<List<Report>> getAllReports();
  EitherReport<Report> addReport(Report report);
  EitherReport<String> deleteReport(String reportId);
}
