import 'dart:convert';
import 'dart:io';

import 'package:isolates_course/datasource/todos_datasource.dart';

final class TodosRemoteDatasource extends TodosDatasource {
  @override
  Future<Iterable<TodoRemote>> call(String datasourceParameter) async {
    final client = HttpClient();

    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos/');

    return client
        .getUrl(uri)
        .then(
          (value) => value.close(),
        )
        .then(
          (value) => value.transform(utf8.decoder).join(),
        )
        .then(
          (value) => jsonDecode(value) as List<dynamic>,
        )
        .then(
          (value) => value.map(
            (e) => TodoRemote.fromMap(e),
          ),
        );
  }
}
