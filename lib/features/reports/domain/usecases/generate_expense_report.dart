// features/reports/domain/usecases/generate_expense_report.dart
import 'package:property_manager/features/reports/domain/entities/report.dart';
import 'package:property_manager/features/reports/domain/repositories/report_repository.dart';

class GenerateExpenseReport {
  final ReportRepository repository;

  GenerateExpenseReport(this.repository);

  Future<ExpenseReport> call(ReportFilters filters) async {
    return await repository.generateExpenseReport(filters);
  }
}
