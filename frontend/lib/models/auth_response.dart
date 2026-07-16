class AuthResponse {
  final String accessToken;
  final String tokenType;
  final int userId;
  final String name;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.name,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String? ?? '',
      tokenType: json['token_type'] as String? ?? 'bearer',
      userId: json['user_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}
