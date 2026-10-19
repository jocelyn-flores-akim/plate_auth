import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admission_model.dart';
import '../services/admission_service.dart';

final admissionServiceProvider = Provider((ref) => AdmissionService());

final activeAdmissionsProvider = FutureProvider((ref) async {
  final service = ref.watch(admissionServiceProvider);
  return service.getActiveAdmissions();
});

final admissionsByPatientProvider = FutureProvider.family<List<Admission>, String>((ref, patientId) async {
  final service = ref.watch(admissionServiceProvider);
  return service.getAdmissionsByPatient(patientId);
});

final admissionsByDoctorProvider = FutureProvider.family<List<Admission>, String>((ref, doctorId) async {
  final service = ref.watch(admissionServiceProvider);
  return service.getAdmissionsByDoctor(doctorId);
});

final admissionsByServiceProvider = FutureProvider.family<List<Admission>, String>((ref, service) async {
  final admissionService = ref.watch(admissionServiceProvider);
  return admissionService.getAdmissionsByService(service);
});

final admissionStatisticsProvider = FutureProvider.family<Map<String, int>, String?>((ref, service) async {
  final admissionService = ref.watch(admissionServiceProvider);
  final today = await admissionService.getAdmissionsToday();
  final discharged = await admissionService.getDischargesToday();
  
  return {
    'admissions_today': today,
    'discharges_today': discharged,
  };
});

final averageLengthOfStayProvider = FutureProvider.family<double, String?>((ref, service) async {
  final admissionService = ref.watch(admissionServiceProvider);
  return admissionService.getAverageLengthOfStay(service);
});
