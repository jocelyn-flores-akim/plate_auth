import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/patient_model.dart';
import 'package:uuid/uuid.dart';

class PatientService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  const PatientService();

  Future<Patient> createPatient({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String phoneNumber,
    String? address,
  }) async {
    try {
      final patientId = 'PAT-${DateTime.now().year}-${DateTime.now().microsecond.toString().padLeft(6, '0')}';
      const uuid = Uuid();
      final id = uuid.v4();
      final now = DateTime.now();

      final data = {
        'id': id,
        'patient_id': patientId,
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'phone_number': phoneNumber,
        'address': address,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      await _supabaseClient.from('patients').insert(data);

      return Patient.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Patient?> getPatient(String patientId) async {
    try {
      final data = await _supabaseClient
        .from('patients')
        .select()
        .eq('patient_id', patientId)
        .single();

      return Patient.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<List<Patient>> searchPatients(String query) async {
    try {
      final results = await _supabaseClient
        .from('patients')
        .select()
        .or('first_name.ilike.%$query%,last_name.ilike.%$query%,patient_id.ilike.%$query%,phone_number.ilike.%$query%')
        .limit(50);

      return (results as List).map((p) => Patient.fromJson(p)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Patient>> getAllPatients({int limit = 100, int offset = 0}) async {
    try {
      final results = await _supabaseClient
        .from('patients')
        .select()
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

      return (results as List).map((p) => Patient.fromJson(p)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Patient> updatePatient(Patient patient) async {
    try {
      final data = patient.toJson();
      data['updated_at'] = DateTime.now().toIso8601String();

      await _supabaseClient
        .from('patients')
        .update(data)
        .eq('id', patient.id);

      return patient.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      await _supabaseClient
        .from('patients')
        .delete()
        .eq('id', patientId);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Patient>> watchPatients() {
    return _supabaseClient
      .from('patients')
      .on(RealtimeListenTypes.all, onsuccess: (payload) {
        return payload.newRecord;
      })
      .asStream()
      .map((event) => [Patient.fromJson(event as Map<String, dynamic>)]);
  }
}
