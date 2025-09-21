// // features/reports/data/repositories/report_repository_impl.dart
// import 'package:property_manager/core/services/database_service.dart';
// import 'package:property_manager/features/leases/data/repositories/lease_repository_impl.dart';
// import 'package:property_manager/features/leases/domain/entities/lease.dart';
// import 'package:property_manager/features/payments/domain/entities/payment.dart';
// import 'package:property_manager/features/payments/domain/repositories/payment_repository.dart';
// import 'package:property_manager/features/properties/domain/entities/property.dart';
// import 'package:property_manager/features/properties/domain/repositories/property_repository.dart';
// import 'package:property_manager/features/reports/domain/entities/report.dart';
// import 'package:property_manager/features/reports/domain/repositories/report_repository.dart';
// import 'package:property_manager/features/tenants/data/repositories/tenant_repository_impl.dart';
//
// class ReportRepositoryImpl implements ReportRepository {
//   final PropertyRepository propertyRepository;
//   final PaymentRepository paymentRepository;
//   final LeaseRepository leaseRepository;
//   final TenantRepository tenantRepository;
//   final DatabaseService databaseService;
//
//   ReportRepositoryImpl({
//     required this.propertyRepository,
//     required this.paymentRepository,
//     required this.leaseRepository,
//     required this.tenantRepository,
//     required this.databaseService,
//   });
//
//   @override
//   Future<IncomeReport> generateIncomeReport(ReportFilters filters) async {
//     try {
//       // Get all payments within the filter criteria
//       final payments = await _getFilteredPayments(filters);
//       final rentPayments =
//           payments.where((p) => p.type == PaymentType.rent).toList();
//       final otherPayments =
//           payments.where((p) => p.type != PaymentType.rent).toList();
//
//       final totalIncome = payments.fold<double>(
//         0,
//         (sum, payment) => sum + payment.amount,
//       );
//       final rentIncome = rentPayments.fold<double>(
//         0,
//         (sum, payment) => sum + payment.amount,
//       );
//       final otherIncome = otherPayments.fold<double>(
//         0,
//         (sum, payment) => sum + payment.amount,
//       );
//
//       // Generate monthly data
//       final monthlyData = await _generateMonthlyIncomeData(payments, filters);
//
//       // Generate property breakdown
//       final propertyBreakdown = await _generatePropertyIncomeBreakdown(
//         payments,
//       );
//
//       // Calculate averages and growth
//       final averageMonthlyIncome =
//           monthlyData.isNotEmpty
//               ? monthlyData.fold<double>(0, (sum, data) => sum + data.amount) /
//                   monthlyData.length
//               : 0;
//
//       final growthRate = _calculateIncomeGrowthRate(monthlyData);
//
//       return IncomeReport(
//         totalIncome: totalIncome,
//         rentIncome: rentIncome,
//         otherIncome: otherIncome,
//         monthlyData: monthlyData,
//         propertyBreakdown: propertyBreakdown,
//         averageMonthlyIncome: averageMonthlyIncome,
//         growthRate: growthRate,
//       );
//     } catch (e) {
//       throw Exception('Failed to generate income report: $e');
//     }
//   }
//
//   @override
//   Future<ExpenseReport> generateExpenseReport(ReportFilters filters) async {
//     try {
//       // This would typically get expense data from a separate expense tracking system
//       // For this example, we'll simulate expense data based on properties
//       final properties = await propertyRepository.getProperties();
//       final filteredProperties = _filterProperties(
//         properties as List<dynamic>,
//         filters,
//       );
//
//       // Simulate expense categories
//       const expenseCategories = [
//         'Maintenance',
//         'Insurance',
//         'Property Tax',
//         'Utilities',
//         'Management Fees',
//         'Repairs',
//         'Cleaning',
//         'Marketing',
//       ];
//
//       double totalExpenses = 0;
//       Map<String, double> categoryBreakdown = {};
//
//       // Generate simulated expense data
//       for (final category in expenseCategories) {
//         final categoryTotal =
//             filteredProperties.length * (500 + (category.hashCode % 1000));
//         categoryBreakdown[category] = categoryTotal.toDouble();
//         totalExpenses += categoryTotal;
//       }
//
//       final monthlyData = await _generateMonthlyExpenseData(
//         filteredProperties,
//         filters,
//       );
//       final propertyBreakdown = await _generatePropertyExpenseBreakdown(
//         filteredProperties,
//       );
//
//       final averageMonthlyExpense =
//           monthlyData.isNotEmpty
//               ? monthlyData.fold<double>(0, (sum, data) => sum + data.amount) /
//                   monthlyData.length
//               : 0;
//
//       final topExpenseCategory =
//           categoryBreakdown.entries
//               .reduce((a, b) => a.value > b.value ? a : b)
//               .key;
//
//       return ExpenseReport(
//         totalExpenses: totalExpenses,
//         categoryBreakdown: categoryBreakdown,
//         monthlyData: monthlyData,
//         propertyBreakdown: propertyBreakdown,
//         averageMonthlyExpense: averageMonthlyExpense,
//         topExpenseCategory: topExpenseCategory,
//       );
//     } catch (e) {
//       throw Exception('Failed to generate expense report: $e');
//     }
//   }
//
//   @override
//   Future<OccupancyReport> generateOccupancyReport(ReportFilters filters) async {
//     try {
//       final properties = await propertyRepository.getProperties();
//       final leases = await leaseRepository.getLeases();
//       final filteredProperties = _filterProperties(
//         properties as List<Property>,
//         filters,
//       );
//
//       int totalUnits = 0;
//       int occupiedUnits = 0;
//
//       final propertyBreakdown = <PropertyOccupancyData>[];
//
//       for (final property in filteredProperties) {
//         final propertyLeases =
//             leases
//                 .where(
//                   (l) =>
//                       l.propertyId == property.id &&
//                       l.status == LeaseStatus.active,
//                 )
//                 .toList();
//
//         final propertyUnits = property.units;
//         final propertyOccupied = propertyLeases.length;
//
//         totalUnits += propertyUnits;
//         occupiedUnits += propertyOccupied;
//
//         final averageRent =
//             propertyLeases.isNotEmpty
//                 ? propertyLeases.fold<double>(
//                       0,
//                       (sum, lease) => sum + lease.monthlyRent,
//                     ) /
//                     propertyLeases.length
//                 : 0;
//
//         propertyBreakdown.add(
//           PropertyOccupancyData(
//             propertyId: property.id,
//             propertyName: property.name,
//             totalUnits: propertyUnits,
//             occupiedUnits: propertyOccupied,
//             occupancyRate:
//                 propertyUnits > 0
//                     ? (propertyOccupied / propertyUnits) * 100
//                     : 0,
//             averageRent: averageRent,
//           ),
//         );
//       }
//
//       final currentOccupancyRate =
//           totalUnits > 0 ? (occupiedUnits / totalUnits) * 100 : 0;
//
//       final trendData = await _generateOccupancyTrendData(filters);
//       final averageOccupancyRate =
//           trendData.isNotEmpty
//               ? trendData.fold<double>(
//                     0,
//                     (sum, data) => sum + data.occupancyRate,
//                   ) /
//                   trendData.length
//               : currentOccupancyRate;
//
//       final averageLeaseLength = await _calculateAverageLeaseLength(leases);
//
//       return OccupancyReport(
//         currentOccupancyRate: currentOccupancyRate,
//         averageOccupancyRate: averageOccupancyRate,
//         trendData: trendData,
//         propertyBreakdown: propertyBreakdown,
//         totalUnits: totalUnits,
//         occupiedUnits: occupiedUnits,
//         vacantUnits: totalUnits - occupiedUnits,
//         averageLeaseLength: averageLeaseLength,
//       );
//     } catch (e) {
//       throw Exception('Failed to generate occupancy report: $e');
//     }
//   }
//
//   @override
//   Future<PaymentCollectionReport> generatePaymentCollectionReport(
//     ReportFilters filters,
//   ) async {
//     try {
//       final payments = await _getFilteredPayments(filters);
//       final leases = await leaseRepository.getLeases();
//       final tenants = await tenantRepository.getTenants();
//
//       // Calculate expected vs collected amounts
//       double totalExpected = 0;
//       double totalCollected = 0;
//
//       final activeLeases =
//           leases.where((l) => l.status == LeaseStatus.active).toList();
//
//       // Calculate expected income from active leases
//       for (final lease in activeLeases) {
//         final monthsInPeriod = _getMonthsInPeriod(filters);
//         totalExpected += lease.monthlyRent * monthsInPeriod;
//       }
//
//       totalCollected = payments.fold<double>(
//         0,
//         (sum, payment) => sum + payment.amount,
//       );
//       final totalOutstanding = totalExpected - totalCollected;
//       final collectionRate =
//           totalExpected > 0 ? (totalCollected / totalExpected) * 100 : 0;
//
//       // Categorize payments by timing
//       int onTimePayments = 0;
//       int latePayments = 0;
//       int missedPayments = 0;
//
//       for (final payment in payments) {
//         if (payment.status == PaymentStatus.paid) {
//           // Check if payment was made on time (simplified logic)
//           onTimePayments++;
//         } else if (payment.status == PaymentStatus.overdue) {
//           latePayments++;
//         }
//       }
//
//       missedPayments = activeLeases.length - payments.length;
//
//       final monthlyData = await _generateMonthlyCollectionData(
//         filters,
//         activeLeases,
//         payments,
//       );
//       final tenantBreakdown = await _generateTenantPaymentBreakdown(
//         tenants,
//         payments,
//         activeLeases,
//       );
//
//       return PaymentCollectionReport(
//         collectionRate: collectionRate,
//         totalExpected: totalExpected,
//         totalCollected: totalCollected,
//         totalOutstanding: totalOutstanding,
//         monthlyData: monthlyData,
//         tenantBreakdown: tenantBreakdown,
//         onTimePayments: onTimePayments,
//         latePayments: latePayments,
//         missedPayments: missedPayments > 0 ? missedPayments : 0,
//       );
//     } catch (e) {
//       throw Exception('Failed to generate payment collection report: $e');
//     }
//   }
//
//   @override
//   Future<String> exportReportToPDF(Report report, String filePath) async {
//     // This would integrate with a PDF generation service
//     // For now, return a mock file path
//     return '$filePath/report_${report.id}.pdf';
//   }
//
//   @override
//   Future<void> scheduleReport(String reportId, ScheduleConfig config) async {
//     // Implementation for report scheduling
//     await databaseService.insert('scheduled_reports', {
//       'report_id': reportId,
//       'schedule_config': config.toJson(),
//       'created_at': DateTime.now().toIso8601String(),
//     });
//   }
//
//   @override
//   Future<List<Report>> getSavedReports() async {
//     final results = await databaseService.query('saved_reports');
//     return results
//         .map((data) => ReportModel.fromJson(data).toEntity())
//         .toList();
//   }
//
//   @override
//   Future<void> saveReport(Report report) async {
//     final model = ReportModel.fromEntity(report);
//     await databaseService.insert('saved_reports', model.toJson());
//   }
//
//   @override
//   Future<void> deleteReport(String reportId) async {
//     await databaseService.delete(
//       'saved_reports',
//       where: 'id = ?',
//       whereArgs: [reportId],
//     );
//   }
//
//   // Private helper methods
//   Future<List<Payment>> _getFilteredPayments(ReportFilters filters) async {
//     final allPayments = await paymentRepository.getPayments();
//     return allPayments.where((payment) {
//       if (filters.startDate != null &&
//           payment.paymentDate.isBefore(filters.startDate!)) {
//         return false;
//       }
//       if (filters.endDate != null &&
//           payment.paymentDate.isAfter(filters.endDate!)) {
//         return false;
//       }
//       if (filters.propertyIds != null &&
//           !filters.propertyIds!.contains(payment.propertyId)) {
//         return false;
//       }
//       if (filters.tenantIds != null &&
//           !filters.tenantIds!.contains(payment.tenantId)) {
//         return false;
//       }
//       if (filters.paymentStatus != null &&
//           payment.status != filters.paymentStatus) {
//         return false;
//       }
//       return true;
//     }).toList();
//   }
//
//   List<Property> _filterProperties(
//     List<Property> properties,
//     ReportFilters filters,
//   ) {
//     return properties.where((property) {
//       if (filters.propertyIds != null &&
//           !filters.propertyIds!.contains(property.id)) {
//         return false;
//       }
//       return true;
//     }).toList();
//   }
//
//   // Additional helper methods would be implemented here...
//   Future<List<MonthlyIncomeData>> _generateMonthlyIncomeData(
//     List<Payment> payments,
//     ReportFilters filters,
//   ) async {
//     // Implementation for monthly income data generation
//     return [];
//   }
//
//   Future<List<PropertyIncomeData>> _generatePropertyIncomeBreakdown(
//     List<Payment> payments,
//   ) async {
//     // Implementation for property income breakdown
//     return [];
//   }
//
//   double _calculateIncomeGrowthRate(List<MonthlyIncomeData> monthlyData) {
//     // Implementation for growth rate calculation
//     return 0.0;
//   }
//
//   int _getMonthsInPeriod(ReportFilters filters) {
//     if (filters.startDate == null || filters.endDate == null) return 1;
//     return filters.endDate!.difference(filters.startDate!).inDays ~/ 30;
//   }
//
//   // More helper methods...
// }
