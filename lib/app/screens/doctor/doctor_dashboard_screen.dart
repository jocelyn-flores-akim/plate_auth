import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../config/theme/app_theme.dart';
import '../../providers/admission_providers.dart';

class DoctorDashboardScreen extends ConsumerWidget {
  const DoctorDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admissionStats = ref.watch(admissionStatisticsProvider(null));
    final activeAdmissions = ref.watch(activeAdmissionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord Médecin'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // TODO: Logout
            },
          ),
        ],
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          final isMobile = sizingInformation.isMobile;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(context),
                  SizedBox(height: 30.h),
                  // Statistics
                  admissionStats.when(
                    data: (stats) => _buildStatistics(stats, context, isMobile),
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Erreur: $err')),
                  ),
                  SizedBox(height: 30.h),
                  // My Patients
                  Text(
                    'Mes patients',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  activeAdmissions.when(
                    data: (admissions) => _buildPatientsList(admissions, context),
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Erreur: $err')),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenue, Dr.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 4.h),
        Text(
          'Médecine interne',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(Map<String, int> stats, BuildContext context, bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 2 : 3,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.w,
      childAspectRatio: 1.2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _StatCard(
          title: 'Admissions aujourd\'hui',
          value: stats['admissions_today'] ?? 0,
          icon: Icons.login,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Sorties aujourd\'hui',
          value: stats['discharges_today'] ?? 0,
          icon: Icons.logout,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildPatientsList(List<dynamic> admissions, BuildContext context) {
    if (admissions.isEmpty) {
      return Center(
        child: Text('Aucun patient actuellement'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: admissions.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text('Patient ${index + 1}'),
            subtitle: Text('Lit: 101'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Patients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Historique',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                title,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
