import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/datasources/auth_local_data_source.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthLocalDataSource localDataSource;

  AuthBloc({required this.localDataSource}) : super(AuthInitial()) {
    on<LoginRequestedEvent>(_onLoginRequested);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  void _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  void _onLoginRequested(LoginRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1)); 

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(event.email)) {
      emit(const AuthError('Invalid email format'));
      return;
    }

    if (event.password.length <= 6) {
      emit(const AuthError('Password must be > 6 characters'));
      return;
    }

  
    try {
      await localDataSource.saveToken('dummy_token_123');
      emit(Authenticated());
    } catch (e) {
      emit(AuthError('Failed to save token: $e'));
    }
  }
}
