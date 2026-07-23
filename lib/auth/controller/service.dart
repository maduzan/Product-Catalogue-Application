import 'dart:async';
import 'dart:convert';

import 'package:Product_Catalogue_Application/auth/controller/controller.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../utils/utils.dart';
import '../model/model.dart';

class AuthService extends AuthRepository {
  AuthService() : super();

  final StreamController<AuthState> _authStateSubject =
      StreamController<AuthState>.broadcast();
  final Box<String> _storage = Hive.box<String>(GetIt.instance<AppSettings>()
      .sessionSecretKey); // Need to open first before using, see bootstrap.dart

  Stream<AuthState> get onAuthStateChanges => _authStateSubject.stream;

  /// Logs in the user with the provided [email] and [password].
  ///
  /// This method sets the authentication state to [AuthLoading] and then attempts to log in the user using the provided credentials.
  /// It retrieves the device platform and device ID from the [AppSettings] instance using [GetIt] and creates a [LogInRequestModel] with the email, password, device ID, and device platform.
  /// The method then calls the [logIn] function to send the login request and awaits the response.
  /// If the login is successful, the session is saved using [_saveSession] and the authentication state is set to [AuthSuccess] with the session response.
  /// If an error occurs during the login process, the authentication state is set to [AuthFailed] with the error message.
  ///
  /// Throws an exception if any error occurs during the login process.
  Future<void> login(String email, String password) async {
    _authStateSubject.add(AuthLoading());
    try {
      final request = LogInRequestModel(
        email: email,
        password: password,
      );

      final profile = await logIn(request);
      final newSession = Session.fromJson(profile.toJson());

      /// Save the session to the local storage
      await _saveSession(newSession);

      /// Emit the success state with the new session
      _authStateSubject.add(AuthSuccess(session: newSession));
    } catch (e) {
      _authStateSubject.add(AuthFailed(e.toString()));
    }
  }

  Future<void> _saveSession(Session session) async {
    await _storage.put('session', jsonEncode(session.toJson()));
  }
}
