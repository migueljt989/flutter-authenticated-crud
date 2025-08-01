

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';


//CREAR NUESTRO PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier,AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});



//IMPLEMENTAMOS UN NOTIFIER 
class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}): super( AuthState() );
  
  Future<void> loginUser ( String email, String password ) async {

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout('Credenciales no son correctas');
    } on ConnectionTimeout {
      logout('Timeout');
    } catch (e) {
      logout('Error no controlado');
    }

  }

  void registerUser ( String email, String password ) async {

  }

  void checkAuthStatus () async {

  }

  void _setLoggedUser ( User user) {
    //TODO: NECESITO GUARDAR EL TOKEN EN EL DISPOSITIVO FISICAMENTE
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout ( [String? errorMessage] ) async {
    //TODO: LIMPIAR TOKEN
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