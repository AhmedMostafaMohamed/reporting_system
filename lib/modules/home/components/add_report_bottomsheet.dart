import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/report.dart';
import '../../../domain/blocs/report/report_bloc.dart';

class AddReportBottomSheet extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  AddReportBottomSheet({super.key, required this.formKey});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey, // Set the form key
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a report name';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Report Name'),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _urlController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a report URL';
                }
                if (!value.startsWith(
                    'https://lookerstudio.google.com/embed/reporting/')) {
                  return 'URL must start with "https://lookerstudio.google.com/embed/reporting/"';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Report URL'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // If the form is valid, add the report
                  final report = Report(
                    name: _nameController.text,
                    reportUrl: _urlController.text,
                  );
                  BlocProvider.of<ReportBloc>(context).add(
                    AddReportEvent(report: report),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
