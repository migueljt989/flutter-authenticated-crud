

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';


//CREAR NUESTRO PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier,AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
    );
});



//IMPLEMENTAMOS UN NOTIFIER 
class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository, 
    required this.keyValueStorageService
    }): super( AuthState() ) {
      checkAuthStatus();
    }
  
  Future<void> loginUser ( String email, String password ) async {

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e){
      logout('Error no controlado');
    }

  }

  Future<void> registerUser ( String email, String password, String fullName ) async {

  }

  void checkAuthStatus () async {
    final token = await keyValueStorageService.getValue<String>('token');

    if ( token == null ) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }

  }

  void _setLoggedUser ( User user) async {
    //GUARDAR EL TOKEN EN EL DISPOSITIVO FISICAMENTE
    await keyValueStorageService.setKeyValue('token', user.token );

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout ( [String? errorMessage] ) async {
    //LIMPIAR TOKEN
    await keyValueStorageService.removeKey('token');

    state= state.copyWith(
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage,
    );

  }
}

//STATE DE NUESTRO PROVIDER
enum AuthStatus { chechking, authenticated, notAuthenticated }

class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus=AuthStatus.chechking, 
    this.user, 
    this.errorMessage=''
    });
  
  AuthState copyWith({
    final AuthStatus? authStatus,
    final User? user,
    final String? errorMessage
    }) => AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage
  );
}