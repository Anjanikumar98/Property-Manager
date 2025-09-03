import 'package:dartz/dartz.dart';
import 'package:property_manager/features/tenants/data/datasources/tenant_local_datasource.dart';
import 'package:property_manager/features/tenants/data/models/tenant_model.dart';
import 'package:property_manager/features/tenants/data/repositories/tenant_repository_impl.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/tenant.dart';

class TenantRepositoryImpl implements TenantRepository {
  final TenantLocalDatasource localDatasource;

  TenantRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<Tenant>>> getTenants() async {
    try {
      final tenants = await localDatasource.getTenants();
      return Right(tenants);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Tenant>> getTenantById(String id) async {
    try {
      final tenant = await localDatasource.getTenantById(id);
      return Right(tenant);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Tenant>>> getTenantsByProperty(
    String propertyId,
  ) async {
    try {
      final tenants = await localDatasource.getTenantsByProperty(propertyId);
      return Right(tenants);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Tenant>>> searchTenants(String query) async {
    try {
      final tenants = await localDatasource.searchTenants(query);
      return Right(tenants);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Tenant>> addTenant(Tenant tenant) async {
    try {
      final tenantModel = TenantModel.fromEntity(tenant);
      final result = await localDatasource.addTenant(tenantModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Tenant>> updateTenant(Tenant tenant) async {
    try {
      final tenantModel = TenantModel.fromEntity(tenant);
      final result = await localDatasource.updateTenant(tenantModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTenant(String id) async {
    try {
      await localDatasource.deleteTenant(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateTenant(String id) async {
    try {
      await localDatasource.deactivateTenant(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> activateTenant(String id) async {
    try {
      await localDatasource.activateTenant(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}

