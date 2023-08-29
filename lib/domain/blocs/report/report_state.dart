part of 'report_bloc.dart';

sealed class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

final class ReportInitial extends ReportState {}

class LoadingState extends ReportState {}

class LoadedState extends ReportState {
  final List<Report> reports;

  const LoadedState({required this.reports});
}

class ReportAddedState extends ReportState {}

class ReportDeletedState extends ReportState {}

class ErrorState extends ReportState {
  final String errorMessage;
  const ErrorState({required this.errorMessage});
}
