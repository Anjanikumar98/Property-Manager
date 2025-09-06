// // lib/features/leases/data/repositories/lease_repository_impl.dart
//
// import 'package:dartz/dartz.dart';
// import '../../../../core/errors/failures.dart';
// import '../../../../core/errors/exceptions.dart';
// import '../../../../core/services/database_service.dart';
// import '../../domain/entities/lease.dart';
// import '../../domain/repositories/lease_repository.dart';
// import '../models/lease_model.dart';
//
// class LeaseRepositoryImpl implements LeaseRepository {
//   final DatabaseService databaseService;
//
//   LeaseRepositoryImpl({required this.databaseService});
//
//   @override
//   Future<Either<Failure, List<Lease>>> getLeases() async {
//     try {
//       final leases = await databaseService.getLeases();
//       return Right(leases);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } catch (e) {
//       return Left(UnknownFailure('Failed to fetch leases: ${e.toString()}'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, Lease>> getLeaseById(String id) async {
//     try {
//       final lease = await databaseService.getLeaseById(id);
//       if (lease == null) {
//         return Left(NotFoundFailure('Lease not found'));
//       }
//       return Right(lease);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } catch (e) {
//       return Left(UnknownFailure('Failed to fetch lease: ${e.toString()}'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, List<Lease>>> getLeasesByProperty(
//     String propertyId,
//   ) async {
//     try {
//       final leases = await databaseService.getLeasesByProperty(propertyId);
//       return Right(leases);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } catch (e) {
//       return Left(
//         UnknownFailure('Failed to fetch property leases: ${e.toString()}'),
//       );
//     }
//   }
//
//   @override
//   Future<Either<Failure, List<Lease>>> getLeasesByTenant(
//     String tenantId,
//   ) async {
//     try {
//       final leases = await databaseService.getLeasesByTenant(tenantId);
//       return Right(leases);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } catch (e) {
//       return Left(
//         UnknownFailure('Failed to fetch tenant leases: ${e.toString()}'),
//       );
//     }
//   }
//
//   @override
//   Future<Either<Failure, List<Lease>>> getActiveLeases() async {
//     try {
//       final leases = await databaseService.getActiveLeases();
//       return Right(leases);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } catch (e) {
//       return Left(
//         UnknownFailure('Failed to fetch active leases: ${e.toString()}'),
//       );
//     }
//   }
//
//   @override
//   Future<Either<Failure, List<Lease>>> getExpiringLeases() async {
//     try {
//       final leases = await databaseService.getExpiringLeases();
//       return Right(leases);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } catch (e) {
//       return Left(
//         UnknownFailure('Failed to fetch expiring leases: ${e.toString()}'),
//       );
//     }
//   }
//
//   @override
//   Future<Either<Failure, Lease>> createLease(Lease lease) async {
//     try {
//       // Validate lease dates
//       if (lease.startDate.isAfter(lease.endDate)) {
//         return Left(ValidationFailure('Start date cannot be after end date'));
//       }
//
//       // Check for overlapping leases on the same property
//       final existingLeases = await databaseService.getLeasesByProperty(
//         lease.propertyId,
//       );
//       final overlapping =
//           existingLeases.where((existing) {
//             if (existing.id == lease.id) return false;
//             if (existing.status == LeaseStatus.terminated ||
//                 existing.status == LeaseStatus.expired)
//               return false;
//
//             return (lease.startDate.isBefore(existing.endDate) &&
//                 lease.endDate.isAfter(existing.startDate));
//           }).toList();
//
//       if (overlapping.isNotEmpty) {
//         return Left(
//           ValidationFailure('Lease period overlaps with existing lease'),
//         );
//       }
//
//       final leaseModel = LeaseModel.fromEntity(lease);
//       final createdLease = await databaseService.insertLease(leaseModel);
//       return Right(createdLease);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } on ValidationException catch (e) {
//       return Left(ValidationFailure(e.message));
//     } catch (e) {
//       return Left(UnknownFailure('Failed to create lease: ${e.toString()}'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, Lease>> updateLease(Lease lease) async {
//     try {
//       // Validate lease dates
//       if (lease.startDate.isAfter(lease.endDate)) {
//         return Left(ValidationFailure('Start date cannot be after end date'));
//       }
//
//       final leaseModel = LeaseModel.fromEntity(
//         lease,
//       ).copyWith(updatedAt: DateTime.now());
//       final updatedLease = await databaseService.updateLease(leaseModel);
//       return Right(updatedLease);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } on ValidationException catch (e) {
//       return Left(ValidationFailure(e.message));
//     } catch (e) {
//       return Left(UnknownFailure('Failed to update lease: ${e.toString()}'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, void>> deleteLease(String id) async {
//     try {
//       await databaseService.deleteLease(id);
//       return const Right(null);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } catch (e) {
//       return Left(UnknownFailure('Failed to delete lease: ${e.toString()}'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, Lease>> terminateLease(
//     String id,
//     DateTime terminationDate,
//   ) async {
//     try {
//       final existingLease = await databaseService.getLeaseById(id);
//       if (existingLease == null) {
//         return Left(NotFoundFailure('Lease not found'));
//       }
//
//       final terminatedLease = existingLease.copyWith(
//         status: LeaseStatus.terminated,
//         endDate: terminationDate,
//         updatedAt: DateTime.now(),
//       );
//
//       final leaseModel = LeaseModel.fromEntity(terminatedLease);
//       final updatedLease = await databaseService.updateLease(leaseModel);
//       return Right(updatedLease);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } catch (e) {
//       return Left(UnknownFailure('Failed to terminate lease: ${e.toString()}'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, Lease>> renewLease(
//     String id,
//     DateTime newEndDate,
//   ) async {
//     try {
//       final existingLease = await databaseService.getLeaseById(id);
//       if (existingLease == null) {
//         return Left(NotFoundFailure('Lease not found'));
//       }
//
//       if (newEndDate.isBefore(existingLease.endDate)) {
//         return Left(
//           ValidationFailure('New end date cannot be before current end date'),
//         );
//       }
//
//       final renewedLease = existingLease.copyWith(
//         endDate: newEndDate,
//         status: LeaseStatus.renewed,
//         updatedAt: DateTime.now(),
//       );
//
//       final leaseModel = LeaseModel.fromEntity(renewedLease);
//       final updatedLease = await databaseService.updateLease(leaseModel);
//       return Right(updatedLease);
//     } on DatabaseException catch (e) {
//       return Left(DatabaseFailure(e.message));
//     } on ValidationException catch (e) {
//       return Left(ValidationFailure(e.message));
//     } catch (e) {
//       return Left(UnknownFailure('Failed to renew lease: ${e.toString()}'));
//     }
//   }
// }
//
