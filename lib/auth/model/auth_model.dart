import 'package:dio/dio.dart';

class LogInRequestModel {
  LogInRequestModel({
    required this.email,
    required this.password,
  });
  String email;
  String password;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  FormData toFormData() {
    return FormData.fromMap(
        toJson()..removeWhere((key, value) => value == null));
  }

  @override
  String toString() {
    return 'LogInRequestModel(email: $email, password: $password)';
  }
}
