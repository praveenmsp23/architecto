enum Environment { local, development, production }

class Config {
  static late final String appName;
  static late final String baseUrl;

  static final int timeout = 30;
  static final String storageKeyToken = "access_token";

  static const Map<String, Environment> _environmentMap = {
    'development': Environment.development,
    'production': Environment.production,
  };

  static const String _env =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'local');
  static final Environment environment =
      _environmentMap[_env] ?? Environment.local;

  static void initialize() {
    switch (environment) {
      case Environment.local:
        appName = "Architecto";
        baseUrl = 'http://localhost:8080';
        break;
      case Environment.development:
        appName = "Architecto";
        baseUrl = 'https://api-dev.architecto.praveenmsp.com';
        break;
      case Environment.production:
        appName = "Architecto";
        baseUrl = 'https://api.architecto.praveenmsp.com';
        break;
      }
  }
}
