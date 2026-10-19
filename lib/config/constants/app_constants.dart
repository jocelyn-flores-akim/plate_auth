class AppConstants {
  // Services
  static const List<String> SERVICES = [
    'Maternité',
    'Chirurgie',
    'Médecine interne',
    'Pédiatrie',
    'Urgences',
    'Soins intensifs',
    'Cardiologie',
    'Orthopédie',
  ];

  // Buildings
  static const List<String> BUILDINGS = [
    'Bâtiment A',
    'Bâtiment B',
    'Bâtiment Central',
  ];

  // Floors
  static const List<String> FLOORS = [
    'RDC',
    '1er étage',
    '2ème étage',
    '3ème étage',
    '4ème étage',
  ];

  // Wings
  static const List<String> WINGS = [
    'Aile Est',
    'Aile Ouest',
    'Aile Nord',
    'Aile Sud',
  ];

  // Routes
  static const String ROUTE_LOGIN = '/login';
  static const String ROUTE_AGENT_DASHBOARD = '/agent/dashboard';
  static const String ROUTE_DOCTOR_DASHBOARD = '/doctor/dashboard';
  static const String ROUTE_ADMIN_DASHBOARD = '/admin/dashboard';

  // API Endpoints (if needed)
  static const String API_BASE_URL = 'https://your-supabase-url.supabase.co';
}
