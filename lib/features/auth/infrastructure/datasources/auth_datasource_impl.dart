
import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDatasource{
  
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiURL
  ));
  
  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password':password
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if ( e.response?.statusCode == 401 ) {
        if ( e.response?.data["message"] != null || e.response?.data["statusCode"] != null) throw CustomError(e.response!.data["message"], e.response!.data["statusCode"]);
      }
      if ( e.type == DioExceptionType.connectionTimeout ) {
        if ( e.response?.data["message"] != null || e.response?.data["statusCode"] != null) throw CustomError(e.response!.data["message"], e.response!.data["statusCode"]);
      }
      throw CustomError('Something wrong happend', 1);
    } catch (e) {
      throw CustomError('Something wrong happend', 1);
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}