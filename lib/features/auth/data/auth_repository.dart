import 'package:dio/dio.dart';
import 'package:flutter_ecommerce/core/api/api_client.dart';
import 'package:flutter_ecommerce/features/auth/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences.dart';

abstract class AuthRepository {
  Future<User> signUpWithEmail(String email, String password);
  Future<User> signInWithEmail(String email, String password);
  Future<User> signInWithGoogle();
  Future<void> sendOtp(String phoneNumber);
  Future<User> verifyOtp(String phoneNumber, String otp);
  Future<void> sendEmailVerification();
  Future<void> verifyEmail(String token);
  Future<void> resetPassword(String email);
  Future<void> logout();
  Future<User?> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _prefs;

  AuthRepositoryImpl()
      : _apiClient = ApiClient(),
        _googleSignIn = GoogleSignIn(scopes: ['email']),
        _prefs = await SharedPreferences.getInstance();

  @override
  Future<User> signUpWithEmail(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/signup', data: {
        'email': email,
        'password': password,
      });
      final user = User.fromJson(response['user']);
      await _saveToken(response['token']);
      return user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final user = User.fromJson(response['user']);
      await _saveToken(response['token']);
      return user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign in cancelled');

      final googleAuth = await googleUser.authentication;
      final response = await _apiClient.post('/auth/google', data: {
        'idToken': googleAuth.idToken,
      });

      final user = User.fromJson(response['user']);
      await _saveToken(response['token']);
      return user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {
    try {
      await _apiClient.post('/auth/otp/send', data: {
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<User> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await _apiClient.post('/auth/otp/verify', data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
      });
      final user = User.fromJson(response['user']);
      await _saveToken(response['token']);
      return user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _apiClient.post('/auth/email/verify/send');
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await _apiClient.post('/auth/email/verify', data: {
        'token': token,
      });
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _apiClient.post('/auth/password/reset', data: {
        'email': email,
      });
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
      await _googleSignIn.signOut();
      await _prefs.remove('auth_token');
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final token = _prefs.getString('auth_token');
      if (token == null) return null;

      final response = await _apiClient.get('/auth/me');
      return User.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveToken(String token) async {
    await _prefs.setString('auth_token', token);
    _apiClient.setAuthToken(token);
  }

  Exception _handleAuthError(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data != null && data['message'] != null) {
        return Exception(data['message']);
      }
      switch (error.response?.statusCode) {
        case 401:
          return Exception('Invalid credentials');
        case 409:
          return Exception('Email already exists');
        default:
          return Exception('Authentication failed');
      }
    }
    return Exception('Something went wrong');
  }
}