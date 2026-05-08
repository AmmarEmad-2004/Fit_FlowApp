import 'package:fit_flow/core/config/app_config.dart';
import 'package:fit_flow/run_app.dart';

void main() {
  AppConfig appConfig = const AppConfig(environment: AppEnvironment.staging);
  runFitApp(
     appConfig
  );
}