import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  /// Sign up new user with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
        },
      );

      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  /// Sign in existing user
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      final client = await _supabaseService.client;
      await client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  /// Get current user
  User? getCurrentUser() {
    try {
      final client = _supabaseService.syncClient;
      return client.auth.currentUser;
    } catch (error) {
      return null;
    }
  }

  /// Get current session
  Session? getCurrentSession() {
    try {
      final client = _supabaseService.syncClient;
      return client.auth.currentSession;
    } catch (error) {
      return null;
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return getCurrentUser() != null;
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges {
    final client = _supabaseService.syncClient;
    return client.auth.onAuthStateChange;
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      final client = await _supabaseService.client;
      await client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  /// Update user password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final client = await _supabaseService.client;
      final response = await client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } catch (error) {
      throw Exception('Password update failed: $error');
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final client = await _supabaseService.client;
      final user = getCurrentUser();
      if (user?.email != null) {
        await client.auth.resend(
          type: OtpType.signup,
          email: user!.email!,
        );
      }
    } catch (error) {
      throw Exception('Email verification failed: $error');
    }
  }
}
