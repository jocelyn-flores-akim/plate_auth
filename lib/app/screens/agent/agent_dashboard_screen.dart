import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../config/theme/app_theme.dart';
import '../../providers/bed_providers.dart';
import '../../providers/admission_providers.dart';

class AgentDashboardScreen extends ConsumerWidget {
  const AgentDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bedStats = ref.watch(bedStatisticsProvider);
    final occupancyRate = ref.watch(occupancyRateProvider);
    final activeAdmissions = ref.watch(activeAdmissionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord Agent'),
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
          final isTablet = sizingInformation.isTablet;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics Cards
                  bedStats.when(
                    data: (stats) => _buildStatisticsCards(stats, context, isMobile),
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Erreur: $err')),
                  ),
                  SizedBox(height: 30.h),
                  // Quick Actions
                  _buildQuickActions(context),
                  SizedBox(height: 30.h),
                  // Active Admissions
                  Text(
                    'Admissions actuelles',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  activeAdmissions.when(
                    data: (admissions) => _buildAdmissionsList(admissions, context),
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

  Widget _buildStatisticsCards(Map<String, int> stats, BuildContext context, bool isMobile) {
    final cards = [
      {
        'title': 'Lits libres',
        'value': stats['available'] ?? 0,
        'color': AppTheme.bedAvailable,
        'icon': Icons.check_circle,
      },
      {
        'title': 'Lits occupés',
        'value': stats['occupied'] ?? 0,
        'color': AppTheme.bedOccupied,
        'icon': Icons.person,
      },
      {
        'title': 'En nettoyage',
        'value': stats['cleaning'] ?? 0,
        'color': AppTheme.bedCleaning,
        'icon': Icons.cleaning_services,
      },
      {
        'title': 'Total',
        'value': stats['total'] ?? 0,
        'color': AppTheme.secondaryColor,
        'icon': Icons.bed,
      },
    ];

    return GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.w,
      childAspectRatio: 1.2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: cards.map((card) {
        return _StatisticCard(
          title: card['title'] as String,
          value: card['value'] as int,
          color: card['color'] as Color,
          icon: card['icon'] as IconData,
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 16.h),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.w,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _QuickActionButton(
              title: 'Nouveau patient',
              icon: Icons.person_add,
              color: Colors.blue,
              onPressed: () {},
            ),
            _QuickActionButton(
              title: 'Admission',
              icon: Icons.hospital_bed,
              color: Colors.green,
              onPressed: () {},
            ),
            _QuickActionButton(
              title: 'Scanner QR',
              icon: Icons.qr_code_scanner,
              color: Colors.orange,
              onPressed: () {},
            ),
            _QuickActionButton(
              title: 'Gestion lits',
              icon: Icons.grid_view,
              color: Colors.purple,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdmissionsList(List<dynamic> admissions, BuildContext context) {
    if (admissions.isEmpty) {
      return Center(
        child: Text('Aucune admission active'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: admissions.length > 5 ? 5 : admissions.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('Patient ${index + 1}'),
            subtitle: Text('Service: Général'),
            trailing: Icon(Icons.arrow_forward),
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
          icon: Icon(Icons.bed),
          label: 'Lits',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Admission',
        ),
      ],
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final IconData icon;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
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
            Text(
              title,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 32.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
