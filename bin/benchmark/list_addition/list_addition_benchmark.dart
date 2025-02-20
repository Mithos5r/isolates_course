import 'dart:io';

import 'package:meta/meta.dart';

import 'package:benchmark_harness/benchmark_harness.dart';

void main(List<String> args) async {
  AddBenchmark().report();
  MergeListBenchmark().report();
  MergeLisOneItemBenchmark().report();
  AddOneItemBenchmark().report();
  exit(0);
}

base class AdditionInListBenchmark extends BenchmarkBase {
  AdditionInListBenchmark(super.name);

  List<Map<String, dynamic>> iterable = [];
  late final List<Map<String, dynamic>> additions;

  @mustCallSuper
  @override
  void setup() {
    additions = List.generate(
      100,
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

final class AddBenchmark extends AdditionInListBenchmark {
  AddBenchmark() : super("Multiple items .add(): ");

  @override
  void run() async {
    for (var i = 0; i < additions.length; i++) {
      iterable.add(additions[i]);
    }
  }
}

final class MergeListBenchmark extends AdditionInListBenchmark {
  MergeListBenchmark() : super("Multiples items [..., new]: ");

  @override
  void run() async {
    List<Map<String, dynamic>> iterable = [];
    for (var i = 0; i < additions.length; i++) {
      iterable = [...iterable, additions[i]];
    }
  }
}

final class MergeLisOneItemBenchmark extends AdditionInListBenchmark {
  MergeLisOneItemBenchmark() : super("One item [..., new]: ");

  @override
  void run() async {
    [
      ...additions,
      {"userId": 1, "id": 1, "title": "delectus aut autem", "completed": false}
    ];
  }
}

final class AddOneItemBenchmark extends AdditionInListBenchmark {
  AddOneItemBenchmark() : super("One item .add(): ");

  @override
  void run() async {
    additions.add({
      "userId": 1,
      "id": 1,
      "title": "delectus aut autem",
      "completed": false
    });
  }
}
