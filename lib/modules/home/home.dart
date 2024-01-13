import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reporting_system/domain/blocs/report/report_bloc.dart';

import '../../domain/blocs/auth/auth_bloc.dart';
import 'components/add_report_bottomsheet.dart';
import 'components/reports_list.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Reporting system'),
        actions: [
          IconButton(
              tooltip: 'Refresh',
              onPressed: () {
                BlocProvider.of<ReportBloc>(context).add(FetchReportsEvent());
              },
              icon: const Icon(Icons.refresh)),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                Navigator.of(context).pushReplacementNamed('/auth');
              }
            },
            child: IconButton(
                tooltip: 'SignOut',
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                },
                icon: const Icon(Icons.power_settings_new_outlined)),
          ),
        ],
      ),
      body: BlocConsumer<ReportBloc, ReportState>(
        bloc: BlocProvider.of(context)..add(FetchReportsEvent()),
        listener: (context, state) {
          if (state is ReportAddedState) {
            debugPrint('report added!!');
            var snackBar2 = const SnackBar(
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              content: Text('Report is added successfully!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar2);
            Navigator.of(context).pop();
          } else if (state is ReportDeletedState) {
            debugPrint('report deleted!!');
            var snackBar2 = const SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
              content: Text('Report is deleted successfully!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar2);
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorState) {
            return Center(
              child: Text('error message: ${state.errorMessage}'),
            );
          } else if (state is LoadedState) {
            return ReportsList(reports: state.reports);
          } else {
            return const Center(
              child: Text('unknown state'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return AddReportBottomSheet(
                formKey: _formKey,
              );
            },
          );
        },
        tooltip: 'Add Report',
        child: const Icon(Icons.add),
      ),
    );
  }
}
