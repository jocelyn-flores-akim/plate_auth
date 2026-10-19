enum AdmissionStatus {
  active('active', 'Active'),
  discharged('discharged', 'Sortie'),
  transferred('transferred', 'Transféré');

  final String value;
  final String label;
  const AdmissionStatus(this.value, this.label);

  static AdmissionStatus fromString(String value) {
    return AdmissionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AdmissionStatus.active,
    );
  }
}

class Admission {
  final String id;
  final String patientId;
  final String bedId;
  final String doctorId;
  final String service;
  final String reason;
  final String? notes;
  final AdmissionStatus status;
  final DateTime admissionDate;
  final DateTime? dischargeDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Admission({
    required this.id,
    required this.patientId,
    required this.bedId,
    required this.doctorId,
    required this.service,
    required this.reason,
    this.notes,
    required this.status,
    required this.admissionDate,
    this.dischargeDate,
    required this.createdAt,
    required this.updatedAt,
  });

  int get lengthOfStay {
    final end = dischargeDate ?? DateTime.now();
    return end.difference(admissionDate).inDays;
  }

  factory Admission.fromJson(Map<String, dynamic> json) {
    return Admission(
      id: json['id'] ?? '',
      patientId: json['patient_id'] ?? '',
      bedId: json['bed_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      service: json['service'] ?? '',
      reason: json['reason'] ?? '',
      notes: json['notes'],
      status: AdmissionStatus.fromString(json['status'] ?? 'active'),
      admissionDate: DateTime.parse(json['admission_date']),
      dischargeDate: json['discharge_date'] != null
        ? DateTime.parse(json['discharge_date'])
        : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'bed_id': bedId,
    'doctor_id': doctorId,
    'service': service,
    'reason': reason,
    'notes': notes,
    'status': status.value,
    'admission_date': admissionDate.toIso8601String(),
    'discharge_date': dischargeDate?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Admission copyWith({
    String? id,
    String? patientId,
    String? bedId,
    String? doctorId,
    String? service,
    String? reason,
    String? notes,
    AdmissionStatus? status,
    DateTime? admissionDate,
    DateTime? dischargeDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Admission(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      bedId: bedId ?? this.bedId,
      doctorId: doctorId ?? this.doctorId,
      service: service ?? this.service,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      admissionDate: admissionDate ?? this.admissionDate,
      dischargeDate: dischargeDate ?? this.dischargeDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
