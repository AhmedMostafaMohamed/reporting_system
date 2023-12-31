import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reporting_system/data/models/report.dart';
import 'package:reporting_system/data/repos/report/report_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _reportRepository;
  ReportBloc({required ReportRepository reportRepository})
      : _reportRepository = reportRepository,
        super(ReportInitial()) {
    on<FetchReportsEvent>(_onFetchReportsEvent);
    on<AddReportEvent>(_onAddUserEvent);
    on<DeleteReportEvent>(_onDeleteUserEvent);
  }

  FutureOr<void> _onFetchReportsEvent(
      FetchReportsEvent event, Emitter<ReportState> emit) async {
    try {
      emit(LoadingState());
      final response = await _reportRepository.getAllReports();
      response.fold(
          (errorMessage) => emit(ErrorState(errorMessage: errorMessage)),
          (reports) => emit(LoadedState(reports: reports)));
    } catch (e) {
      emit(ErrorState(errorMessage: 'Error fetching users: $e'));
    }
  }

  FutureOr<void> _onAddUserEvent(
      AddReportEvent event, Emitter<ReportState> emit) async {
    try {
      emit(LoadingState());
      final response = await _reportRepository.addReport(event.report);
      response.fold(
          (errorMessage) => emit(ErrorState(errorMessage: errorMessage)),
          (user) => emit(ReportAddedState()));
      add(FetchReportsEvent());
    } catch (e) {
      emit(ErrorState(errorMessage: 'Error adding user: $e'));
    }
  }

  FutureOr<void> _onDeleteUserEvent(
      DeleteReportEvent event, Emitter<ReportState> emit) async {
    try {
      emit(LoadingState());
      final response = await _reportRepository.deleteReport(event.reportId);
      response.fold(
          (errorMessage) => emit(ErrorState(errorMessage: errorMessage)),
          (user) => emit(ReportDeletedState()));
      add(FetchReportsEvent());
    } catch (e) {
      emit(ErrorState(errorMessage: 'Error delteing user: $e'));
    }
  }
}
