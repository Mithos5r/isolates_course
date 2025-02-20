import 'dart:io';
import 'package:isolates_course/datasource/todos_datasource.dart';
import 'package:meta/meta.dart';

import 'package:benchmark_harness/benchmark_harness.dart';

import 'package:isolates_course/repository/repository_callable.dart/repository_callable.dart';

void main(List<String> args) async {
  ForInLoopBenchmark().report();
  MapBenchmark().report();
  MapToListBenchmark().report();
  ForLoopBenchmark().report();
  ForEachBenchmark().report();

  exit(0);
}

base class LoopBenchmark extends BenchmarkBase {
  LoopBenchmark(super.name);

  late List<Map<String, dynamic>> iterable;

  @mustCallSuper
  @override
  void setup() {
    iterable = List.generate(
      10000,
      (index) => {
        "userId": index,
        "id": index,
        "title": "delectus aut autem",
        "completed": false
      },
    );
    super.setup();
  }
}

final class ForInLoopBenchmark extends LoopBenchmark {
  ForInLoopBenchmark() : super("For in loop: ");

  @override
  void run() {
    final List<TodoRemote> list = [];
    for (var todo in iterable) {
      list.add(TodoRemote.fromMap(todo));
    }
  }
}

final class MapToListBenchmark extends LoopBenchmark {
  MapToListBenchmark() : super(".map().toList(): ");

  late RepositoryCallable repository;

  @override
  void run() async {
    iterable
        .map(
          (e) => TodoRemote.fromMap(e),
        )
        .toList();
  }
}

final class MapBenchmark extends LoopBenchmark {
  MapBenchmark() : super(".map(): ");

  late RepositoryCallable repository;

  @override
  void run() async {
    iterable.map(
      (e) => TodoRemote.fromMap(e),
    );
  }
}

final class ForLoopBenchmark extends LoopBenchmark {
  ForLoopBenchmark() : super("for(i;iterable:i--): ");

  late RepositoryCallable repository;

  @override
  void run() async {
    final List<TodoRemote> list = [];
    for (var i = 0; i < iterable.length; i++) {
      list.add(TodoRemote.fromMap(iterable[i]));
    }
  }
}

final class ForEachBenchmark extends LoopBenchmark {
  ForEachBenchmark() : super("forEach");

  late RepositoryCallable repository;

  @override
  void run() async {
    final List<TodoRemote> list = [];
    // ignore: avoid_function_literals_in_foreach_calls
    iterable.forEach(
      (element) => list.add(TodoRemote.fromMap(element)),
    );
  }
}
