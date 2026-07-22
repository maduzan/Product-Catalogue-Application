import 'package:flutter/foundation.dart';

import '../../auth/model/model.dart';

/// A class that represents the application states.
/// It provides getters and setters for various state variables.
class AppStates with ChangeNotifier {
  AppStates();
  final String homePrefix = '/shell';

  /// Represents the state of initialization.
  bool _isInitialized = false;

  /// Returns the current initialization state.
  bool get isInitialized => _isInitialized;

  /// Sets the initialization state.
  /// Notifies the listeners after setting the value.
  set isInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  Session? _currentSession;

  /// Returns true if the user is logged in, false otherwise.
  bool get isLogin => _currentSession != null;
  Session? get currentSession => _currentSession;

  set currentSession(Session? value) {
    _currentSession = value;
    notifyListeners();
  }
}
