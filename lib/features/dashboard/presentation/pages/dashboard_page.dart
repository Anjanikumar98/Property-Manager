// // lib/features/dashboard/presentation/pages/dashboard_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:property_manager/features/dashboard/presentation/bloc/dashboard_bloc.dart';
// import '../bloc/dashboard_event.dart';
// import '../bloc/dashboard_state.dart';
// import '../widgets/summary_cards.dart';
// import '../widgets/recent_activities.dart';
// import '../widgets/payment_status_chart.dart';
// import '../widgets/occupancy_overview.dart';
// import '../../../../shared/widgets/custom_app_bar.dart';
// import '../../../../shared/widgets/loading_widget.dart';
// import '../../../../shared/widgets/error_widget.dart';
//
// class DashboardPage extends StatefulWidget {
//   const DashboardPage({Key? key}) : super(key: key);
//
//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }
//
// class _DashboardPageState extends State<DashboardPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<DashboardBloc>().add(LoadDashboardData());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: CustomAppBar(
//         title: 'Dashboard',
//         //  showBackButton: false,
//         actions: [
//           IconButton(
//             onPressed: () => _navigateToNotifications(context),
//             icon: const Icon(Icons.notifications_outlined),
//           ),
//           IconButton(
//             onPressed: () => _showProfileMenu(context),
//             icon: const Icon(Icons.account_circle_outlined),
//           ),
//         ],
//       ),
//       body: BlocBuilder<DashboardBloc, DashboardState>(
//         builder: (context, state) {
//           if (state is DashboardLoading) {
//             return const LoadingWidget();
//           } else if (state is DashboardError) {
//             return CustomErrorWidget(
//               message: state.message,
//               onRetry:
//                   () => context.read<DashboardBloc>().add(LoadDashboardData()),
//             );
//           } else if (state is DashboardLoaded) {
//             return _DashboardContent(data: state.data);
//           }
//           return const SizedBox();
//         },
//       ),
//       floatingActionButton: _QuickActionButton(),
//     );
//   }
//
//   void _navigateToNotifications(BuildContext context) {
//     // Navigate to notifications page
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Notifications feature coming soon!')),
//     );
//   }
//
//   void _showProfileMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => _ProfileMenuSheet(),
//     );
//   }
// }
//
// class _DashboardContent extends StatelessWidget {
//   final DashboardData data;
//
//   const _DashboardContent({Key? key, required this.data}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         context.read<DashboardBloc>().add(RefreshDashboardData());
//         // Wait for the refresh to complete
//         await Future.delayed(const Duration(seconds: 1));
//       },
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Welcome Section
//             _WelcomeSection(),
//             const SizedBox(height: 24),
//
//             // Summary Cards
//             SummaryCards(data: data),
//             const SizedBox(height: 24),
//
//             // Quick Navigation
//             _QuickNavigationSection(),
//             const SizedBox(height: 24),
//
//             // Main Content Row
//             if (MediaQuery.of(context).size.width > 600)
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         RecentActivities(activities: data.recentActivities),
//                         const SizedBox(height: 16),
//                         OccupancyOverview(
//                           totalProperties: data.totalProperties,
//                           activeLeases: data.activeLeases,
//                           vacantProperties: data.vacantProperties,
//                           occupancyRate: data.occupancyRate,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: PaymentStatusChart(
//                       paymentOverview: data.paymentOverview,
//                     ),
//                   ),
//                 ],
//               )
//             else
//               Column(
//                 children: [
//                   RecentActivities(activities: data.recentActivities),
//                   const SizedBox(height: 16),
//                   PaymentStatusChart(paymentOverview: data.paymentOverview),
//                   const SizedBox(height: 16),
//                   OccupancyOverview(
//                     totalProperties: data.totalProperties,
//                     activeLeases: data.activeLeases,
//                     vacantProperties: data.vacantProperties,
//                     occupancyRate: data.occupancyRate,
//                   ),
//                 ],
//               ),
//
//             const SizedBox(height: 80), // Space for FAB
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _WelcomeSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final hour = DateTime.now().hour;
//     String greeting = 'Good Morning';
//     if (hour >= 12 && hour < 17) {
//       greeting = 'Good Afternoon';
//     } else if (hour >= 17) {
//       greeting = 'Good Evening';
//     }
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue[600]!, Colors.blue[400]!],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             greeting,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             'Welcome back to PropertyMaster',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Manage your properties efficiently',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _QuickNavigationSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Quick Actions',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               _QuickActionCard(
//                 title: 'Add Property',
//                 icon: Icons.add_home,
//                 color: Colors.blue,
//                 onTap: () => Navigator.pushNamed(context, '/add-property'),
//               ),
//               const SizedBox(width: 12),
//               _QuickActionCard(
//                 title: 'Record Payment',
//                 icon: Icons.payment,
//                 color: Colors.green,
//                 onTap: () => Navigator.pushNamed(context, '/record-payment'),
//               ),
//               const SizedBox(width: 12),
//               _QuickActionCard(
//                 title: 'Create Lease',
//                 icon: Icons.assignment_add,
//                 color: Colors.orange,
//                 onTap: () => Navigator.pushNamed(context, '/create-lease'),
//               ),
//               const SizedBox(width: 12),
//               _QuickActionCard(
//                 title: 'Add Tenant',
//                 icon: Icons.person_add,
//                 color: Colors.purple,
//                 onTap: () => Navigator.pushNamed(context, '/add-tenant'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _QuickActionCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;
//
//   const _QuickActionCard({
//     Key? key,
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 120,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.2)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: color, size: 24),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _QuickActionButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () => _showQuickActionMenu(context),
//       backgroundColor: Colors.blue[600],
//       child: const Icon(Icons.add, color: Colors.white),
//     );
//   }
//
//   void _showQuickActionMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => _QuickActionMenuSheet(),
//     );
//   }
// }
//
// class _QuickActionMenuSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final actions = [
//       {
//         'title': 'Add Property',
//         'icon': Icons.add_home,
//         'route': '/add-property',
//       },
//       {
//         'title': 'Record Payment',
//         'icon': Icons.payment,
//         'route': '/record-payment',
//       },
//       {
//         'title': 'Create Lease',
//         'icon': Icons.assignment_add,
//         'route': '/create-lease',
//       },
//       {'title': 'Add Tenant', 'icon': Icons.person_add, 'route': '/add-tenant'},
//       {
//         'title': 'Generate Report',
//         'icon': Icons.assessment,
//         'route': '/reports',
//       },
//     ];
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Quick Actions',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           ...actions.map(
//             (action) => ListTile(
//               leading: Icon(action['icon'] as IconData),
//               title: Text(action['title'] as String),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, action['route'] as String);
//               },
//               contentPadding: EdgeInsets.zero,
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }
//
// class _ProfileMenuSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Profile Menu',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Profile Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/profile');
//             },
//             contentPadding: EdgeInsets.zero,
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('App Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/settings');
//             },
//             contentPadding: EdgeInsets.zero,
//           ),
//           ListTile(
//             leading: const Icon(Icons.backup),
//             title: const Text('Backup & Sync'),
//             onTap: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Backup feature coming soon!')),
//               );
//             },
//             contentPadding: EdgeInsets.zero,
//           ),
//           ListTile(
//             leading: const Icon(Icons.help),
//             title: const Text('Help & Support'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/help');
//             },
//             contentPadding: EdgeInsets.zero,
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text('Logout', style: TextStyle(color: Colors.red)),
//             onTap: () => _showLogoutDialog(context),
//             contentPadding: EdgeInsets.zero,
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   void _showLogoutDialog(BuildContext context) {
//     Navigator.pop(context); // Close the sheet first
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Logout'),
//             content: const Text('Are you sure you want to logout?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // Add logout logic here
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     '/login',
//                     (route) => false,
//                   );
//                 },
//                 child: const Text('Logout'),
//               ),
//             ],
//           ),
//     );
//   }
// }
//
