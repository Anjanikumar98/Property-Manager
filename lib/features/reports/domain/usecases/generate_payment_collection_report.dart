// features/reports/domain/usecases/generate_payment_collection_report.dart
import 'package:property_manager/features/reports/domain/entities/report.dart';
import 'package:property_manager/features/reports/domain/repositories/report_repository.dart';

class GeneratePaymentCollectionReport {
  final ReportRepository repository;

  GeneratePaymentCollectionReport(this.repository);

  Future<PaymentCollectionReport> call(ReportFilters filters) async {
    return await repository.generatePaymentCollectionReport(filters);
  }
}

class ExportReportToPDF {
  final ReportRepository repository;

  ExportReportToPDF(this.repository);

  Future<String> call(Report report, String filePath) async {
    return await repository.exportReportToPDF(report, filePath);
  }
}
