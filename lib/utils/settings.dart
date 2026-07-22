import 'dart:developer';

/// This file contains the [AppSettings] class, which represents the application settings.
/// The [AppSettings] class also includes methods to retrieve device information such as device ID and device name.
/// The [AppEnvironment] enum defines the possible environments: development, production, and staging.
/// The [AppSettingValue] class is a generic class that represents a setting value with different values for each environment.

class AppSettings {
  AppSettings(this._environment);

  final AppEnvironment _environment;

  bool get isDevelopment => _environment == AppEnvironment.development;
  bool get isProduction => _environment == AppEnvironment.production;
  bool get isStaging => _environment == AppEnvironment.staging;

  final _baseUrl = const AppSettingValue<String>(
    developmentValue: '',
    productionValue: '',
    stagingValue: '',
  );

  final _apiKey = const AppSettingValue<String>(
    developmentValue: '',
    productionValue: '',
    stagingValue: '',
  );

  final _sessionSecretKey = const AppSettingValue<String>(
    developmentValue: '',
    productionValue: '',
    stagingValue: '',
  );

  String get baseUrl {
    switch (_environment) {
      case AppEnvironment.development:
        return _baseUrl.developmentValue;
      case AppEnvironment.production:
        return _baseUrl.productionValue ?? _baseUrl.developmentValue;
      case AppEnvironment.staging:
        return _baseUrl.stagingValue ?? _baseUrl.developmentValue;
    }
  }

  String get apiKey {
    switch (_environment) {
      case AppEnvironment.development:
        return _apiKey.developmentValue;
      case AppEnvironment.production:
        return _apiKey.productionValue ?? _apiKey.developmentValue;
      case AppEnvironment.staging:
        return _apiKey.stagingValue ?? _apiKey.developmentValue;
    }
  }

  String get sessionSecretKey {
    switch (_environment) {
      case AppEnvironment.development:
        return _sessionSecretKey.developmentValue;
      case AppEnvironment.production:
        return _sessionSecretKey.productionValue ??
            _sessionSecretKey.developmentValue;
      case AppEnvironment.staging:
        return _sessionSecretKey.stagingValue ??
            _sessionSecretKey.developmentValue;
    }
  }
}

/// Enum representing different environments for the application.
///
/// The [AppEnvironment] enum defines three different environments:
/// - development: Used for local development and testing.
/// - production: Used for the live production environment.
/// - staging: Used for staging or pre-production environment.
enum AppEnvironment { development, production, staging }

/// A generic class representing the value of an application setting.
///
/// The [AppSettingValue] class is used to define the default value of a setting,
/// as well as optional values for different environments such as development,
/// production, and staging. The type parameter [T] represents the type of the value.
class AppSettingValue<T> {
  const AppSettingValue({
    required this.developmentValue,
    this.productionValue,
    this.stagingValue,
  });

  final T developmentValue;
  final T? productionValue;
  final T? stagingValue;
}
