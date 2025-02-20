import 'dart:isolate';

void main(List<String> arguments) async {
  await for (final msg in getDateTime().take(3)) {
    print(msg);
  }
}

Stream<String> getDateTime() {
  final ReceivePort receivePort = ReceivePort();

  return Isolate.spawn(_getMessages, receivePort.sendPort)
      .asStream()
      .asyncExpand(
        (_) {
          return receivePort;
        },
      )
      .takeWhile(
        (element) => element is String,
      )
      .cast<String>();
}

void _getMessages(SendPort sendPort) async {
  Stream.periodic(
    Duration(milliseconds: 200),
  ).listen(
    (event) => sendPort.send(DateTime.now().toIso8601String()),
  );
}
