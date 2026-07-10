class LoginRequest {
  const LoginRequest({required this.user, required this.password});

  final String user;
  final String password;

  Map<String, dynamic> toJson() => {
    'user': user,
    'password': password,
  };
}
