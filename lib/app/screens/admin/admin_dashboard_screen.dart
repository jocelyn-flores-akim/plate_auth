import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../config/theme/app_theme.dart';
import '../../providers/bed_providers.dart';
import '../../providers/admission_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bedStats = ref.watch(bedStatisticsProvider);
    final occupancyRate = ref.watch(occupancyRateProvider);
    final admissionStats = ref.watch(admissionStatisticsProvider(null));

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord Administrateur'),
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
                  // Overview Cards
                  _buildOverviewCards(context, isMobile, bedStats, occupancyRate, admissionStats),
                  SizedBox(height: 30.h),
                  // Quick Stats
                  _buildQuickStats(context),
                  SizedBox(height: 30.h),
                  // Admin Actions
                  _buildAdminActions(context, isMobile),
                ],
              ),
            ),
          );
        },
      ),
      drawer: _buildAdminDrawer(context),
    );
  }

  Widget _buildOverviewCards(
    BuildContext context,
    bool isMobile,
    AsyncValue<Map<String, int>> bedStats,
    AsyncValue<double> occupancyRate,
    AsyncValue<Map<String, int>> admissionStats,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aperçu général',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 16.h),
        bedStats.when(
          data: (stats) => GridView.count(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.w,
            childAspectRatio: 1.2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _AdminStatCard(
                title: 'Total lits',
                value: stats['total'] ?? 0,
                icon: Icons.bed,
                color: AppTheme.secondaryColor,
              ),
              _AdminStatCard(
                title: 'Lits libres',
                value: stats['available'] ?? 0,
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              _AdminStatCard(
                title: 'Lits occupés',
                value: stats['occupied'] ?? 0,
                icon: Icons.person,
                color: Colors.red,
              ),
              _AdminStatCard(
                title: 'En nettoyage',
                value: stats['cleaning'] ?? 0,
                icon: Icons.cleaning_services,
                color: Colors.orange,
              ),
            ],
          ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Erreur')),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiques rapides',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Taux d\'occupation',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '78%',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patients aujourd\'hui',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '24',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminActions(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions administrateur',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 16.h),
        GridView.count(
          crossAxisCount: isMobile ? 2 : 3,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.w,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _AdminActionCard(
              title: 'Utilisateurs',
              icon: Icons.people,
              color: Colors.blue,
              onPressed: () {},
            ),
            _AdminActionCard(
              title: 'Lits & Chambres',
              icon: Icons.bed,
              color: Colors.green,
              onPressed: () {},
            ),
            _AdminActionCard(
              title: 'Statistiques',
              icon: Icons.bar_chart,
              color: Colors.orange,
              onPressed: () {},
            ),
            _AdminActionCard(
              title: 'Paramètres',
              icon: Icons.settings,
              color: Colors.purple,
              onPressed: () {},
            ),
            _AdminActionCard(
              title: 'Sauvegardes',
              icon: Icons.backup,
              color: Colors.teal,
              onPressed: () {},
            ),
            _AdminActionCard(
              title: 'Logs',
              icon: Icons.history,
              color: Colors.red,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Text(
              'CHU Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', () {}),
          _buildDrawerItem(Icons.people, 'Gestion utilisateurs', () {}),
          _buildDrawerItem(Icons.bed, 'Parc de lits', () {}),
          _buildDrawerItem(Icons.bar_chart, 'Statistiques', () {}),
          _buildDrawerItem(Icons.settings, 'Paramètres', () {}),
          Divider(),
          _buildDrawerItem(Icons.logout, 'Déconnexion', () {}),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _AdminStatCard({
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
              padding: EdgeInsets.symmetric(horizontal: 4.w),
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

class _AdminActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _AdminActionCard({
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
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 40.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
