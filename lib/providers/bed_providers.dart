import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bed_model.dart';
import '../services/bed_service.dart';

final bedServiceProvider = Provider((ref) => BedService());

final buildingsProvider = FutureProvider((ref) async {
  final service = ref.watch(bedServiceProvider);
  return service.getAllBuildings();
});

final bedStatisticsProvider = FutureProvider((ref) async {
  final service = ref.watch(bedServiceProvider);
  return service.getBedStatistics();
});

final occupancyRateProvider = FutureProvider((ref) async {
  final service = ref.watch(bedServiceProvider);
  return service.getOccupancyRate();
});

final availableBedsByServiceProvider = FutureProvider.family<List<Bed>, String>((ref, service) async {
  final bedService = ref.watch(bedServiceProvider);
  return bedService.getAvailableBedsByService(service);
});

final bedsByRoomProvider = FutureProvider.family<List<Bed>, String>((ref, roomId) async {
  final service = ref.watch(bedServiceProvider);
  return service.getBedsByRoom(roomId);
});

final wingsByBuildingProvider = FutureProvider.family<List<Wing>, String>((ref, buildingId) async {
  final service = ref.watch(bedServiceProvider);
  return service.getWingsByBuilding(buildingId);
});

final roomsByWingProvider = FutureProvider.family<List<Room>, String>((ref, wingId) async {
  final service = ref.watch(bedServiceProvider);
  return service.getRoomsByWing(wingId);
});

final roomsByServiceProvider = FutureProvider.family<List<Room>, String>((ref, service) async {
  final bedService = ref.watch(bedServiceProvider);
  return bedService.getRoomsByService(service);
});
