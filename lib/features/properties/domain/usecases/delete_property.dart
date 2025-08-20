import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/property_repository.dart';

class DeleteProperty {
  final PropertyRepository repository;

  DeleteProperty(this.repository);

  Future<Either<Failure, void>> call(String propertyId) async {
    return await repository.deleteProperty(propertyId);
  }
}
