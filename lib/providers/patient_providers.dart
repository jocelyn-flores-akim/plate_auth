import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/patient_model.dart';
import '../services/patient_service.dart';

final patientServiceProvider = Provider((ref) => PatientService());

final patientsProvider = FutureProvider((ref) async {
  final service = ref.watch(patientServiceProvider);
  return service.getAllPatients();
});

final patientSearchProvider = FutureProvider.family<List<Patient>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final service = ref.watch(patientServiceProvider);
  return service.searchPatients(query);
});

class PatientNotifier extends StateNotifier<AsyncValue<List<Patient>>> {
  final PatientService _patientService;

  PatientNotifier(this._patientService) : super(const AsyncValue.loading());

  Future<void> loadPatients() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _patientService.getAllPatients());
  }

  Future<void> addPatient({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String phoneNumber,
    String? address,
  }) async {
    try {
      await _patientService.createPatient(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
        address: address,
      );
      await loadPatients();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      await _patientService.deletePatient(patientId);
      await loadPatients();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final patientsNotifierProvider =
    StateNotifierProvider<PatientNotifier, AsyncValue<List<Patient>>>((ref) {
  final service = ref.watch(patientServiceProvider);
  return PatientNotifier(service);
});
