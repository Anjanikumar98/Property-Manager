// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/dashboard/data/models/dashboard_data_model.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/summary_cards.dart';
import '../widgets/recent_activities.dart';
import '../widgets/payment_status_chart.dart';
import '../widgets/occupancy_overview.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardData());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(
            onPressed: () => _navigateToNotifications(context),
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
          ),
          IconButton(
            onPressed: () => _showProfileMenu(context),
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed:
                      () => context.read<DashboardBloc>().add(
                        LoadDashboardData(),
                      ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const LoadingWidget();
          } else if (state is DashboardError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry:
                  () => context.read<DashboardBloc>().add(LoadDashboardData()),
            );
          } else if (state is DashboardLoaded) {
            return _DashboardContent(data: state.data);
          } else if (state is DashboardRefreshing) {
            // Show current data while refreshing
            if (state.currentData != null) {
              return Stack(
                children: [
                  _DashboardContent(data: state.currentData!),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(),
                  ),
                ],
              );
            } else {
              return const LoadingWidget();
            }
          }

          return const Center(child: Text('Welcome to PropertyMaster'));
        },
      ),
      floatingActionButton: _QuickActionButton(),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.pushNamed(context, '/notifications').catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifications feature coming soon!')),
      );
    });
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ProfileMenuSheet(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardData data;

  const _DashboardContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(RefreshDashboardData());
        // Wait a bit for the refresh to register
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _WelcomeSection(),
            const SizedBox(height: 24),

            // Summary Cards
            SummaryCards(data: data),
            const SizedBox(height: 24),

            // Quick Navigation
            _QuickNavigationSection(),
            const SizedBox(height: 24),

            // Main Content Layout
            _buildMainContent(context),

            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 900;
    final isDesktop = screenWidth > 1200;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                RecentActivities(activities: data.recentActivities),
                const SizedBox(height: 16),
                OccupancyOverview(occupancyData: data.occupancyData),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                PaymentStatusChart(paymentData: data.paymentStatusData),
                const SizedBox(height: 16),
                _FinancialChart(data: data.financialData),
              ],
            ),
          ),
        ],
      );
    } else if (isTablet) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RecentActivities(activities: data.recentActivities),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PaymentStatusChart(paymentData: data.paymentStatusData),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: OccupancyOverview(occupancyData: data.occupancyData),
              ),
              const SizedBox(width: 16),
              Expanded(child: _FinancialChart(data: data.financialData)),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          RecentActivities(activities: data.recentActivities),
          const SizedBox(height: 16),
          PaymentStatusChart(paymentData: data.paymentStatusData),
          const SizedBox(height: 16),
          OccupancyOverview(occupancyData: data.occupancyData),
          const SizedBox(height: 16),
          _FinancialChart(data: data.financialData),
        ],
      );
    }
  }
}

class _FinancialChart extends StatelessWidget {
  final List<FinancialDataPoint> data;

  const _FinancialChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Financial Overview',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (data.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('No financial data available'),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final point = data[index];
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '₹${_formatAmount(point.netIncome)}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Container(
                            width: 40,
                            decoration: BoxDecoration(
                              color:
                                  point.netIncome >= 0
                                      ? Colors.green.withOpacity(0.8)
                                      : Colors.red.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(point.month, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17) {
      greeting = 'Good Evening';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Welcome back to PropertyMaster',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your properties efficiently',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickNavigationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _QuickActionCard(
                title: 'Add Property',
                icon: Icons.add_home,
                color: Colors.blue,
                onTap: () => _navigateWithFallback(context, '/add-property'),
              ),
              const SizedBox(width: 12),
              _QuickActionCard(
                title: 'Record Payment',
                icon: Icons.payment,
                color: Colors.green,
                onTap: () => _navigateWithFallback(context, '/record-payment'),
              ),
              const SizedBox(width: 12),
              _QuickActionCard(
                title: 'Create Lease',
                icon: Icons.assignment_add,
                color: Colors.orange,
                onTap: () => _navigateWithFallback(context, '/create-lease'),
              ),
              const SizedBox(width: 12),
              _QuickActionCard(
                title: 'Add Tenant',
                icon: Icons.person_add,
                color: Colors.purple,
                onTap: () => _navigateWithFallback(context, '/add-tenant'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateWithFallback(BuildContext context, String route) {
    Navigator.pushNamed(context, route).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${route.replaceFirst('/', '').replaceAll('-', ' ')} feature coming soon!',
          ),
        ),
      );
    });
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showQuickActionMenu(context),
      backgroundColor: Colors.blue[600],
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showQuickActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _QuickActionMenuSheet(),
    );
  }
}

class _QuickActionMenuSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': 'Add Property',
        'icon': Icons.add_home,
        'route': '/add-property',
      },
      {
        'title': 'Record Payment',
        'icon': Icons.payment,
        'route': '/record-payment',
      },
      {
        'title': 'Create Lease',
        'icon': Icons.assignment_add,
        'route': '/create-lease',
      },
      {'title': 'Add Tenant', 'icon': Icons.person_add, 'route': '/add-tenant'},
      {
        'title': 'Generate Report',
        'icon': Icons.assessment,
        'route': '/reports',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...actions.map(
            (action) => ListTile(
              leading: Icon(action['icon'] as IconData),
              title: Text(action['title'] as String),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  action['route'] as String,
                ).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${action['title']} feature coming soon!'),
                    ),
                  );
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ProfileMenuSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Menu',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Settings'),
            onTap: () => _navigateWithFallback(context, '/profile'),
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('App Settings'),
            onTap: () => _navigateWithFallback(context, '/settings'),
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup & Sync'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup feature coming soon!')),
              );
            },
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () => _navigateWithFallback(context, '/help'),
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _showLogoutDialog(context),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _navigateWithFallback(BuildContext context, String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${route.replaceFirst('/', '').replaceAll('-', ' ')} feature coming soon!',
          ),
        ),
      );
    });
  }

  void _showLogoutDialog(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}
