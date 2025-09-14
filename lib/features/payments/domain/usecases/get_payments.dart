// lib/features/payments/domain/usecases/get_payments.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import 'package:property_manager/features/payments/presentation/pages/payment_history_page.dart';
import 'package:property_manager/features/payments/presentation/widgets/payment_search_widget.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart'
    show PaymentHistory;
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPaymentsa implements UseCase<List<Payment>, GetPaymentsParamsa> {
  final PaymentRepository repository;

  GetPaymentsa(this.repository);

  @override
  Future<Either<Failure, List<Payment>>> call(GetPaymentsParamsa params) async {
    return await repository.getPayments(
      leaseId: params.leaseId,
      tenantId: params.tenantId,
      propertyId: params.propertyId,
      status: params.status,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }

  Future<Either<Failure, PaymentHistory>> getPaymentHistory({
    String? searchQuery,
    PaymentFilter? filter,
    PaymentSortOption? sortOption,
    int? page,
    int? pageSize,
  }) {
    // Implementation will be added later
    throw UnimplementedError();
  }

  getOverduePayments() {}

  searchPayments(AdvancedSearchCriteria criteria) {}

  getPaymentById(String paymentId) {}
}

class GetPaymentsParamsa extends Equatable {
  final String? leaseId;
  final String? tenantId;
  final String? propertyId;
  final PaymentStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetPaymentsParamsa({
    this.leaseId,
    this.tenantId,
    this.propertyId,
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    leaseId,
    tenantId,
    propertyId,
    status,
    startDate,
    endDate,
  ];
}
