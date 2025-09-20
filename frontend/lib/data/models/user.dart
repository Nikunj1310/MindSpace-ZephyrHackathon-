class User {
  final String id;
  final String userName;
  final String fullName;
  final String email;
  final DateTime joinedAt;
  final DateTime lastSeen;
  final int streakCount;
  final int currentMood;
  final String emoji;
  final String role;

  const User({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.joinedAt,
    required this.lastSeen,
    required this.streakCount,
    required this.currentMood,
    required this.emoji,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      userName: json['userName'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      joinedAt: DateTime.tryParse(json['joinedAt'] ?? '') ?? DateTime.now(),
      lastSeen: DateTime.tryParse(json['lastSeen'] ?? '') ?? DateTime.now(),
      streakCount: json['streakCount'] ?? 0,
      currentMood: json['currentMood'] ?? 5,
      emoji: json['emoji'] ?? "😐",
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'joinedAt': joinedAt.toIso8601String(),
      'lastSeen': lastSeen.toIso8601String(),
      'streakCount': streakCount,
      'currentMood': currentMood,
      'emoji': emoji,
      'role': role,
    };
  }

  User copyWith({
    String? id,
    String? userName,
    String? fullName,
    String? email,
    DateTime? joinedAt,
    DateTime? lastSeen,
    int? streakCount,
    int? currentMood,
    String? emoji,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      joinedAt: joinedAt ?? this.joinedAt,
      lastSeen: lastSeen ?? this.lastSeen,
      streakCount: streakCount ?? this.streakCount,
      currentMood: currentMood ?? this.currentMood,
      emoji: emoji ?? this.emoji,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, userName: $userName, fullName: $fullName, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.userName == userName &&
        other.fullName == fullName &&
        other.email == email &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        role.hashCode;
  }

  bool get isAdmin => role == 'admin';
  bool get isMentor => role == 'mentor';
  bool get isUser => role == 'user';
}
