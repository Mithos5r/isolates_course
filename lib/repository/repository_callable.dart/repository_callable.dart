import 'package:fpdart/fpdart.dart';
import 'package:isolates_course/datasource/todos_datasource.dart';

final class RepositoryCallable {
  final TodosDatasource datasource;

  const RepositoryCallable({required this.datasource});

  Future<Either<String, Iterable<TodoRemote>>> call(
      String repositoryParams) async {
    try {
      final response = await datasource.call(repositoryParams);
      return Right(response);
    } catch (e) {
      return Left('Exception appier');
    }
  }
}
