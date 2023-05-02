import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/services/key_value_storage_service_impl.dart';

import '../infrastructure/errors/auth_errores.dart';
import '../infrastructure/repositories/auth_repository_impl.dart';
import '../infrastructure/services/key_value_storage_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();
  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(
      Duration(microseconds: 500),
    );
    /* state = state.copyWith(); */
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout(errorMessage: 'Credenciales incorrectas');
    } on CustomError catch (e) {
      logout(errorMessage: 'Credenciales incorrectas');
    } catch (e) {
      logout(errorMessage: 'Error no contrado');
    }
  }

  void registeruser(String email, String password) async {}
  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) {
      return logout();
    }
    try {
      final user = await authRepository.checkAtuhStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  Future<void> logout({String? errorMessage}) async {
    //TODO Clean the token
    await keyValueStorageService.removeKey('token');
    state = state.copyWith(
      user: null,
      errorMessage: errorMessage,
      authStatus: AuthStatus.notAuthenticated,
    );
  }

  void _setLoggedUser(User user) async {
    //TODO Save the token
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      errorMessage: '',
      authStatus: AuthStatus.authenticated,
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });
  AuthState copyWith(
          {AuthStatus? authStatus, User? user, String? errorMessage}) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
