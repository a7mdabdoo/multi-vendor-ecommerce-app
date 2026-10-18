import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final user = await _remoteDataSource.login(username, password);
      await _localDataSource.cacheUser(user);
      return user;
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<UserEntity> register(String fullName, String email, String password) async {
    try {
      final user = await _remoteDataSource.register(fullName, email, password);
      await _localDataSource.cacheUser(user);
      return user;
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await _localDataSource.getCachedUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _localDataSource.clearCache();
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }
}
