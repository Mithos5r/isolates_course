import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

void main(List<String> args) async {
  final ReceivePort receivePort = ReceivePort();
  final todos =
      await Isolate.spawn(_parseJsonIsolateEntry, receivePort.sendPort)
          .asStream()
          .asyncExpand(
            (_) => receivePort,
          )
          .takeWhile(
            (element) => element is Iterable<TodoRemote>,
          )
          .cast<Iterable<TodoRemote>>()
          .take(1)
          .first;

  print(todos.toList().toString());
}

void _parseJsonIsolateEntry(SendPort sendPort) async {
  final client = HttpClient();

  final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos/');

  final remote = await client
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

  sendPort.send(remote);
}

class TodoRemote {
  const TodoRemote({
    required this.userId,
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  final int userId;
  final int id;
  final String title;
  final bool isCompleted;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory TodoRemote.fromMap(Map<String, dynamic> map) {
    return TodoRemote(
      userId: map['userId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
      isCompleted: map['completed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'TodoRemote(userId: $userId, id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
