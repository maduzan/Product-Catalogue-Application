import 'dart:async';
import 'package:Product_Catalogue_Application/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/controller/controller.dart';
import 'app/controller/router.dart';
import 'app/controller/states.dart';
import 'auth/controller/controller.dart';
import 'products/controller/controller.dart';

/// Returns the instance of the GetIt service locator.

GetIt get getIt => GetIt.instance;

/// Boots up the application by initializing necessary components and running the provided builder function.
Future<void> bootstrap(FutureOr<Widget> Function() builder,
    {required AppEnvironment environment}) async {
  FlutterError.onError = (details) {
    debugPrintStack(
        stackTrace: details.stack,
        label: details.exceptionAsString(),
        maxFrames: 10);
  };
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await hiveInit();
  await setup(environment: environment);
  runApp(await builder());
}

/// Sets up the application by registering necessary dependencies and initializing services.
Future<void> setup({required AppEnvironment environment}) async {
  getIt
    ..registerSingleton<AppSettings>(AppSettings(environment))
    ..registerSingletonAsync<AppStates>(() async {
      await Hive.openBox<bool>('states');
      return AppStates();
    })
    ..registerSingletonAsync<AuthService>(() async {
      await Hive.openBox<String>(getIt<AppSettings>().sessionSecretKey);
      return AuthService();
    })
    ..registerSingletonWithDependencies(AppRouter.new, dependsOn: [AppStates])
    ..registerSingletonAsync<ProductsRepository>(() async {
      await Hive.openBox<String>(getIt<AppSettings>().sessionSecretKey);
      await Hive.openBox<bool>('favourites');
      return ProductsRepository();
    })
    ..registerSingletonWithDependencies<ProductController>(
        ProductController.new,
        dependsOn: [ProductsRepository])
    ..registerSingletonAsync<ThemeServiceProvider>(() async {
      await Hive.openBox<bool>('themeMode');
      final isDark = Hive.box<bool>('themeMode').get('isDark') ?? false;
      ThemeServiceProvider.setSystemUIOverlayStyle(isDark: isDark);
      return ThemeServiceProvider(isDark: isDark);
    });

  await getIt.allReady();
}

/// Initializes Hive database for Flutter.
/// This function must be called before using any Hive functionality.
/// Returns a Future that completes when the initialization is done.
Future<void> hiveInit() async {
  await Hive.initFlutter();
}
