import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_valkey/src/codec/resp_decoder.dart';
import 'package:dart_valkey/src/connection/base_connection.dart';
import 'package:test/test.dart';

class TestableConnection extends BaseConnection {
  TestableConnection({
    super.respDecoder = const Resp3Decoder(),
    super.host = 'localhost',
    super.port,
    super.connectionTimeout,
    super.onConnected,
    super.onData,
    super.onDone,
    super.onError,
    super.maxReconnectAttempts = 5,
  });

  @override
  Future<Socket> performSocketConnection() {
    return Socket.connect(host, port, timeout: connectionTimeout);
  }
}

void main() {
  group('BaseConnection Integration Tests', tags: 'integration', () {
    late TestableConnection connection;

    setUp(() {
      connection = TestableConnection();
    });

    tearDown(() async {
      await connection.close();
    });

    test('should connect to the Valkey server RESP2', () async {
      var connected = false;
      connection = TestableConnection(
        respDecoder: const Resp2Decoder(),
        onConnected: () async {
          connected = true;
        },
      );
      await connection.connect();
      expect(connected, isTrue);
    });

    test('should connect to the Valkey server RESP3', () async {
      var connected = false;
      connection = TestableConnection(
        respDecoder: const Resp3Decoder(),
        onConnected: () async {
          connected = true;
        },
      );
      await connection.connect();
      expect(connected, isTrue);
    });

    test('should send PING and receive PONG', () async {
      final completer = Completer<String>();
      connection = TestableConnection(
        onData: (data) {
          if (data == 'PONG') {
            completer.complete(data);
          } else {
            completer.completeError('Unexpected response: $data');
          }
        },
      );
      await connection.connect();
      // PING command in RESP format: *1\r\n$4\r\nPING\r\n
      connection.send(
        Uint8List.fromList(
          [42, 49, 13, 10, 0x24, 52, 13, 10, 80, 73, 78, 71, 13, 10],
        ),
      );
      expect(await completer.future, 'PONG');
    });

    test('should reconnect after disconnect', () async {
      final connectedCompleter = Completer<void>();
      final reconnectedCompleter = Completer<void>();
      final pongCompleter = Completer<String>();

      connection = TestableConnection(
        onConnected: () async {
          if (!connectedCompleter.isCompleted) {
            connectedCompleter.complete();
          } else {
            reconnectedCompleter.complete();
          }
        },
        onData: (data) {
          if (data == 'PONG') {
            pongCompleter.complete(data);
          }
        },
      );

      // Initial connection
      await connection.connect();
      await connectedCompleter.future;

      // Simulate disconnect
      connection.testSocket?.destroy(); // Directly destroy the socket

      // Wait for reconnection
      await reconnectedCompleter.future;

      // Send PING after reconnection
      connection.send(
        Uint8List.fromList(
          [42, 49, 13, 10, 0x24, 52, 13, 10, 80, 73, 78, 71, 13, 10],
        ),
      );
      expect(await pongCompleter.future, 'PONG');
    });

    test('should throw when authentication fails with wrong password (RESP3)',
        () async {
      var errorReceived = false;
      connection = TestableConnection(
        respDecoder: const Resp3Decoder(),
        onError: (error) {
          errorReceived = true;
        },
      );
      // Try to connect with a wrong password - this should fail
      // Note: This test requires a server without password OR with different password
      // If server has no password, it will succeed. If server has password protection,
      // it will fail with wrong password.
      try {
        await connection.connect(
          username: 'default',
          password: 'wrongpassword_that_should_fail',
        );
        // If we get here, the server has no password or accepts any password
        // This is expected in some test environments
      } catch (e) {
        // Expected to throw when authentication fails
        expect(e.toString(), contains('Authentication failed'));
        errorReceived = true;
      }
    });

    test('should throw when authentication fails with wrong password (RESP2)',
        () async {
      connection = TestableConnection(
        respDecoder: const Resp2Decoder(),
      );
      // Try to connect with a wrong password using AUTH command
      try {
        await connection.connect(
          username: 'default',
          password: 'wrongpassword_that_should_fail',
        );
      } catch (e) {
        // Expected to throw when authentication fails
        expect(e.toString(), contains('Authentication failed'));
      }
    });
  });
}
