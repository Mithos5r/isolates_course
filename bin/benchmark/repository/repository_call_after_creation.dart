import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:isolates_course/datasource/todos_local_datasource.dart';

import 'package:isolates_course/repository/isolate_repository_callable/isolate_repository_callable.dart';
import 'package:isolates_course/repository/repository_callable.dart/repository_callable.dart';

void main(List<String> args) async {
  //Local data

  RepositoryLocalBenchmark().report();
  RepositoryIsolateLocalBenchmark().report();
  exit(0);
}

class RepositoryIsolateLocalBenchmark extends BenchmarkBase {
  RepositoryIsolateLocalBenchmark()
      : super("Repository Local with isolate | Call");

  late IsolateRepositoryCallable repository;

  @override
  void setup() async {
    repository = await IsolateRepositoryCallable.create(
        datasource: TodosLocalDatasource());
    super.setup();
  }

  @override
  void run() async {
    await repository.call('Prueba');
  }
}

class RepositoryLocalBenchmark extends BenchmarkBase {
  RepositoryLocalBenchmark() : super("Repository | Call");

  late RepositoryCallable repository;

  @override
  void setup() {
    repository = RepositoryCallable(datasource: TodosLocalDatasource());
    super.setup();
  }

  @override
  void run() async {
    await repository.call('Prueba');
  }
}
