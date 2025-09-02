// lib/features/dashboard/presentation/widgets/summary_cards.dart
import 'package:flutter/material.dart';
import 'package:property_manager/features/dashboard/presentation/bloc/dashboard_state.dart';

class SummaryCards extends StatelessWidget {
  final DashboardData data;

  const SummaryCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _SummaryCard(
          title: 'Total Properties',
          value: data.totalProperties.toString(),
          icon: Icons.home_work,
          color: Colors.blue,
          onTap: () => _navigateToProperties(context),
        ),
        _SummaryCard(
          title: 'Active Leases',
          value: data.activeLeases.toString(),
          icon: Icons.assignment,
          color: Colors.green,
          onTap: () => _navigateToLeases(context),
        ),
        _SummaryCard(
          title: 'Monthly Revenue',
          value: '₹${_formatCurrency(data.monthlyRevenue)}',
          icon: Icons.trending_up,
          color: Colors.orange,
          onTap: () => _navigateToPayments(context),
        ),
        _SummaryCard(
          title: 'Occupancy Rate',
          value: '${data.occupancyRate.toStringAsFixed(1)}%',
          icon: Icons.pie_chart,
          color: Colors.purple,
          onTap: () => _navigateToReports(context),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  void _navigateToProperties(BuildContext context) {
    Navigator.pushNamed(context, '/properties');
  }

  void _navigateToLeases(BuildContext context) {
    Navigator.pushNamed(context, '/leases');
  }

  void _navigateToPayments(BuildContext context) {
    Navigator.pushNamed(context, '/payments');
  }

  void _navigateToReports(BuildContext context) {
    Navigator.pushNamed(context, '/reports');
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                ],
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
