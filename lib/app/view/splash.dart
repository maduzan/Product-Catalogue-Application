import 'dart:async';

import 'package:Product_Catalogue_Application/app/controller/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';

import '../../auth/controller/controller.dart';
import '../widgets/widgets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  Future<void> init() async {
    FlutterNativeSplash.remove();
    // Simulate initial loading (e.g., config, database)
    await Future.delayed(const Duration(seconds: 1), () {});
    await GetIt.instance<AuthService>().refreshSession();

    if (mounted) {
      GetIt.instance<AppStates>().isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: AppLogo(imageWidth: 197, imageHeight: 200),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
