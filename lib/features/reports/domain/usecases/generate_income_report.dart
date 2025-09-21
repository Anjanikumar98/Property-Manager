// features/reports/domain/usecases/generate_income_report.dart
import 'package:property_manager/features/reports/domain/entities/report.dart';
import 'package:property_manager/features/reports/domain/repositories/report_repository.dart';

class GenerateIncomeReport {
  final ReportRepository repository;

  GenerateIncomeReport(this.repository);

  Future<IncomeReport> call(ReportFilters filters) async {
    return await repository.generateIncomeReport(filters);
  }
}
