part of 'report_bloc.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class FetchReportsEvent extends ReportEvent {}

class DeleteReportEvent extends ReportEvent {
  final String reportId;
  const DeleteReportEvent({required this.reportId});
}

class AddReportEvent extends ReportEvent {
  final Report report;
  const AddReportEvent({required this.report});
}
