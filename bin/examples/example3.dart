import 'dart:convert';
import 'dart:isolate';
import 'package:collection/collection.dart';
import 'dart:io';

void main(List<String> args) async {
  final Responder responder = await Responder.create();
  do {
    stdout.write('Say something:');
    final line = stdin.readLineSync(encoding: utf8);
    switch (line?.trim().toLowerCase()) {
      case null:
        continue;
      case 'exit':
        exit(0);
      default:
        final msg = await responder.getMessage(line!);
        print(msg);
    }
  } while (true);
}

final class Responder {
  final SendPort isolateSendPort;
  final Stream<dynamic> broadcastReceivePort;

  const Responder._({
    required this.isolateSendPort,
    required this.broadcastReceivePort,
  });

  static Future<Responder> create() async {
    final ReceivePort receivePort = ReceivePort();
    Isolate.spawn(_communicator, receivePort.sendPort);

    final broadcastReceivePort = receivePort.asBroadcastStream();

    final SendPort isolateSendPort = await broadcastReceivePort.first;

    return Responder._(
      isolateSendPort: isolateSendPort,
      broadcastReceivePort: broadcastReceivePort,
    );
  }

  Future<String> getMessage(String forGreeting) async {
    isolateSendPort.send(forGreeting);

    return broadcastReceivePort
        .takeWhile(
          (element) => element is String,
        )
        .cast<String>()
        .take(1)
        .first;
  }
}

void _communicator(SendPort sendPort) async {
  final ReceivePort receivePort = ReceivePort("Isolate receivePort");
  sendPort.send(receivePort.sendPort);

  final messages = receivePort
      .takeWhile(
        (element) => element is String,
      )
      .cast<String>();

  await for (final message in messages) {
    final response = messagesAndResponses.entries
            .firstWhereOrNull(
              (entry) =>
                  entry.key.trim().toLowerCase() ==
                  message.trim().toLowerCase(),
            )
            ?.value ??
        'I have not responses for that!';

    sendPort.send(response);
  }
}

const messagesAndResponses = {
  '': 'Ask me a question like "How are you?"',
  'Hello': 'Hi',
  'How are you?': 'Fine',
  'What are you doing?': 'Learning about Isolates in Dart!',
  'Are you having fun?': 'Yeah sure!',
};
