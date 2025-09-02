import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'login_user.dart';


class RegisterUser implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      role: params.role,
    );
  }
}

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final UserRole role;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}
