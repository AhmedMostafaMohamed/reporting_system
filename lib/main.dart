import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reporting_system/data/models/report.dart';
import 'package:reporting_system/data/repos/authentication/offline_authentication_repository.dart';
import 'package:reporting_system/data/repos/report/offline_report_repository.dart';
import 'package:reporting_system/domain/blocs/report/report_bloc.dart';
import 'package:reporting_system/modules/home/home.dart';
import 'package:reporting_system/modules/report%20screen/report_screen.dart';
import 'domain/blocs/auth/auth_bloc.dart';
import 'modules/auth/auth_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String jsonString = await getConfigForFirebase();
  Map configMap = json.decode(jsonString);
  Map dataProjectConfig = configMap['data_firebase_config'];
  Map authProjectConfig = configMap['auth_firebase_config'];
  await Firebase.initializeApp(
    name: 'data',
    options: FirebaseOptions(
        apiKey: dataProjectConfig['apiKey'],
        authDomain: dataProjectConfig['authDomain'],
        projectId: dataProjectConfig['projectId'],
        storageBucket: dataProjectConfig['storageBucket'],
        messagingSenderId: dataProjectConfig['messagingSenderId'],
        appId: dataProjectConfig['appId']),
  );
  await Firebase.initializeApp(
    name: 'auth',
    options: FirebaseOptions(
        apiKey: authProjectConfig['apiKey'],
        authDomain: authProjectConfig['authDomain'],
        projectId: authProjectConfig['projectId'],
        storageBucket: authProjectConfig['storageBucket'],
        messagingSenderId: authProjectConfig['messagingSenderId'],
        appId: authProjectConfig['appId']),
  );
  final String? token = await const FlutterSecureStorage().read(key: 'token');
  runApp( MyApp(token: token,));
}

Future<String> getConfigForFirebase() async =>
   await rootBundle.loadString('assets/config/firebase_config.json');

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key,this.token});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ReportBloc(
              reportRepository: OfflineReportRepository()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: OfflineAuthRepository(secureStorage: const FlutterSecureStorage()),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Reporting app',
        initialRoute: buildInitialRoute(token),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/auth':
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
      String buildInitialRoute(String? token) => token == null
      ? '/auth'
      : !JwtDecoder.isExpired(token)
          ? '/home'
          : '/auth';
}
