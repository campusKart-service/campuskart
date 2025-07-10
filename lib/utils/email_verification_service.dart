import 'dart:math';


import './supabase_service.dart';

class EmailVerificationService {
  static final EmailVerificationService _instance =
      EmailVerificationService._internal();
  factory EmailVerificationService() => _instance;
  EmailVerificationService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  /// Generate and send email verification token
  Future<Map<String, dynamic>> sendVerificationEmail({
    required String email,
    required String userId,
  }) async {
    try {
      final client = await _supabaseService.client;

      // Generate verification token
      final token = _generateVerificationToken();
      final expiresAt = DateTime.now().add(const Duration(hours: 24));

      // Store token in database
      await client.from('email_verification_tokens').insert({
        'user_id': userId,
        'email': email,
        'token': token,
        'expires_at': expiresAt.toIso8601String(),
      });

      // In a real app, you would send email here using Resend or similar service
      // For now, we'll return the token for testing
      return {
        'success': true,
        'token': token,
        'message': 'Verification email sent successfully',
        'expires_at': expiresAt.toIso8601String(),
      };
    } catch (error) {
      throw Exception('Failed to send verification email: $error');
    }
  }

  /// Verify email using token
  Future<Map<String, dynamic>> verifyEmail({
    required String userId,
    required String token,
  }) async {
    try {
      final client = await _supabaseService.client;

      // Call the database function to verify email
      final response = await client.rpc('verify_user_email', params: {
        'user_uuid': userId,
        'verification_token': token,
      });

      if (response == true) {
        return {
          'success': true,
          'message': 'Email verified successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid or expired verification token',
        };
      }
    } catch (error) {
      throw Exception('Email verification failed: $error');
    }
  }

  /// Check if email is verified
  Future<bool> isEmailVerified(String userId) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('user_profiles')
          .select('is_email_verified')
          .eq('id', userId)
          .single();

      return response['is_email_verified'] ?? false;
    } catch (error) {
      return false;
    }
  }

  /// Resend verification email
  Future<Map<String, dynamic>> resendVerificationEmail({
    required String email,
    required String userId,
  }) async {
    try {
      final client = await _supabaseService.client;

      // Invalidate existing tokens for this user
      await client
          .from('email_verification_tokens')
          .update({'expires_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('email', email);

      // Send new verification email
      return await sendVerificationEmail(email: email, userId: userId);
    } catch (error) {
      throw Exception('Failed to resend verification email: $error');
    }
  }

  /// Get user's verification status
  Future<Map<String, dynamic>> getVerificationStatus(String userId) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('user_profiles')
          .select(
              'is_email_verified, verification_status, verification_completed_at')
          .eq('id', userId)
          .single();

      return {
        'is_email_verified': response['is_email_verified'] ?? false,
        'verification_status': response['verification_status'] ?? 'pending',
        'verification_completed_at': response['verification_completed_at'],
      };
    } catch (error) {
      throw Exception('Failed to get verification status: $error');
    }
  }

  /// Check if email domain is valid for campus
  Future<bool> isValidCampusEmail(String email) async {
    try {
      final client = await _supabaseService.client;

      final domain = email.split('@').last;

      final response = await client
          .from('campuses')
          .select('id')
          .eq('domain', domain)
          .eq('status', 'active');

      return response.isNotEmpty;
    } catch (error) {
      return false;
    }
  }

  /// Get campus info by email domain
  Future<Map<String, dynamic>?> getCampusByEmailDomain(String email) async {
    try {
      final client = await _supabaseService.client;

      final domain = email.split('@').last;

      final response = await client
          .from('campuses')
          .select('*')
          .eq('domain', domain)
          .eq('status', 'active')
          .maybeSingle();

      return response;
    } catch (error) {
      return null;
    }
  }

  /// Generate random verification token
  String _generateVerificationToken() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(32, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
