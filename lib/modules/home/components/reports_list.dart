import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/report.dart';
import '../../../domain/blocs/report/report_bloc.dart';
import '../../../shared/components/confirm_dialog.dart';

class ReportsList extends StatefulWidget {
  final List<Report> reports;

  const ReportsList({super.key, required this.reports});

  @override
  _ReportsListState createState() => _ReportsListState();
}

class _ReportsListState extends State<ReportsList> {
  final TextEditingController _searchController = TextEditingController();
  List<Report> _filteredReports = [];

  @override
  void initState() {
    super.initState();
    _filteredReports = widget.reports;
  }

  void _filterReports(String query) {
    setState(() {
      _filteredReports = widget.reports
          .where((report) =>
              report.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: _filterReports,
            decoration: const InputDecoration(
              labelText: 'Search by Report Name',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredReports.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.description), // Customize this icon
                ),
                trailing: IconButton(
                  onPressed: () =>
                      _showConfirmationDialog(context, _filteredReports[index]),
                  icon: const Icon(Icons.delete),
                ),
                title: Text(_filteredReports[index].name),
                // Or any other relevant information
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/report-details',
                    arguments: _filteredReports[
                        index], // Pass the selected report as an argument
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message:
              'Are you sure you want to delete this item? This action cannot be undone.',
          onConfirm: () {
            // Confirm button pressed
            // Perform actions here
            BlocProvider.of<ReportBloc>(context)
                .add(DeleteReportEvent(reportId: report.id));
            // Close the dialog
          },
          onCancel: () {
            // Cancel button pressed
            Navigator.pop(context); // Close the dialog
          },
        );
      },
    );
  }
}
