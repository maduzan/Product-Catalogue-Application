import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../auth/model/model.dart';
import '../../products/products.dart';
import '../../utils/utils.dart';
import '../controller/controller.dart';
import '../controller/router.dart';
import '../controller/states.dart';

class ProductCatalogueApp extends StatefulWidget {
  const ProductCatalogueApp({super.key});

  @override
  State<ProductCatalogueApp> createState() => _ProductCatalogueAppState();
}

class _ProductCatalogueAppState extends State<ProductCatalogueApp> {
  late StreamSubscription<BoxEvent> _authStateSubscription;

  final AppStates _appStates = GetIt.instance<AppStates>();
  final ThemeServiceProvider _themeServiceProvider =
      GetIt.instance<ThemeServiceProvider>();

  @override
  void initState() {
    /// The [onAuthStateChanged] callback function will be called whenever there is a change in the authentication state.
    _authStateSubscription =
        Hive.box<String>(GetIt.instance<AppSettings>().sessionSecretKey)
            .watch()
            .listen(onAuthStateChanged);

    /// Listens to changes in the theme mode provided by the [_themeServiceProvider].
    /// If the theme mode is set to [ThemeMode.dark], it sets the system UI overlay style to dark.
    /// Otherwise, it sets the system UI overlay style to the default.
    _themeServiceProvider.addListener(() {
      if (_themeServiceProvider.themeMode == ThemeMode.dark) {
        ThemeServiceProvider.setSystemUIOverlayStyle(isDark: true);
      } else {
        ThemeServiceProvider.setSystemUIOverlayStyle();
      }
    });
    super.initState();
  }

  /// **Note**: In the future, we'll also use this function to clear saved user cache related data from other services.
  void onAuthStateChanged(BoxEvent event) {
    log('onAuthStateChanged: ${event.value}', name: 'quicky_cafeAppState');
    if (event.value != null && event.value is String) {
      _appStates.currentSession = Session.fromJson(
        jsonDecode(event.value as String) as Map<String, dynamic>,
      );
    } else {
      _appStates
        ..currentSession = null
        ..isInitialized =
            false; // Reset the app state to initial state when the user logs out
    }
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => GetIt.instance<AppSettings>()),
        ChangeNotifierProvider(
            create: (_) => GetIt.instance<ThemeServiceProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<AppStates>()),
        ChangeNotifierProvider(
            create: (_) => GetIt.instance<ProductController>()),
      ],
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              onGenerateTitle: (context) => 'Product Catalogue',
              theme: context.watch<ThemeServiceProvider>().lightTheme,
              darkTheme: context.watch<ThemeServiceProvider>().darkTheme,
              themeMode: context.watch<ThemeServiceProvider>().themeMode,
              routerConfig: GetIt.instance<AppRouter>().goRouter,
              builder: (context, child) => child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
