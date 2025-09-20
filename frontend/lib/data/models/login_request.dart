class LoginRequest {
  final String userName;
  final String password;

  const LoginRequest({required this.userName, required this.password});

  Map<String, dynamic> toJson() {
    return {'userName': userName, 'password': password};
  }

  @override
  String toString() => 'LoginRequest(userName: $userName)';
}
