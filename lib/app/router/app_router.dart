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

// import 'package:flutter/material.dart';
// import 'package:property_manager/features/leases/domain/entities/lease.dart';
// import 'package:property_manager/features/payments/domain/entities/payment.dart';
// import 'package:property_manager/features/properties/domain/entities/property.dart';
// import 'package:property_manager/features/tenants/domain/entities/tenant.dart';
// import 'package:property_manager/shared/widgets/date_picker_field.dart';
// import '../../features/auth/presentation/pages/login_page.dart';
// import '../../features/auth/presentation/pages/register_page.dart';
// import '../../features/dashboard/presentation/pages/dashboard_page.dart';
// import '../../features/properties/presentation/pages/properties_list_page.dart';
// import '../../features/properties/presentation/pages/add_property_page.dart';
// import '../../features/properties/presentation/pages/property_detail_page.dart';
// import '../../features/leases/presentation/pages/leases_list_page.dart';
// import '../../features/leases/presentation/pages/create_lease_page.dart';
// import '../../features/leases/presentation/pages/lease_detail_page.dart';
// import '../../features/payments/presentation/pages/payments_list_page.dart';
// import '../../features/payments/presentation/pages/record_payment_page.dart';
// import '../../features/payments/presentation/pages/payment_detail_page.dart';
// import '../../features/reports/presentation/pages/reports_page.dart';
// import '../../features/reports/presentation/pages/detailed_report_page.dart';
// import '../theme/app_theme.dart';
//
// class AppRouter {
//   static const String login = '/login';
//   static const String register = '/register';
//   static const String dashboard = '/dashboard';
//   static const String properties = '/properties';
//   static const String addProperty = '/properties/add';
//   static const String propertyDetail = '/properties/detail';
//   static const String tenants = '/tenants';
//   static const String addTenant = '/tenants/add';
//   static const String tenantDetail = '/tenants/detail';
//   static const String leases = '/leases';
//   static const String createLease = '/leases/create';
//   static const String leaseDetail = '/leases/detail';
//   static const String payments = '/payments';
//   static const String recordPayment = '/payments/record';
//   static const String paymentDetail = '/payments/detail';
//   static const String reports = '/reports';
//   static const String detailedReport = '/reports/detailed';
//
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case login:
//       // return _createRoute(
//       //   const LoginPage(),
//       //   settings,
//       //   transitionType: TransitionType.fade,
//       // );
//
//       case register:
//       // return _createRoute(
//       //   const RegisterPage(),
//       //   settings,
//       //   transitionType: TransitionType.slide,
//       //   slideDirection: SlideDirection.bottomToTop,
//       // );
//
//       case dashboard:
//         return _createRoute(
//           const DashboardPage(),
//           settings,
//           transitionType: TransitionType.fade,
//         );
//
//       case properties:
//         return _createRoute(
//           const PropertiesListPage(),
//           settings,
//           transitionType: TransitionType.slide,
//         );
//
//       case addProperty:
//         return _createRoute(
//           const AddPropertyPage(),
//           settings,
//           transitionType: TransitionType.slide,
//           slideDirection: SlideDirection.bottomToTop,
//         );
//
//       case propertyDetail:
//         final property = settings.arguments as Property?;
//         if (property == null) {
//           return _createErrorRoute('Property data is required');
//         }
//         return _createRoute(
//           PropertyDetailPage(property: property),
//           settings,
//           transitionType: TransitionType.slide,
//         );
//
//       case tenants:
//         // return _createRoute(
//         //   const TenantsListPage(),
//         //   settings,
//         //   transitionType: TransitionType.slide,
//         // );
//
//       case addTenant:
//         // return _createRoute(
//         //   const AddTenantPage(),
//         //   settings,
//         //   transitionType: TransitionType.slide,
//         //   slideDirection: SlideDirection.bottomToTop,
//         // );
//
//       case tenantDetail:
//         final tenant = settings.arguments as Tenant?;
//         if (tenant == null) {
//           return _createErrorRoute('Tenant data is required');
//         }
//         return _createRoute(
//           TenantDetailPage(tenant: tenant),
//           settings,
//           transitionType: TransitionType.slide,
//         );
//
//       case leases:
//         return _createRoute(
//           const LeasesListPage(),
//           settings,
//           transitionType: TransitionType.slide,
//         );
//
//       case createLease:
//         final args = settings.arguments as Map<String, dynamic>?;
//         return _createRoute(
//           CreateLeasePage(property: args?['property'], tenant: args?['tenant']),
//           settings,
//           transitionType: TransitionType.slide,
//           slideDirection: SlideDirection.bottomToTop,
//         );
//
//       case leaseDetail:
//         final lease = settings.arguments as Lease?;
//         if (lease == null) {
//           return _createErrorRoute('Lease data is required');
//         }
//         return _createRoute(
//           LeaseDetailPage(lease: lease),
//           settings,
//           transitionType: TransitionType.slide,
//         );
//
//       case payments:
//         return _createRoute(
//           const PaymentsListPage(),
//           settings,
//           transitionType: TransitionType.slide,
//         );
//
//       case recordPayment:
//         final args = settings.arguments as Map<String, dynamic>?;
//         return _createRoute(
//           RecordPaymentPage(lease: args?['lease'], property: args?['property']),
//           settings,
//           transitionType: TransitionType.slide,
//           slideDirection: SlideDirection.bottomToTop,
//         );
//
//       case paymentDetail:
//         final payment = settings.arguments as Payment?;
//         if (payment == null) {
//           return _createErrorRoute('Payment data is required');
//         }
//         return _createRoute(
//           PaymentDetailPage(payment: payment),
//           settings,
//           transitionType: TransitionType.slide,
//         );
//
//       case reports:
//         return _createRoute(
//           const ReportsPage(),
//           settings,
//           transitionType: TransitionType.slide,
//         );
//
//       case detailedReport:
//         final args = settings.arguments as Map<String, dynamic>?;
//         return _createRoute(
//           DetailedReportPage(
//             reportType: args?['reportType'] ?? 'income',
//             dateRange: args?['dateRange'],
//           ),
//           settings,
//           transitionType: TransitionType.slide,
//         );
//
//       default:
//         return _createErrorRoute('Route ${settings.name} not found');
//     }
//   }
//
//   static PageRouteBuilder<T> _createRoute<T>(
//     Widget page,
//     RouteSettings settings, {
//     TransitionType transitionType = TransitionType.slide,
//     SlideDirection slideDirection = SlideDirection.rightToLeft,
//     Duration? duration,
//   }) {
//     final actualDuration = duration ?? AppTheme.normalAnimation;
//
//     switch (transitionType) {
//       case TransitionType.slide:
//         return SlidePageRoute<T>(child: page, direction: slideDirection);
//
//       case TransitionType.fade:
//         return FadePageRoute<T>(child: page);
//
//       case TransitionType.scale:
//         return ScalePageRoute<T>(child: page);
//
//       case TransitionType.custom:
//         return PageRouteBuilder<T>(
//           settings: settings,
//           pageBuilder: (context, animation, secondaryAnimation) => page,
//           transitionDuration: actualDuration,
//           reverseTransitionDuration: actualDuration,
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return _buildCustomTransition(animation, secondaryAnimation, child);
//           },
//         );
//     }
//   }
//
//   static Widget _buildCustomTransition(
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child,
//   ) {
//     // Custom transition with slide and fade combined
//     const begin = Offset(1.0, 0.0);
//     const end = Offset.zero;
//     const curve = Curves.easeInOutCubic;
//
//     final tween = Tween(begin: begin, end: end);
//     final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
//
//     final slideTransition = SlideTransition(
//       position: tween.animate(curvedAnimation),
//       child: child,
//     );
//
//     final fadeTransition = FadeTransition(
//       opacity: animation,
//       child: slideTransition,
//     );
//
//     // Add scale transition for secondary animation (previous page)
//     final scaleTransition = ScaleTransition(
//       scale: Tween<double>(begin: 1.0, end: 0.95).animate(
//         CurvedAnimation(
//           parent: secondaryAnimation,
//           curve: Curves.easeInOutCubic,
//         ),
//       ),
//       child: fadeTransition,
//     );
//
//     return scaleTransition;
//   }
//
//   static Route<dynamic> _createErrorRoute(String message) {
//     return PageRouteBuilder(
//       pageBuilder:
//           (context, animation, secondaryAnimation) => Scaffold(
//             appBar: AppBar(
//               title: const Text('Error'),
//               backgroundColor: Theme.of(context).colorScheme.error,
//               foregroundColor: Theme.of(context).colorScheme.onError,
//             ),
//             body: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(AppTheme.spacing24),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.error_outline,
//                       size: 64,
//                       color: Theme.of(context).colorScheme.error,
//                     ),
//                     const SizedBox(height: AppTheme.spacing16),
//                     Text(
//                       'Navigation Error',
//                       style: AppTheme.titleLarge.copyWith(
//                         color: Theme.of(context).colorScheme.error,
//                       ),
//                     ),
//                     const SizedBox(height: AppTheme.spacing8),
//                     Text(
//                       message,
//                       style: AppTheme.bodyMedium.copyWith(
//                         color: Theme.of(context).colorScheme.onSurfaceVariant,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: AppTheme.spacing24),
//                     ElevatedButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: const Text('Go Back'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//       transitionDuration: AppTheme.fastAnimation,
//     );
//   }
//
//   // Navigation helper methods
//   static Future<T?> navigateTo<T>(
//     BuildContext context,
//     String routeName, {
//     Object? arguments,
//   }) {
//     return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
//   }
//
//   static Future<T?> navigateToAndReplace<T>(
//     BuildContext context,
//     String routeName, {
//     Object? arguments,
//   }) {
//     return Navigator.pushReplacementNamed<T, T>(
//       context,
//       routeName,
//       arguments: arguments,
//     );
//   }
//
//   static Future<T?> navigateToAndClearStack<T>(
//     BuildContext context,
//     String routeName, {
//     Object? arguments,
//   }) {
//     return Navigator.pushNamedAndRemoveUntil<T>(
//       context,
//       routeName,
//       (route) => false,
//       arguments: arguments,
//     );
//   }
//
//   static void goBack(BuildContext context, [dynamic result]) {
//     Navigator.pop(context, result);
//   }
//
//   static bool canGoBack(BuildContext context) {
//     return Navigator.canPop(context);
//   }
//
//   // Specific navigation methods for common use cases
//   static Future<void> navigateToLogin(BuildContext context) {
//     return navigateToAndClearStack(context, login);
//   }
//
//   static Future<void> navigateToDashboard(BuildContext context) {
//     return navigateToAndClearStack(context, dashboard);
//   }
//
//   static Future<bool?> navigateToAddProperty(BuildContext context) {
//     return navigateTo<bool>(context, addProperty);
//   }
//
//   static Future<void> navigateToPropertyDetail(
//     BuildContext context,
//     Property property,
//   ) {
//     return navigateTo(context, propertyDetail, arguments: property);
//   }
//
//   static Future<bool?> navigateToAddTenant(BuildContext context) {
//     return navigateTo<bool>(context, addTenant);
//   }
//
//   static Future<void> navigateToTenantDetail(
//     BuildContext context,
//     Tenant tenant,
//   ) {
//     return navigateTo(context, tenantDetail, arguments: tenant);
//   }
//
//   static Future<bool?> navigateToCreateLease(
//     BuildContext context, {
//     Property? property,
//     Tenant? tenant,
//   }) {
//     return navigateTo<bool>(
//       context,
//       createLease,
//       arguments: {'property': property, 'tenant': tenant},
//     );
//   }
//
//   static Future<void> navigateToLeaseDetail(BuildContext context, Lease lease) {
//     return navigateTo(context, leaseDetail, arguments: lease);
//   }
//
//   static Future<bool?> navigateToRecordPayment(
//     BuildContext context, {
//     Lease? lease,
//     Property? property,
//   }) {
//     return navigateTo<bool>(
//       context,
//       recordPayment,
//       arguments: {'lease': lease, 'property': property},
//     );
//   }
//
//   static Future<void> navigateToPaymentDetail(
//     BuildContext context,
//     Payment payment,
//   ) {
//     return navigateTo(context, paymentDetail, arguments: payment);
//   }
//
//   static Future<void> navigateToDetailedReport(
//     BuildContext context, {
//     required String reportType,
//     DateTimeRange? dateRange,
//   }) {
//     return navigateTo(
//       context,
//       detailedReport,
//       arguments: {'reportType': reportType, 'dateRange': dateRange},
//     );
//   }
// }
//
// enum TransitionType { slide, fade, scale, custom }
//
// // Route observer for analytics and debugging
// class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPush(route, previousRoute);
//     _logNavigation('PUSH', route, previousRoute);
//   }
//
//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPop(route, previousRoute);
//     _logNavigation('POP', route, previousRoute);
//   }
//
//   @override
//   void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//     _logNavigation('REPLACE', newRoute, oldRoute);
//   }
//
//   void _logNavigation(
//     String action,
//     Route<dynamic>? route,
//     Route<dynamic>? previousRoute,
//   ) {
//     final routeName = route?.settings.name ?? 'Unknown';
//     final previousRouteName = previousRoute?.settings.name ?? 'Unknown';
//
//     debugPrint(
//       '🧭 Navigation: $action - From: $previousRouteName -> To: $routeName',
//     );
//
//     // Here you can add analytics tracking
//     // Analytics.trackScreenView(routeName);
//   }
// }
