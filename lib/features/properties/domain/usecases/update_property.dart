import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/property.dart';
import '../repositories/property_repository.dart';

class UpdateProperty {
  final PropertyRepository repository;

  UpdateProperty(this.repository);

  Future<Either<Failure, void>> call(Property property) async {
    return await repository.updateProperty(property);
  }
}
