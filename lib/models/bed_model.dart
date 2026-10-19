enum BedStatus {
  available('available', 'Libre'),
  occupied('occupied', 'Occupé'),
  cleaning('cleaning', 'Nettoyage');

  final String value;
  final String label;
  const BedStatus(this.value, this.label);

  static BedStatus fromString(String value) {
    return BedStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => BedStatus.available,
    );
  }
}

enum BedType {
  standard('standard', 'Standard'),
  bariatric('bariatric', 'Bariatrique'),
  pediatric('pediatric', 'Pédiatrique'),
  intensive('intensive', 'Soins intensifs');

  final String value;
  final String label;
  const BedType(this.value, this.label);

  static BedType fromString(String value) {
    return BedType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => BedType.standard,
    );
  }
}

class Building {
  final String id;
  final String name;
  final int floorsCount;
  final DateTime createdAt;

  Building({
    required this.id,
    required this.name,
    required this.floorsCount,
    required this.createdAt,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      floorsCount: json['floors_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'floors_count': floorsCount,
    'created_at': createdAt.toIso8601String(),
  };
}

class Wing {
  final String id;
  final String buildingId;
  final String name;
  final String floor;
  final DateTime createdAt;

  Wing({
    required this.id,
    required this.buildingId,
    required this.name,
    required this.floor,
    required this.createdAt,
  });

  factory Wing.fromJson(Map<String, dynamic> json) {
    return Wing(
      id: json['id'] ?? '',
      buildingId: json['building_id'] ?? '',
      name: json['name'] ?? '',
      floor: json['floor'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'building_id': buildingId,
    'name': name,
    'floor': floor,
    'created_at': createdAt.toIso8601String(),
  };
}

class Room {
  final String id;
  final String wingId;
  final String name;
  final String service;
  final int capacity;
  final DateTime createdAt;

  Room({
    required this.id,
    required this.wingId,
    required this.name,
    required this.service,
    required this.capacity,
    required this.createdAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      wingId: json['wing_id'] ?? '',
      name: json['name'] ?? '',
      service: json['service'] ?? '',
      capacity: json['capacity'] ?? 1,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'wing_id': wingId,
    'name': name,
    'service': service,
    'capacity': capacity,
    'created_at': createdAt.toIso8601String(),
  };
}

class Bed {
  final String id;
  final String roomId;
  final String bedNumber;
  final BedStatus status;
  final BedType type;
  final String? currentPatientId;
  final DateTime? admissionDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bed({
    required this.id,
    required this.roomId,
    required this.bedNumber,
    required this.status,
    required this.type,
    this.currentPatientId,
    this.admissionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bed.fromJson(Map<String, dynamic> json) {
    return Bed(
      id: json['id'] ?? '',
      roomId: json['room_id'] ?? '',
      bedNumber: json['bed_number'] ?? '',
      status: BedStatus.fromString(json['status'] ?? 'available'),
      type: BedType.fromString(json['bed_type'] ?? 'standard'),
      currentPatientId: json['current_patient_id'],
      admissionDate: json['admission_date'] != null 
        ? DateTime.parse(json['admission_date'])
        : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'room_id': roomId,
    'bed_number': bedNumber,
    'status': status.value,
    'bed_type': type.value,
    'current_patient_id': currentPatientId,
    'admission_date': admissionDate?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Bed copyWith({
    String? id,
    String? roomId,
    String? bedNumber,
    BedStatus? status,
    BedType? type,
    String? currentPatientId,
    DateTime? admissionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bed(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      bedNumber: bedNumber ?? this.bedNumber,
      status: status ?? this.status,
      type: type ?? this.type,
      currentPatientId: currentPatientId ?? this.currentPatientId,
      admissionDate: admissionDate ?? this.admissionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
