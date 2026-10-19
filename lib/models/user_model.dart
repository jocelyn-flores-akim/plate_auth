enum UserRole {
  admin('admin'),
  agent('agent'),
  doctor('doctor'),
  nurse('nurse');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.agent,
    );
  }
}

class User {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? serviceId;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.serviceId,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'agent'),
      serviceId: json['service_id'],
      createdAt: DateTime.parse(json['created_at']),
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'full_name': fullName,
    'role': role.value,
    'service_id': serviceId,
    'created_at': createdAt.toIso8601String(),
    'last_login': lastLogin?.toIso8601String(),
    'is_active': isActive,
  };

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    UserRole? role,
    String? serviceId,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      serviceId: serviceId ?? this.serviceId,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }
}
