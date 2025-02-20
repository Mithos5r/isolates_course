import 'dart:isolate';

import 'package:fpdart/fpdart.dart';
import 'package:isolates_course/datasource/todos_datasource.dart';

final class IsolateRepositoryCallable {
  final Stream<dynamic> broadcastReceivePort;

  final SendPort communicateIsolatePort;

  const IsolateRepositoryCallable({
    required this.broadcastReceivePort,
    required this.communicateIsolatePort,
  });

  static Future<IsolateRepositoryCallable> create(
      {required TodosDatasource datasource}) async {
    final ReceivePort receivePort = ReceivePort();
    Isolate.spawn(_communicator, receivePort.sendPort);

    final broadcastReceivePort = receivePort.asBroadcastStream();

    final SendPort communicateIsolatePort = await broadcastReceivePort
        .takeWhile((element) => element is SendPort)
        .cast<SendPort>()
        .first;

    communicateIsolatePort.send(datasource);

    return IsolateRepositoryCallable(
      broadcastReceivePort: broadcastReceivePort,
      communicateIsolatePort: communicateIsolatePort,
    );
  }

  static void _communicator(SendPort sendPort) async {
    final ReceivePort isolateReceivePort = ReceivePort();
    sendPort.send(isolateReceivePort.sendPort);

    final broadcastIsolateReceivePort = isolateReceivePort.asBroadcastStream();

    final TodosDatasource datasource = await broadcastIsolateReceivePort.first;

    final datasourceParameters = broadcastIsolateReceivePort
        .takeWhile(
          (element) => element is String,
        )
        .cast<String>();

    await for (final parameter in datasourceParameters) {
      try {
        final remote = await datasource.call(parameter);
        sendPort.send(remote);
      } catch (e) {
        sendPort.send('Exception appier');
      }
    }
  }

  Future<Either<String, Iterable<TodoRemote>>> call(
      String repositoryParams) async {
    communicateIsolatePort.send(repositoryParams);

    final response = await broadcastReceivePort.take(1).first;

    if (response is String) {
      return Left(response);
    } else if (response is Iterable<TodoRemote>) {
      return Right(response);
    }
    return Left('Un error a ocurrido');
  }
}
