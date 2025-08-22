// lib/features/properties/data/repositories/property_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/property_local_datasource.dart';
import '../models/property_model.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyLocalDataSource localDataSource;

  PropertyRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Property>>> getProperties(String ownerId) async {
    try {
      final properties = await localDataSource.getProperties(ownerId);
      return Right(properties);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(
        DatabaseFailure('Unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Property>> getPropertyById(String id) async {
    try {
      final property = await localDataSource.getPropertyById(id);
      return Right(property);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(
        DatabaseFailure('Unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> addProperty(Property property) async {
    try {
      // Validate property data
      final validationResult = _validateProperty(property);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      final propertyModel = PropertyModel.fromEntity(property);
      final propertyId = await localDataSource.addProperty(propertyModel);
      return Right(propertyId);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(
        DatabaseFailure('Unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateProperty(Property property) async {
    try {
      // Validate property data
      final validationResult = _validateProperty(property);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      if (property.id == null || property.id!.isEmpty) {
        return Left(ValidationFailure('Property ID is required for update'));
      }

      final propertyModel = PropertyModel.fromEntity(property);
      await localDataSource.updateProperty(propertyModel);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(
        DatabaseFailure('Unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteProperty(String id) async {
    try {
      if (id.isEmpty) {
        return Left(ValidationFailure('Property ID cannot be empty'));
      }

      await localDataSource.deleteProperty(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(
        DatabaseFailure('Unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Property>>> getPropertiesByStatus(
    String ownerId,
    PropertyStatus status,
  ) async {
    try {
      final properties = await localDataSource.getPropertiesByStatus(
        ownerId,
        status,
      );
      return Right(properties);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(
        DatabaseFailure('Unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  // Private validation method
  String? _validateProperty(Property property) {
    if (property.name.trim().isEmpty) {
      return 'Property name is required';
    }

    if (property.address.trim().isEmpty) {
      return 'Property address is required';
    }

    if (property.city.trim().isEmpty) {
      return 'City is required';
    }

    if (property.state.trim().isEmpty) {
      return 'State is required';
    }

    if (property.state.length != 2) {
      return 'State must be 2 characters';
    }

    if (property.zipCode.trim().isEmpty) {
      return 'Zip code is required';
    }

    if (property.zipCode.length != 5) {
      return 'Zip code must be 5 digits';
    }

    if (property.bedrooms < 0) {
      return 'Bedrooms cannot be negative';
    }

    if (property.bathrooms < 0) {
      return 'Bathrooms cannot be negative';
    }

    if (property.squareFeet <= 0) {
      return 'Square feet must be greater than 0';
    }

    if (property.monthlyRent < 0) {
      return 'Monthly rent cannot be negative';
    }

    if (property.securityDeposit < 0) {
      return 'Security deposit cannot be negative';
    }

    if (property.ownerId.trim().isEmpty) {
      return 'Owner ID is required';
    }

    return null;
  }
}

