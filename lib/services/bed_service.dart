import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bed_model.dart';
import 'package:uuid/uuid.dart';

class BedService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  const BedService();

  Future<Building> createBuilding({
    required String name,
    required int floorsCount,
  }) async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      final now = DateTime.now();

      final data = {
        'id': id,
        'name': name,
        'floors_count': floorsCount,
        'created_at': now.toIso8601String(),
      };

      await _supabaseClient.from('buildings').insert(data);
      return Building.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Building>> getAllBuildings() async {
    try {
      final results = await _supabaseClient
        .from('buildings')
        .select()
        .order('name');

      return (results as List).map((b) => Building.fromJson(b)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Wing> createWing({
    required String buildingId,
    required String name,
    required String floor,
  }) async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      final now = DateTime.now();

      final data = {
        'id': id,
        'building_id': buildingId,
        'name': name,
        'floor': floor,
        'created_at': now.toIso8601String(),
      };

      await _supabaseClient.from('wings').insert(data);
      return Wing.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Wing>> getWingsByBuilding(String buildingId) async {
    try {
      final results = await _supabaseClient
        .from('wings')
        .select()
        .eq('building_id', buildingId)
        .order('floor');

      return (results as List).map((w) => Wing.fromJson(w)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Room> createRoom({
    required String wingId,
    required String name,
    required String service,
    required int capacity,
  }) async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      final now = DateTime.now();

      final data = {
        'id': id,
        'wing_id': wingId,
        'name': name,
        'service': service,
        'capacity': capacity,
        'created_at': now.toIso8601String(),
      };

      await _supabaseClient.from('rooms').insert(data);
      return Room.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Room>> getRoomsByWing(String wingId) async {
    try {
      final results = await _supabaseClient
        .from('rooms')
        .select()
        .eq('wing_id', wingId)
        .order('name');

      return (results as List).map((r) => Room.fromJson(r)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Room>> getRoomsByService(String service) async {
    try {
      final results = await _supabaseClient
        .from('rooms')
        .select()
        .eq('service', service);

      return (results as List).map((r) => Room.fromJson(r)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Bed> createBed({
    required String roomId,
    required String bedNumber,
    required BedType type,
  }) async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      final now = DateTime.now();

      final data = {
        'id': id,
        'room_id': roomId,
        'bed_number': bedNumber,
        'bed_type': type.value,
        'status': 'available',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      await _supabaseClient.from('beds').insert(data);
      return Bed.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Bed>> getBedsByRoom(String roomId) async {
    try {
      final results = await _supabaseClient
        .from('beds')
        .select()
        .eq('room_id', roomId)
        .order('bed_number');

      return (results as List).map((b) => Bed.fromJson(b)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Bed>> getAvailableBedsByService(String service) async {
    try {
      final results = await _supabaseClient
        .from('beds')
        .select('*, rooms(*)')
        .eq('status', 'available')
        .filter('rooms.service', 'eq', service)
        .order('bed_number');

      return (results as List).map((b) => Bed.fromJson(b)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Bed> updateBedStatus({
    required String bedId,
    required BedStatus status,
    String? patientId,
  }) async {
    try {
      final now = DateTime.now();
      final data = {
        'status': status.value,
        'current_patient_id': patientId,
        'admission_date': patientId != null ? now.toIso8601String() : null,
        'updated_at': now.toIso8601String(),
      };

      await _supabaseClient
        .from('beds')
        .update(data)
        .eq('id', bedId);

      final bed = await _supabaseClient
        .from('beds')
        .select()
        .eq('id', bedId)
        .single();

      return Bed.fromJson(bed);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, int>> getBedStatistics() async {
    try {
      final beds = await _supabaseClient.from('beds').select();
      
      int available = 0;
      int occupied = 0;
      int cleaning = 0;

      for (var bed in beds as List) {
        final status = BedStatus.fromString(bed['status']);
        switch (status) {
          case BedStatus.available:
            available++;
            break;
          case BedStatus.occupied:
            occupied++;
            break;
          case BedStatus.cleaning:
            cleaning++;
            break;
        }
      }

      return {
        'total': beds.length,
        'available': available,
        'occupied': occupied,
        'cleaning': cleaning,
      };
    } catch (e) {
      return {'total': 0, 'available': 0, 'occupied': 0, 'cleaning': 0};
    }
  }

  Future<double> getOccupancyRate() async {
    try {
      final stats = await getBedStatistics();
      final total = stats['total'] ?? 0;
      final occupied = stats['occupied'] ?? 0;
      
      if (total == 0) return 0.0;
      return (occupied / total) * 100;
    } catch (e) {
      return 0.0;
    }
  }
}
