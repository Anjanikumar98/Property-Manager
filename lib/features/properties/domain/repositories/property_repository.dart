import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/property.dart';

abstract class PropertyRepository {
  Future<Either<Failure, List<Property>>> getProperties(String ownerId);
  Future<Either<Failure, Property>> getPropertyById(String id);
  Future<Either<Failure, String>> addProperty(Property property);
  Future<Either<Failure, void>> updateProperty(Property property);
  Future<Either<Failure, void>> deleteProperty(String id);
  Future<Either<Failure, List<Property>>> getPropertiesByStatus(
    String ownerId,
    PropertyStatus status,
  );
}
