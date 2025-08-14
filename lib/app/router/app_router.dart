import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/properties/presentation/pages/properties_list_page.dart';
import '../../features/properties/presentation/pages/add_property_page.dart';
import '../../features/properties/presentation/pages/property_detail_page.dart';
import '../../features/leases/presentation/pages/leases_list_page.dart';
import '../../features/leases/presentation/pages/create_lease_page.dart';
import '../../features/leases/presentation/pages/lease_detail_page.dart';
import '../../features/payments/presentation/pages/payments_list_page.dart';
import '../../features/payments/presentation/pages/record_payment_page.dart';
import '../../features/payments/presentation/pages/payment_detail_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/reports/presentation/pages/detailed_report_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth Routes
      // GoRoute(
      //   path: '/login',
      //   name: 'login',
      //   builder: (context, state) => const LoginPage(),
      // ),
      // GoRoute(
      //   path: '/register',
      //   name: 'register',
      //   builder: (context, state) => const RegisterPage(),
      // ),
      //
      // // Main App Routes
      // GoRoute(
      //   path: '/dashboard',
      //   name: 'dashboard',
      //   builder: (context, state) => const DashboardPage(),
      // ),
      //
      // // Properties Routes
      // GoRoute(
      //   path: '/properties',
      //   name: 'properties',
      //   builder: (context, state) => const PropertiesListPage(),
      // ),
      // GoRoute(
      //   path: '/properties/add',
      //   name: 'add-property',
      //   builder: (context, state) => const AddPropertyPage(),
      // ),
      // GoRoute(
      //   path: '/properties/:id',
      //   name: 'property-detail',
      //   builder:
      //       (context, state) =>
      //           PropertyDetailPage(propertyId: state.pathParameters['id']!),
      // ),
      //
      // // Tenants Routes
      // GoRoute(
      //   path: '/tenants',
      //   name: 'tenants',
      //   builder: (context, state) => const TenantsListPage(),
      // ),
      // GoRoute(
      //   path: '/tenants/add',
      //   name: 'add-tenant',
      //   builder: (context, state) => const AddTenantPage(),
      // ),
      // GoRoute(
      //   path: '/tenants/:id',
      //   name: 'tenant-detail',
      //   builder:
      //       (context, state) =>
      //           TenantDetailPage(tenantId: state.pathParameters['id']!),
      // ),
      //
      // // Leases Routes
      // GoRoute(
      //   path: '/leases',
      //   name: 'leases',
      //   builder: (context, state) => const LeasesListPage(),
      // ),
      // GoRoute(
      //   path: '/leases/create',
      //   name: 'create-lease',
      //   builder: (context, state) => const CreateLeasePage(),
      // ),
      // GoRoute(
      //   path: '/leases/:id',
      //   name: 'lease-detail',
      //   builder:
      //       (context, state) =>
      //           LeaseDetailPage(leaseId: state.pathParameters['id']!),
      // ),
      //
      // // Payments Routes
      // GoRoute(
      //   path: '/payments',
      //   name: 'payments',
      //   builder: (context, state) => const PaymentsListPage(),
      // ),
      // GoRoute(
      //   path: '/payments/record',
      //   name: 'record-payment',
      //   builder: (context, state) => const RecordPaymentPage(),
      // ),
      // GoRoute(
      //   path: '/payments/:id',
      //   name: 'payment-detail',
      //   builder:
      //       (context, state) =>
      //           PaymentDetailPage(paymentId: state.pathParameters['id']!),
      // ),
      //
      // // Reports Routes
      // GoRoute(
      //   path: '/reports',
      //   name: 'reports',
      //   builder: (context, state) => const ReportsPage(),
      // ),
      // GoRoute(
      //   path: '/reports/detailed',
      //   name: 'detailed-report',
      //   builder: (context, state) => const DetailedReportPage(),
      // ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Page not found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/dashboard'),
                  child: const Text('Go to Dashboard'),
                ),
              ],
            ),
          ),
        ),
  );
}
