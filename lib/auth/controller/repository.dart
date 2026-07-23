import '../../utils/utils.dart';
import '../model/model.dart';

class AuthRepository extends ApiClient {
  AuthRepository() : super();

  /// Logs in a user with the provided [request] data.
  /// Returns a [Future] that completes with a [UserProfileWithToken] object if the login is successful.
  /// Throws an [Exception] if the login fails.
  Future<Session> logIn(LogInRequestModel request) async {
    try {
      final formData = request.toFormData();
      final response = await post('/login', data: formData);

      final apiResponse =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);
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
