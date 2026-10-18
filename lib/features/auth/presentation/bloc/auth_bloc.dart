import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<RegisterSubmittedEvent>(_onRegisterSubmitted);
    on<LoginAsDemoEvent>(_onLoginAsDemo);
    on<LogoutRequestedEvent>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        emit(AuthenticatedState(user));
      } else {
        emit(const UnauthenticatedState());
      }
    } catch (_) {
      emit(const UnauthenticatedState());
    }
  }

  Future<void> _onLoginSubmitted(LoginSubmittedEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    try {
      final user = await _loginUseCase(event.username, event.password);
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRegisterSubmitted(RegisterSubmittedEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    try {
      final user = await _registerUseCase(event.fullName, event.email, event.password);
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoginAsDemo(LoginAsDemoEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    try {
      final user = await _loginUseCase(AppConstants.demoUsername, AppConstants.demoPassword);
      emit(AuthenticatedState(user));
    } catch (_) {
      // Fallback directly
      emit(const AuthenticatedState(
        UserModel(
          id: 1,
          username: AppConstants.demoUsername,
          email: AppConstants.demoEmail,
          firstName: 'Emily',
          lastName: 'Johnson',
          gender: 'female',
          image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
          token: 'demo_token_portfolio',
        ),
      ));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequestedEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    try {
      await _logoutUseCase();
    } catch (_) {}
    emit(const UnauthenticatedState());
  }
}
