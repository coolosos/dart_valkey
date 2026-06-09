import 'dart:async';

import 'package:dart_valkey/src/client/valkey_client.dart';
import 'package:dart_valkey/src/commands/commands.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';

void main() {
  group('ValkeyCommandClient', () {
    late ValkeyCommandClient client;
    late MockConnection mockConnection;

    setUp(() {
      mockConnection = MockConnection();
      client = ValkeyCommandClient(
        host: 'localhost',
        port: 6379,
        connection: mockConnection,
        commandTimeout: null,
      );
    });

    test('connect should call connection.connect when not connected', () async {
      when(mockConnection.isConnected).thenReturn(false);
      when(mockConnection.connect()).thenAnswer((_) async {});

      await client.connect();

      verify(mockConnection.connect()).called(1);
    });

    test('connect should not call connection.connect when already connected',
        () async {
      when(mockConnection.isConnected).thenReturn(true);

      await client.connect();

      verifyNever(mockConnection.connect());
    });

    test('close should call connection.close', () async {
      when(mockConnection.close()).thenAnswer((_) async {});

      await client.close();

      verify(mockConnection.close()).called(1);
    });

    test('execute should send command over connection', () {
      final command = PingCommand();
      // We don't care about the result, just that send is called
      unawaited(client.execute(command));
      verify(mockConnection.send(command.encoded)).called(1);
    });
  });
}
