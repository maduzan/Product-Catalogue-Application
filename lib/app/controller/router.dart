import 'package:Product_Catalogue_Application/app/controller/states.dart';
import 'package:Product_Catalogue_Application/app/view/view.dart';
import 'package:Product_Catalogue_Application/utils/pages.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

enum RouterAuthState {
  notInitialized,
  notLoggedIn,
  authenticated,
}

class AppRouter {
  AppRouter();

  final AppStates _appStates = GetIt.instance<AppStates>();

  GoRouter get goRouter => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    refreshListenable: _appStates,
    initialLocation:
        '${_appStates.homePrefix}/${Pages.home.toPath(isSubRoute: true)}',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Pages.splash.toPath(),
        name: Pages.splash.toPathName(),
        pageBuilder: (context, state) =>
            const MaterialPage(child: SplashPage()),
      ),
    ],
    redirect: (context, state) {
      // Determine current auth state
      final currentState = _determineAuthState();

      // Define routing rules map
      final routingRules = {
        RouterAuthState.notInitialized: Pages.splash,
        RouterAuthState.notLoggedIn: Pages.intro,
        RouterAuthState.authenticated: Pages.home,
      };

      // Get target page for current auth state
      final targetPage = routingRules[currentState] ?? Pages.splash;

      // For authenticated state, only check if path starts with homePrefix
      // For other states, ensure exact path match
      if (currentState == RouterAuthState.authenticated) {
        if (!state.matchedLocation.startsWith(_appStates.homePrefix)) {
          final targetPath = state.namedLocation(targetPage.toPathName());
          return targetPath;
        }
      } else {
        final targetPath = state.namedLocation(targetPage.toPathName());
        if (!state.matchedLocation.startsWith(targetPath)) {
          return targetPath;
        }
      }

      return null;
    },
  );

  // Helper method to determine current auth state
  RouterAuthState _determineAuthState() {
    if (!_appStates.isInitialized) return RouterAuthState.notInitialized;
    if (!_appStates.isLogin) return RouterAuthState.notLoggedIn;
    return RouterAuthState.authenticated;
  }
}
