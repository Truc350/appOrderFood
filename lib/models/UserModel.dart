class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final email = json['email']?.toString() ?? '';

    // Nếu JSON không có id (users.json cũ) → tự tạo từ email, stable và unique
    final rawId = json['id']?.toString() ?? '';
    final id = rawId.isEmpty
        ? 'usr_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}'
        : rawId;

    // Nếu JSON không có createdAt → dùng DateTime.now()
    final createdAt =
        DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now();

    return UserModel(
      id: id,
      name: json['name']?.toString() ?? '',
      email: email,
      password: json['password']?.toString() ?? '',
      phone: json['phone']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'phone': phone,
    'avatarUrl': avatarUrl,
    'createdAt': createdAt.toIso8601String(),
  };

  UserModel copyWith({String? name, String? phone, String? avatarUrl}) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        password: password,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        createdAt: createdAt,
      );
}