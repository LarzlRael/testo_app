import 'package:dio/dio.dart';
import 'package:teslo_shop/contants/enviroment.dart';
import 'package:teslo_shop/features/auth/domain/datasources/auth_datasources.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infrastructure/mappers/user_mapper.dart';

import '../errors/auth_errores.dart';

class AuthDatasourcesImp extends AuthDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.apiUrl,
      /* headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }, */
    ),
  );
  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto', 0);
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw WrongCredentials();
      }
      if (e.type == DioErrorType.connectionTimeout) {
        throw ConnectionTimeout();
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
