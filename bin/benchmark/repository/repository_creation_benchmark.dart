import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:isolates_course/datasource/todos_local_datasource.dart';
import 'package:isolates_course/datasource/todos_remote_datasource.dart';
import 'package:isolates_course/repository/isolate_repository_callable/isolate_repository_callable.dart';
import 'package:isolates_course/repository/repository_callable.dart/repository_callable.dart';

void main(List<String> args) async {
  //Local data
  RepositoryLocalBenchmark().report();
  RepositoryIsolateLocalBenchmark().report();

  //Remote call for obtain data
  RepositoryRemoteBenchmark().report();
  RepositoryIsolateRemoteBenchmark().report();

  exit(0);
}

class RepositoryIsolateLocalBenchmark extends BenchmarkBase {
  RepositoryIsolateLocalBenchmark()
      : super("Repository Local with isolate | Creation");

  @override
  void run() async {
    await IsolateRepositoryCallable.create(datasource: TodosLocalDatasource());
  }
}

class RepositoryLocalBenchmark extends BenchmarkBase {
  RepositoryLocalBenchmark() : super("Repository | Creation");

  @override
  void run() async {
    RepositoryCallable(datasource: TodosLocalDatasource());
  }
}

class RepositoryIsolateRemoteBenchmark extends BenchmarkBase {
  RepositoryIsolateRemoteBenchmark()
      : super("Repository remote with isolate | Creation and execution");

  @override
  void run() async {
    await IsolateRepositoryCallable.create(datasource: TodosRemoteDatasource());
  }
}

class RepositoryRemoteBenchmark extends BenchmarkBase {
  RepositoryRemoteBenchmark() : super("Repository | Creation and execution");

  @override
  void run() async {
    RepositoryCallable(datasource: TodosRemoteDatasource());
  }
}
