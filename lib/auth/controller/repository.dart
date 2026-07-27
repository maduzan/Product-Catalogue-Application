import 'package:dio/dio.dart';

import '../../utils/utils.dart';
import '../model/model.dart';

class AuthRepository extends ApiClient {
  AuthRepository() : super();

  /// Logs in a user with the provided [request] data.
  /// Throws an [Exception] if the login fails.
  Future<Session> logIn(LogInRequestModel request) async {
    try {
      final tempPayload = {
        'result': true,
        'message': 'User logged in successfully',
        'payload': {
          'id': '1',
          'access_token': 'token',
          'created_at': DateTime.now().toIso8601String(),
          'is_email_verified': false,
          'is_profile_completed': false,
        },
      };
      await Future.delayed(const Duration(seconds: 2), () {});
      final response = Response<dynamic>(
          requestOptions: RequestOptions(path: '/login'), data: tempPayload);
      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);

      // real API call goes here
      // final response = await post(AuthEndpoints.login, data: request.toFormData());
      // final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);

      if (apiResponse is ApiFailureResponse) {
        throw Exception(apiResponse.message);
      } else {
        return Session.fromJson(apiResponse.data as Map<String, dynamic>);
      }
    } on Exception catch (e) {
      return onError(e);
    }
  }
}
