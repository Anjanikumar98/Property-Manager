import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/property.dart';
import '../repositories/property_repository.dart';

class AddProperty {
  final PropertyRepository repository;

  AddProperty(this.repository);

  Future<Either<Failure, String>> call(Property property) async {
    return await repository.addProperty(property);
  }
}
