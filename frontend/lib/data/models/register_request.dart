class RegisterRequest {
  final String userName;
  final String fullName;
  final String email;
  final String password;
  final int? currentMood;
  final String? emoji;
  final String? role;

  const RegisterRequest({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.password,
    this.currentMood = 5,
    this.emoji = "😐",
    this.role = 'user',
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'password': password,
      if (currentMood != null) 'currentMood': currentMood,
      if (emoji != null) 'emoji': emoji,
      if (role != null) 'role': role,
    };
  }

  @override
  String toString() =>
      'RegisterRequest(userName: $userName, email: $email, role: $role)';
}
