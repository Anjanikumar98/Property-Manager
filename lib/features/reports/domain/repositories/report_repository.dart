// features/reports/domain/repositories/report_repository.dart
import 'package:property_manager/features/reports/domain/entities/report.dart';
import 'package:property_manager/features/reports/domain/repositories/report_repository_impl.dart';

abstract class ReportRepository {
  Future<IncomeReport> generateIncomeReport(ReportFilters filters);
  Future<ExpenseReport> generateExpenseReport(ReportFilters filters);
  Future<OccupancyReport> generateOccupancyReport(ReportFilters filters);
  Future<PaymentCollectionReport> generatePaymentCollectionReport(
    ReportFilters filters,
  );
  Future<String> exportReportToPDF(Report report, String filePath);
  Future<void> scheduleReport(String reportId, ScheduleConfig config);
  Future<List<Report>> getSavedReports();
  Future<void> saveReport(Report report);
  Future<void> deleteReport(String reportId);
}

class ScheduleConfig {
  final ScheduleFrequency frequency;
  final DateTime nextRunDate;
  final String emailRecipients;
  final bool autoExportPDF;

  const ScheduleConfig({
    required this.frequency,
    required this.nextRunDate,
    required this.emailRecipients,
    required this.autoExportPDF,
  });

  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency.toString(),
      'next_run_date': nextRunDate.toIso8601String(),
      'email_recipients': emailRecipients,
      'auto_export_pdf': autoExportPDF,
    };
  }
}

enum ScheduleFrequency { daily, weekly, monthly, quarterly, yearly }
