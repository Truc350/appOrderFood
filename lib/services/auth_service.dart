import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserModel.dart';
export '../models/UserModel.dart';
class AuthResult {
  final bool success;
  final String? error;
  final UserModel? user;

  const AuthResult({required this.success, this.error, this.user});
}

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  static const _keyUsers = 'nf_users';
  static const _keyCurrentUser = 'nf_current_user';
  static const _keyIsLoggedIn = 'nf_is_logged_in';

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Khởi động app - kiểm tra session đã lưu
  Future<bool> init() async {
    final prefs = await SharedPreferences.getInstance();

    // In toàn bộ SharedPreferences
    print('=== SharedPreferences Data ===');
    for (var key in prefs.getKeys()) {
      print('$key: ${prefs.get(key)}');
    }

    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return false;

    final userJson = prefs.getString(_keyCurrentUser);
    if (userJson == null) return false;

    try {
      _currentUser = UserModel.fromJson(jsonDecode(userJson));
      return true;
    } catch (_) {
      return false;
    }
  }

  // Lấy danh sách users: ưu tiên SharedPrefs, fallback về assets/users.json
  Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_keyUsers);

    if (saved != null) {
      final List<dynamic> list = jsonDecode(saved);
      return list.map((e) => UserModel.fromJson(e)).toList();
    }

    // Lần đầu: seed từ assets/users.json
    try {
      final raw = await rootBundle.loadString('assets/users.json');
      final List<dynamic> list = jsonDecode(raw);
      final users = list.map((e) => UserModel.fromJson(e)).toList();
      await _saveUsers(users);
      return users;
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _keyUsers, jsonEncode(users.map((u) => u.toJson()).toList()));
  }

  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyCurrentUser, jsonEncode(user.toJson()));
    _currentUser = user;
  }

  // ── ĐĂNG NHẬP ──────────────────────────────────────────────
  Future<AuthResult> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return const AuthResult(success: false, error: 'Vui lòng nhập đầy đủ thông tin');
    }
    if (!_isValidEmail(email)) {
      return const AuthResult(success: false, error: 'Email không đúng định dạng');
    }

    final users = await _getUsers();
    final match = users.where(
          (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
    );

    if (match.isEmpty) {
      return const AuthResult(success: false, error: 'Email hoặc mật khẩu không đúng');
    }

    await _saveSession(match.first);
    return AuthResult(success: true, user: match.first);
  }

  // ── ĐĂNG KÝ ────────────────────────────────────────────────
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    // Validate
    if (name.trim().isEmpty) {
      return const AuthResult(success: false, error: 'Vui lòng nhập họ và tên');
    }
    if (name.trim().length < 2) {
      return const AuthResult(success: false, error: 'Tên phải có ít nhất 2 ký tự');
    }
    if (!_isValidEmail(email)) {
      return const AuthResult(success: false, error: 'Email không đúng định dạng');
    }
    final passError = _validatePassword(password);
    if (passError != null) return AuthResult(success: false, error: passError);

    final users = await _getUsers();

    // Kiểm tra email trùng
    final exists = users.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (exists) {
      return const AuthResult(success: false, error: 'Email này đã được đăng ký');
    }

    // Tạo user mới
    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      phone: phone?.trim().isEmpty == true ? null : phone?.trim(),
      createdAt: DateTime.now(),
    );

    users.add(newUser);
    await _saveUsers(users);
    await _saveSession(newUser);

    return AuthResult(success: true, user: newUser);
  }

  // ── ĐĂNG XUẤT ──────────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyCurrentUser);
    _currentUser = null;
  }

  // ── CẬP NHẬT THÔNG TIN ─────────────────────────────────────
  Future<AuthResult> updateProfile({String? name, String? phone}) async {
    if (_currentUser == null) {
      return const AuthResult(success: false, error: 'Chưa đăng nhập');
    }
    final updated = _currentUser!.copyWith(name: name, phone: phone);
    final users = await _getUsers();
    final idx = users.indexWhere((u) => u.id == updated.id);
    if (idx != -1) {
      users[idx] = updated;
      await _saveUsers(users);
    }
    await _saveSession(updated);
    return AuthResult(success: true, user: updated);
  }

  // ── HELPERS ────────────────────────────────────────────────
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email.trim());
  }

  String? _validatePassword(String password) {
    if (password.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
    return null;
  }

  // Validate riêng lẻ từng field (dùng cho realtime validation trong UI)
  String? validateName(String value) {
    if (value.trim().isEmpty) return 'Vui lòng nhập họ và tên';
    if (value.trim().length < 2) return 'Tên phải có ít nhất 2 ký tự';
    return null;
  }

  String? validateEmail(String value) {
    if (value.trim().isEmpty) return 'Vui lòng nhập email';
    if (!_isValidEmail(value)) return 'Email không đúng định dạng';
    return null;
  }

  String? validatePassword(String value) => _validatePassword(value);

  String? validateConfirmPassword(String password, String confirm) {
    if (confirm.isEmpty) return 'Vui lòng nhập lại mật khẩu';
    if (password != confirm) return 'Mật khẩu không khớp';
    return null;
  }
}
