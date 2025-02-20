import 'package:isolates_course/datasource/todos_datasource.dart';

final class TodosLocalDatasource extends TodosDatasource {
  @override
  Future<Iterable<TodoRemote>> call(String datasourceParameter) async {
    final localData = [
      {"userId": 1, "id": 1, "title": "delectus aut autem", "completed": false},
      {
        "userId": 1,
        "id": 2,
        "title": "quis ut nam facilis et officia qui",
        "completed": false
      },
      {"userId": 1, "id": 3, "title": "fugiat veniam minus", "completed": false}
    ];

    return localData.map(
      (e) => TodoRemote.fromMap(e),
    );
  }
}
