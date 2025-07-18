import './supabase_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  /// Get user profile by ID
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final client = await _supabaseService.client;

      final response = await client.from('user_profiles').select('''
            *,
            campuses:campus_id (
              id,
              name,
              domain,
              location
            )
          ''').eq('id', userId).maybeSingle();

      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final client = await _supabaseService.client;

      // Add updated_at timestamp
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await client
          .from('user_profiles')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }

  /// Check if user is admin
  Future<bool> isUserAdmin(String userId) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('user_profiles')
          .select('role')
          .eq('id', userId)
          .single();

      return response['role'] == 'admin';
    } catch (error) {
      return false;
    }
  }

  /// Get all campuses
  Future<List<Map<String, dynamic>>> getCampuses() async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('campuses')
          .select('*')
          .eq('status', 'active')
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get campuses: $error');
    }
  }

  /// Get campus by ID
  Future<Map<String, dynamic>?> getCampusById(String campusId) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('campuses')
          .select('*')
          .eq('id', campusId)
          .maybeSingle();

      return response;
    } catch (error) {
      return null;
    }
  }

  /// Submit verification documents
  Future<Map<String, dynamic>> submitVerificationDocument({
    required String userId,
    required String documentType,
    required String documentUrl,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('verification_documents')
          .insert({
            'user_id': userId,
            'document_type': documentType,
            'document_url': documentUrl,
            'verification_status': 'pending',
          })
          .select()
          .single();

      // Update user profile verification status
      await client.from('user_profiles').update({
        'verification_submitted_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      return response;
    } catch (error) {
      throw Exception('Failed to submit verification document: $error');
    }
  }

  /// Get user verification documents
  Future<List<Map<String, dynamic>>> getUserVerificationDocuments(
      String userId) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('verification_documents')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get verification documents: $error');
    }
  }

  /// Associate user with campus
  Future<Map<String, dynamic>> associateUserWithCampus({
    required String userId,
    required String campusId,
    String? studentId,
  }) async {
    try {
      final client = await _supabaseService.client;

      final updates = {
        'campus_id': campusId,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (studentId != null && studentId.isNotEmpty) {
        updates['student_id'] = studentId;
      }

      final response = await client
          .from('user_profiles')
          .update(updates)
          .eq('id', userId)
          .select('''
            *,
            campuses:campus_id (
              id,
              name,
              domain,
              location
            )
          ''').single();

      return response;
    } catch (error) {
      throw Exception('Failed to associate user with campus: $error');
    }
  }

  /// Search users by email or name (admin only)
  Future<List<Map<String, dynamic>>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('user_profiles')
          .select('''
            id,
            email,
            full_name,
            role,
            verification_status,
            is_email_verified,
            campuses:campus_id (
              name,
              domain
            )
          ''')
          .or('email.ilike.%$query%,full_name.ilike.%$query%')
          .limit(limit)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to search users: $error');
    }
  }
}
