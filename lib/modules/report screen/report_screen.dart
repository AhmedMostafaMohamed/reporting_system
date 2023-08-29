import 'package:flutter/material.dart';

import '../../data/models/report.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class ReportScreen extends StatelessWidget {
  final Report report;

  const ReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final PlatformWebViewController _controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
        LoadRequestParams(
          uri: Uri.parse(report.reportUrl),
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text(report.name),
      ),
      body: PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(
          controller: _controller,
        ),
      ).build(context),
    );
  }
}
