/// This class represents a user session. It contains the user ID, access token, and creation date.
class Session {
  Session({
    required this.userId,
    required this.accessToken,
    required this.createdAt,
    this.isEmailVerified = false,
    this.isProfileCompleted = false,
  });

  /// Creates a [Session] object from a JSON map.
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      userId: (json['id'] ?? '') as String,
      accessToken: (json['access_token'] ?? '') as String,
      createdAt: DateTime.tryParse((json['created_at'] ?? '') as String) ??
          DateTime.now(),
      isEmailVerified: (json['is_email_verified'] ?? false) as bool,
      isProfileCompleted: (json['is_profile_completed'] ?? false) as bool,
    );
  }

  String userId;
  String accessToken;
  DateTime createdAt;
  bool isEmailVerified = false;
  bool isProfileCompleted = false;

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'access_token': accessToken,
      'created_at': createdAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
      'is_profile_completed': isProfileCompleted,
    };
  }

  @override
  String toString() {
    return 'Session(userId: $userId, accessToken: $accessToken, createdAt: $createdAt, isEmailVerified: $isEmailVerified, isProfileCompleted: $isProfileCompleted)';
  }

  Session syncPreserveAccessToken(Session session) {
    return Session(
      userId: session.userId,
      accessToken: accessToken,
      createdAt: session.createdAt,
      isEmailVerified: session.isEmailVerified,
      isProfileCompleted: session.isProfileCompleted,
    );
  }
}
