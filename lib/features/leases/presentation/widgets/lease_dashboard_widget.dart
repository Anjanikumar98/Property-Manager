// lib/features/leases/presentation/widgets/lease_dashboard_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/lease.dart';
import '../../domain/repositories/lease_repository.dart';
import '../bloc/lease_bloc.dart';
import '../bloc/lease_state.dart';
import 'lease_status_badge.dart';
import '../../../../shared/widgets/loading_widget.dart';

class LeaseDashboardWidget extends StatelessWidget {
  const LeaseDashboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaseBloc, LeaseState>(
      builder: (context, state) {
        if (state is LeaseLoading) {
          return const LoadingWidget();
        } else if (state is LeaseLoaded) {
          return _buildDashboard(context, state);
        } else if (state is LeaseError) {
          return _buildError(state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDashboard(BuildContext context, LeaseLoaded state) {
    final statistics = _calculateStatistics(state.leases);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lease Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildStatisticsCards(statistics),
          const SizedBox(height: 24),
          if (state.expiringLeases.isNotEmpty) ...[
            _buildExpiringLeasesSection(context, state.expiringLeases),
            const SizedBox(height: 24),
          ],
          _buildLeaseStatusChart(statistics),
          const SizedBox(height: 24),
          _buildRecentActivity(state.leases),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Error loading lease data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(LeaseStatistics statistics) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          'Total Leases',
          statistics.totalLeases.toString(),
          Icons.description,
          Colors.blue,
        ),
        _buildStatCard(
          'Active Leases',
          statistics.activeLeases.toString(),
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Expiring Soon',
          statistics.expiringLeases.toString(),
          Icons.warning,
          Colors.orange,
        ),
        _buildStatCard(
          'Monthly Revenue',
          '\$${statistics.totalMonthlyRent.toStringAsFixed(0)}',
          Icons.monetization_on,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiringLeasesSection(
    BuildContext context,
    List<Lease> expiringLeases,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'Leases Expiring Soon',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _navigateToExpiringLeases(context),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...expiringLeases
                .take(3)
                .map((lease) => _buildExpiringLeaseItem(lease)),
            if (expiringLeases.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'And ${expiringLeases.length - 3} more...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiringLeaseItem(Lease lease) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lease.propertyName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tenant: ${lease.tenantName}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${lease.remainingDays} days',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                'remaining',
                style: TextStyle(color: Colors.grey[600], fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaseStatusChart(LeaseStatistics statistics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lease Status Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusBar(
              'Active',
              statistics.activeLeases,
              statistics.totalLeases,
              Colors.green,
            ),
            _buildStatusBar(
              'Draft',
              statistics.draftLeases,
              statistics.totalLeases,
              Colors.blue,
            ),
            _buildStatusBar(
              'Expired',
              statistics.expiredLeases,
              statistics.totalLeases,
              Colors.red,
            ),
            _buildStatusBar(
              'Terminated',
              statistics.terminatedLeases,
              statistics.totalLeases,
              Colors.grey,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Occupancy Rate'),
                Text(
                  '${(statistics.occupancyRate * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(String label, int count, int total, Color color) {
    final percentage = total > 0 ? count / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label), Text('$count')],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<Lease> leases) {
    final recentLeases = [...leases]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final top5 = recentLeases.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _navigateToAllLeases,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...top5.map((lease) => _buildRecentActivityItem(lease)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityItem(Lease lease) {
    final isRecentlyCreated =
        DateTime.now().difference(lease.createdAt).inDays < 7;
    final isRecentlyUpdated =
        DateTime.now().difference(lease.updatedAt).inHours < 24 &&
        lease.updatedAt.isAfter(lease.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isRecentlyCreated ? Icons.add_circle : Icons.edit,
            color: isRecentlyCreated ? Colors.green : Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lease.propertyName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tenant: ${lease.tenantName}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (isRecentlyCreated)
                  const Text(
                    'New lease created',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                if (isRecentlyUpdated)
                  const Text(
                    'Lease updated',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
              ],
            ),
          ),
          Text(
            '${lease.updatedAt.difference(DateTime.now()).inDays.abs()}d ago',
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          ),
        ],
      ),
    );
  }

  // --------------------------
  // Helpers
  // --------------------------
  LeaseStatistics _calculateStatistics(List<Lease> leases) {
    final total = leases.length;
    final active = leases.where((l) => l.status == LeaseStatus.active).length;
    final draft = leases.where((l) => l.status == LeaseStatus.draft).length;
    final expired = leases.where((l) => l.status == LeaseStatus.expired).length;
    final terminated =
        leases.where((l) => l.status == LeaseStatus.terminated).length;
    final expiring = leases.where((l) => l.remainingDays <= 30).length;
    final totalRent = leases.fold<double>(0, (sum, l) => sum + l.monthlyRent);

    final occupancyRate = total > 0 ? active / total : 0.0;

    return LeaseStatistics(
      totalLeases: total,
      activeLeases: active,
      draftLeases: draft,
      expiredLeases: expired,
      terminatedLeases: terminated,
      expiringLeases: expiring,
      totalMonthlyRent: totalRent,
      occupancyRate: occupancyRate,
    );
  }

  void _navigateToExpiringLeases(BuildContext context) {
    Navigator.pushNamed(context, '/leases/expiring');
  }

  void _navigateToAllLeases() {
    // TODO: integrate with navigation
  }
}

// Helper model for dashboard statistics
class LeaseStatistics {
  final int totalLeases;
  final int activeLeases;
  final int draftLeases;
  final int expiredLeases;
  final int terminatedLeases;
  final int expiringLeases;
  final double totalMonthlyRent;
  final double occupancyRate;

  LeaseStatistics({
    required this.totalLeases,
    required this.activeLeases,
    required this.draftLeases,
    required this.expiredLeases,
    required this.terminatedLeases,
    required this.expiringLeases,
    required this.totalMonthlyRent,
    required this.occupancyRate,
  });
}
