import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reporting_system/data/models/report.dart';
import 'package:reporting_system/data/repos/report/report_repository.dart';
import 'package:reporting_system/domain/blocs/report/report_bloc.dart';
import 'package:reporting_system/modules/home/home.dart';
import 'package:reporting_system/modules/report%20screen/report_screen.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'data/repos/authentication/authentication_repository.dart';
import 'domain/blocs/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'modules/auth/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'data',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp(
    name: 'auth',
    options: const FirebaseOptions(
        apiKey: "AIzaSyCjuv-MXi7cPBjOAra9A5KCYkl7CZ5kfP0",
        authDomain: "user-management-da458.firebaseapp.com",
        projectId: "user-management-da458",
        storageBucket: "user-management-da458.appspot.com",
        messagingSenderId: "751277100021",
        appId: "1:751277100021:web:0bb371fef2fd677a8faebc"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ReportBloc(
              reportRepository: ReportRepository(
                  firebaseFirestore: FirebaseFirestore.instanceFor(
                      app: Firebase.app('data')))),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(
                googleSignIn: GoogleSignIn(),
                firebaseFirestore:
                    FirebaseFirestore.instanceFor(app: Firebase.app('auth'))),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Reporting app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => const AuthPage());
            case '/home':
              return MaterialPageRoute(builder: (context) => HomePage());
            case '/report-details':
              Report report = settings.arguments as Report;
              return MaterialPageRoute(
                  builder: (context) => ReportScreen(
                        report: report,
                      ));
          }
          return null;
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  )..loadRequest(
      LoadRequestParams(
        uri: Uri.parse(
            'https://lookerstudio.google.com/embed/reporting/3e8aff48-3fe5-4365-845a-ded392a34a71/page/0slZD'),
      ),
    );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(
          controller: _controller,
        ),
      ).build(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
