import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<User?> login(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) return null;

      final userData = await _supabaseClient
        .from('users')
        .select()
        .eq('id', response.user!.id)
        .single();

      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) return null;

      final userData = await _supabaseClient
        .from('users')
        .select()
        .eq('id', session.user.id)
        .single();

      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }

  Future<void> updatePassword(String newPassword) async {
    await _supabaseClient.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Stream<AuthState> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange;
  }
}
