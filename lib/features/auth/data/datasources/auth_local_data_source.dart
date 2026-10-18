import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;

  AuthLocalDataSourceImpl(this._storageService);

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      if (user.token != null) {
        await _storageService.saveToken(user.token!);
      }
      final jsonString = jsonEncode(user.toJson());
      await _storageService.saveUserData(jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = _storageService.getUserData();
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> map = jsonDecode(jsonString) as Map<String, dynamic>;
        return UserModel.fromJson(map);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to load cached user: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storageService.clearSession();
    } catch (e) {
      throw CacheException(message: 'Failed to clear auth cache: $e');
    }
  }
}
