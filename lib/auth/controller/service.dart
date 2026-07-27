import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Product_Catalogue_Application/auth/controller/controller.dart';
import 'package:dio/dio.dart';
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

  Future<void> login(String email, String password) async {
    _authStateSubject.add(AuthLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final newSession = Session(
        userId: '1',
        accessToken:
            'dummy_access_token_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        isEmailVerified: true,
        isProfileCompleted: true,
      );

      /// Save the session to local storage
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

  Future<Session?> _getSession() async {
    final session = _storage.get('session');
    if (session == null) {
      return null;
    }
    return Session.fromJson(jsonDecode(session) as Map<String, dynamic>);
  }

  Future<void> _deleteSession() async {
    await _storage.delete('session');
  }

  Future<Session> getCurrentUser({required String token}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return Session(
      userId: '1',
      accessToken: token.isNotEmpty ? token : 'dummy_access_token',
      createdAt: DateTime.now(),
      isEmailVerified: true,
      isProfileCompleted: true,
    );
  }

  Future<void> refreshSession() async {
    var session = await _getSession();
    if (session != null) {
      try {
        final response = await getCurrentUser(token: session.accessToken);
        session = session
            .syncPreserveAccessToken(Session.fromJson(response.toJson()));
        _authStateSubject.add(AuthSuccess(session: session));

        /// We need to save the session again to trigger the session change listener in the [App] in app.dart
        await _saveSession(session);
      } catch (_) {
        /// If an error occurs while syncing the user session, we log out the user
        log('Error syncing user session', name: 'AuthService');
        await _deleteSession();
        _authStateSubject.add(AuthInitial());
      }
    } else {
      _authStateSubject.add(AuthInitial());
    }
  }

  Future<void> logout() async {
    _authStateSubject.add(AuthLoading());

    final session = await _getSession();
    if (session != null) {
      await logOut(token: session.accessToken);
    }
    await _deleteSession();

    _authStateSubject.add(AuthLogout());
  }

  Future<void> logOut({required String token}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}
