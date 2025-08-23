import 'package:dartz/dartz.dart';
import 'package:property_manager/core/errors/failures.dart';
import '../entities/property.dart';
import '../repositories/property_repository.dart';

class GetProperties {
  final PropertyRepository repository;

  GetProperties(this.repository);

  Future<Either<Failure, List<Property>>> call({String? ownerId}) async {
    // if no ownerId provided, fetch all properties
    return await repository.getProperties(ownerId!);
  }
}
