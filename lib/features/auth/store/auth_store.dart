import 'package:mobx/mobx.dart';
import 'package:flutter_ecommerce/features/auth/data/auth_repository.dart';
import 'package:flutter_ecommerce/features/auth/models/user.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthRepository _authRepository;

  _AuthStore(this._authRepository) {
    _init();
  }

  @observable
  User? currentUser;

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @computed
  bool get isAuthenticated => currentUser != null;

  @action
  Future<void> _init() async {
    currentUser = await _authRepository.getCurrentUser();
  }

  @action
  Future<void> signUpWithEmail(String email, String password) async {
    isLoading = true;
    error = null;
    try {
      currentUser = await _authRepository.signUpWithEmail(email, password);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> signInWithEmail(String email, String password) async {
    isLoading = true;
    error = null;
    try {
      currentUser = await _authRepository.signInWithEmail(email, password);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> signInWithGoogle() async {
    isLoading = true;
    error = null;
    try {
      currentUser = await _authRepository.signInWithGoogle();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> sendOtp(String phoneNumber) async {
    isLoading = true;
    error = null;
    try {
      await _authRepository.sendOtp(phoneNumber);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    isLoading = true;
    error = null;
    try {
      currentUser = await _authRepository.verifyOtp(phoneNumber, otp);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> sendEmailVerification() async {
    isLoading = true;
    error = null;
    try {
      await _authRepository.sendEmailVerification();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> verifyEmail(String token) async {
    isLoading = true;
    error = null;
    try {
      await _authRepository.verifyEmail(token);
      currentUser = await _authRepository.getCurrentUser();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> resetPassword(String email) async {
    isLoading = true;
    error = null;
    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    error = null;
    try {
      await _authRepository.logout();
      currentUser = null;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}