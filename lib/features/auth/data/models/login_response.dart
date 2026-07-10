import 'package:ligo_challenge/features/auth/data/models/user_model.dart';

class LoginResponse {
  const LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  final String token;
  final UserModel user;

  Map<String, dynamic> toJson() => {
    'token': token,
    'user': user.toJson(),
  };
}
