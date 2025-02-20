import 'remote_object/todo_remote.dart';
export 'remote_object/todo_remote.dart';

abstract base class TodosDatasource {
  Future<Iterable<TodoRemote>> call(String datasourceParameter);
}
