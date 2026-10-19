import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admission_model.dart';
import 'package:uuid/uuid.dart';

class AdmissionService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  const AdmissionService();

  Future<Admission> createAdmission({
    required String patientId,
    required String bedId,
    required String doctorId,
    required String service,
    required String reason,
    String? notes,
  }) async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      final now = DateTime.now();

      final data = {
        'id': id,
        'patient_id': patientId,
        'bed_id': bedId,
        'doctor_id': doctorId,
        'service': service,
        'reason': reason,
        'notes': notes,
        'status': 'active',
        'admission_date': now.toIso8601String(),
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      await _supabaseClient.from('admissions').insert(data);
      return Admission.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Admission>> getActiveAdmissions() async {
    try {
      final results = await _supabaseClient
        .from('admissions')
        .select()
        .eq('status', 'active')
        .order('admission_date', ascending: false);

      return (results as List).map((a) => Admission.fromJson(a)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Admission>> getAdmissionsByPatient(String patientId) async {
    try {
      final results = await _supabaseClient
        .from('admissions')
        .select()
        .eq('patient_id', patientId)
        .order('admission_date', ascending: false);

      return (results as List).map((a) => Admission.fromJson(a)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Admission>> getAdmissionsByDoctor(String doctorId) async {
    try {
      final results = await _supabaseClient
        .from('admissions')
        .select()
        .eq('doctor_id', doctorId)
        .eq('status', 'active')
        .order('admission_date', ascending: false);

      return (results as List).map((a) => Admission.fromJson(a)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Admission>> getAdmissionsByService(String service) async {
    try {
      final results = await _supabaseClient
        .from('admissions')
        .select()
        .eq('service', service)
        .eq('status', 'active')
        .order('admission_date', ascending: false);

      return (results as List).map((a) => Admission.fromJson(a)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Admission?> getActiveAdmissionByBed(String bedId) async {
    try {
      final result = await _supabaseClient
        .from('admissions')
        .select()
        .eq('bed_id', bedId)
        .eq('status', 'active')
        .maybeSingle();

      return result != null ? Admission.fromJson(result) : null;
    } catch (e) {
      return null;
    }
  }

  Future<Admission> dischargePatient({
    required String admissionId,
    required String? dischargeNotes,
  }) async {
    try {
      final now = DateTime.now();
      final data = {
        'status': 'discharged',
        'discharge_date': now.toIso8601String(),
        'notes': dischargeNotes,
        'updated_at': now.toIso8601String(),
      };

      await _supabaseClient
        .from('admissions')
        .update(data)
        .eq('id', admissionId);

      final admission = await _supabaseClient
        .from('admissions')
        .select()
        .eq('id', admissionId)
        .single();

      return Admission.fromJson(admission);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getAdmissionsToday() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final results = await _supabaseClient
        .from('admissions')
        .select()
        .gte('admission_date', startOfDay.toIso8601String())
        .eq('status', 'active');

      return (results as List).length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getDischargesToday() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final results = await _supabaseClient
        .from('admissions')
        .select()
        .gte('discharge_date', startOfDay.toIso8601String())
        .eq('status', 'discharged');

      return (results as List).length;
    } catch (e) {
      return 0;
    }
  }

  Future<double> getAverageLengthOfStay(String? service) async {
    try {
      var query = _supabaseClient
        .from('admissions')
        .select()
        .eq('status', 'discharged');

      if (service != null) {
        query = query.eq('service', service);
      }

      final results = await query;

      if ((results as List).isEmpty) return 0.0;

      double totalDays = 0;
      for (var admission in results) {
        final admit = Admission.fromJson(admission);
        totalDays += admit.lengthOfStay;
      }

      return totalDays / results.length;
    } catch (e) {
      return 0.0;
    }
  }
}
