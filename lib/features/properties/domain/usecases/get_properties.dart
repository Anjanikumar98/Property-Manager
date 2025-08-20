import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/property.dart';
import '../repositories/property_repository.dart';

class GetProperties {
  final PropertyRepository repository;

  GetProperties(this.repository);

  Future<Either<Failure, List<Property>>> call(String ownerId) async {
    return await repository.getProperties(ownerId);
  }
}
