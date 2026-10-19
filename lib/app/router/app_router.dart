import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/user_model.dart';
import '../../providers/auth_providers.dart';
import '../screens/auth/login_screen.dart';
import '../screens/agent/agent_dashboard_screen.dart';
import '../screens/doctor/doctor_dashboard_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final loginState = ref.watch(loginProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = loginState.user != null;
      
      if (!isLoggedIn) {
        return '/login';
      }

      if (state.matchedLocation == '/login') {
        // Redirect based on role
        switch (loginState.user!.role) {
          case UserRole.admin:
            return '/admin/dashboard';
          case UserRole.doctor:
            return '/doctor/dashboard';
          case UserRole.agent:
          case UserRole.nurse:
            return '/agent/dashboard';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Agent Routes
      GoRoute(
        path: '/agent/dashboard',
        builder: (context, state) => const AgentDashboardScreen(),
      ),
      GoRoute(
        path: '/agent/patients',
        builder: (context, state) => const AgentDashboardScreen(),
      ),
      GoRoute(
        path: '/agent/beds',
        builder: (context, state) => const AgentDashboardScreen(),
      ),
      GoRoute(
        path: '/agent/admission',
        builder: (context, state) => const AgentDashboardScreen(),
      ),
      // Doctor Routes
      GoRoute(
        path: '/doctor/dashboard',
        builder: (context, state) => const DoctorDashboardScreen(),
      ),
      GoRoute(
        path: '/doctor/patients',
        builder: (context, state) => const DoctorDashboardScreen(),
      ),
      GoRoute(
        path: '/doctor/history/:patientId',
        builder: (context, state) => const DoctorDashboardScreen(),
      ),
      // Admin Routes
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/statistics',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/beds',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});
