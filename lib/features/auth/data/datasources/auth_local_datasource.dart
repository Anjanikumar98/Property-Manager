// lib/features/auth/data/datasources/auth_local_datasource.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? profileImage,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _currentUserKey = 'current_user';
  static const String _usersKey = 'users';
  static const String _isLoggedInKey = 'is_logged_in';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Get all users from storage
      final users = await _getAllUsers();

      // Hash the password for comparison
      final hashedPassword = _hashPassword(password);

      // Find user with matching email and password
      final user = users.firstWhere(
        (user) => user.email == email,
        orElse: () => throw CacheException('User not found'),
      );

      // Check password (in real app, compare hashed passwords)
      final storedUserData = _getUserStoredData(user.id);
      if (storedUserData == null ||
          storedUserData['password'] != hashedPassword) {
        throw CacheException('Invalid credentials');
      }

      if (!user.isActive) {
        throw CacheException('Account is deactivated');
      }

      // Save current user and login state
      await sharedPreferences.setString(_currentUserKey, user.toJsonString());
      await sharedPreferences.setBool(_isLoggedInKey, true);

      return user;
    } catch (e) {
      throw CacheException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      // Check if user already exists
      final existingUsers = await _getAllUsers();
      final userExists = existingUsers.any((user) => user.email == email);

      if (userExists) {
        throw CacheException('User with this email already exists');
      }

      // Create new user
      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      final newUser = UserModel(
        id: userId,
        name: name,
        email: email,
        role: role,
        createdAt: DateTime.now(),
        isActive: true,
      );

      // Store user data with hashed password
      final hashedPassword = _hashPassword(password);
      await _storeUserData(userId, {
        'password': hashedPassword,
        'user': newUser.toJson(),
      });

      // Add to users list
      existingUsers.add(newUser);
      await _saveAllUsers(existingUsers);

      // Set as current user
      await sharedPreferences.setString(
        _currentUserKey,
        newUser.toJsonString(),
      );
      await sharedPreferences.setBool(_isLoggedInKey, true);

      return newUser;
    } catch (e) {
      throw CacheException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await sharedPreferences.remove(_currentUserKey);
      await sharedPreferences.setBool(_isLoggedInKey, false);
    } catch (e) {
      throw CacheException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userJson = sharedPreferences.getString(_currentUserKey);
      if (userJson == null) return null;

      return UserModel.fromJsonString(userJson);
    } catch (e) {
      throw CacheException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return sharedPreferences.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? profileImage,
  }) async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null || currentUser.id != userId) {
        throw CacheException('User not found or unauthorized');
      }

      final updatedUser = currentUser.copyWith(
        name: name,
        profileImage: profileImage,
      );

      // Update in current user storage
      await sharedPreferences.setString(
        _currentUserKey,
        updatedUser.toJsonString(),
      );

      // Update in users list
      final users = await _getAllUsers();
      final userIndex = users.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveAllUsers(users);
      }

      // Update user data storage
      final userData = _getUserStoredData(userId);
      if (userData != null) {
        userData['user'] = updatedUser.toJson();
        await _storeUserData(userId, userData);
      }
    } catch (e) {
      throw CacheException('Profile update failed: ${e.toString()}');
    }
  }

  // Helper methods
  Future<List<UserModel>> _getAllUsers() async {
    try {
      final usersJson = sharedPreferences.getString(_usersKey);
      if (usersJson == null) return [];

      final List<dynamic> usersList = jsonDecode(usersJson);
      return usersList.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveAllUsers(List<UserModel> users) async {
    final usersJson = jsonEncode(users.map((user) => user.toJson()).toList());
    await sharedPreferences.setString(_usersKey, usersJson);
  }

  String _hashPassword(String password) {
    // Simple hashing for demo - use proper hashing in production
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _storeUserData(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    final key = 'user_data_$userId';
    final dataJson = jsonEncode(userData);
    await sharedPreferences.setString(key, dataJson);
  }

  Map<String, dynamic>? _getUserStoredData(String userId) {
    try {
      final key = 'user_data_$userId';
      final dataJson = sharedPreferences.getString(key);
      if (dataJson == null) return null;

      return jsonDecode(dataJson);
    } catch (e) {
      return null;
    }
  }
}

