import 'package:firebase_core/firebase_core.dart';
import 'package:fit_flow/core/config/app_config.dart';
import 'package:fit_flow/core/di/service_locator.dart';
import 'package:fit_flow/firebase_options.dart';
import 'package:fit_flow/fit_flow_app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void runFitApp(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  getIt.registerLazySingleton<AppConfig>(() => appConfig);
  await Hive.initFlutter();
  await setupGetIt();
  runApp(const FitFlowApp());
}
