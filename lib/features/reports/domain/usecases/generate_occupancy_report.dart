// features/reports/domain/usecases/generate_occupancy_report.dart
import 'package:property_manager/features/reports/domain/entities/report.dart';
import 'package:property_manager/features/reports/domain/repositories/report_repository.dart';

class GenerateOccupancyReport {
  final ReportRepository repository;

  GenerateOccupancyReport(this.repository);

  Future<OccupancyReport> call(ReportFilters filters) async {
    return await repository.generateOccupancyReport(filters);
  }
}
