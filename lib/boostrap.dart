import 'dart:async';
import 'dart:developer';
import 'package:Product_Catalogue_Application/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Returns the instance of the GetIt service locator.
///
/// The GetIt service locator is a singleton class that provides a convenient way to access
/// and manage dependencies in your application. This getter method returns the instance
/// of the GetIt service locator.
GetIt get getIt => GetIt.instance;

/// Boots up the application by initializing necessary components and running the provided builder function.
///
/// The [builder] function is responsible for creating the root widget of the application.
/// The [environment] parameter specifies the environment in which the application is running.
/// This function sets up error handling, initializes Flutter bindings, and registers singletons for various services.
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
///
/// The [environment] parameter specifies the application environment.
/// It registers the Classes as singletons using the GetIt service locator.
Future<void> setup({required AppEnvironment environment}) async {}

/// Initializes Hive database for Flutter.
/// This function must be called before using any Hive functionality.
/// Returns a Future that completes when the initialization is done.
Future<void> hiveInit() async {
  await Hive.initFlutter();
}
