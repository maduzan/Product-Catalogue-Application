import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../controller/controller.dart';
import '../controller/router.dart';
import '../controller/states.dart';

class StarterApp extends StatefulWidget {
  const StarterApp({super.key});

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  late StreamSubscription<BoxEvent> _authStateSubscription;

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
      ],
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp.router(
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
