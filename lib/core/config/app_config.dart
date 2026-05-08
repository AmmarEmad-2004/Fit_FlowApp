enum AppEnvironment { development, staging, production }

class AppConfig {
  final AppEnvironment environment;

  const AppConfig({required this.environment});
}
