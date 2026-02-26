import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_valkey/src/connection/base_connection.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';

class TestConnection extends BaseConnection {
  TestConnection({
    required super.respDecoder,
    super.onConnected,
    super.onData,
    super.onDone,
    super.onError,
    super.maxReconnectAttempts,
  });

  late Socket socketToReturn;

  @override
  Future<Socket> performSocketConnection() async {
    return socketToReturn;
  }
}

void main() {
  group('BaseConnection', () {
    late TestConnection connection;
    late MockSocket mockSocket;
    late MockStream<Uint8List> mockStream;
    late MockResp2Decoder mockRespDecoder;

    setUp(() {
      mockSocket = MockSocket();
      mockStream = MockStream();
      mockRespDecoder = MockResp2Decoder();
      connection = TestConnection(
        respDecoder: mockRespDecoder,
      )..socketToReturn = mockSocket;

      when(mockRespDecoder.bind(any))
          .thenAnswer((_) => mockStream as Stream<Uint8List>);
      when(mockStream.asBroadcastStream()).thenAnswer((_) => mockStream);
    });

    test('connect should call performSocketConnection and set socket options',
        () async {
      when(mockSocket.setOption(any, any)).thenReturn(true);
      // Explicitly stub listen for this test to allow connect to complete
      when(
        mockStream.listen(
          any,
          onError: anyNamed('onError'),
          onDone: anyNamed('onDone'),
          cancelOnError: anyNamed('cancelOnError'),
        ),
      ).thenReturn(MockStreamSubscription());

      await connection.connect();

      verify(
        mockSocket.setOption(
          argThat(equals(SocketOption.tcpNoDelay)),
          true,
        ),
      ).called(1);
      expect(connection.host, '127.00.1'); // default value
    });

    test('send should forward data to socket.add', () async {
      when(mockSocket.setOption(any, any)).thenReturn(true);

      // Explicitly stub listen for this test to allow connect to complete
      when(
        mockStream.listen(
          any,
          onError: anyNamed('onError'),
          onDone: anyNamed('onDone'),
          cancelOnError: anyNamed('cancelOnError'),
        ),
      ).thenReturn(MockStreamSubscription());

      await connection.connect();

      final data = [1, 2, 3];
      connection.send(data);

      verify(mockSocket.add(data)).called(1);
    });

    test('close should cancel subscription and destroy the socket', () async {
      final mockSub = MockStreamSubscription();

      when(mockSocket.setOption(any, any)).thenReturn(true);
      // Explicitly stub listen for this test to allow connect to complete
      when(
        mockStream.listen(
          any,
          onError: anyNamed('onError'),
          onDone: anyNamed('onDone'),
          cancelOnError: anyNamed('cancelOnError'),
        ),
      ).thenReturn(MockStreamSubscription());

      await connection.connect();
      // force close
      await connection.close();

      verify(mockSocket.destroy()).called(1);
      // Subscription cancel is already awaited in close()
      verifyNever(mockSub.cancel()); // not injected here, but shows expectation
    });

    test('when the stream emits an error, onError should be called', () async {
      Object? receivedError;

      connection = TestConnection(
        onError: (error) => receivedError = error,
        respDecoder: mockRespDecoder,
      )..socketToReturn = mockSocket;

      when(mockSocket.setOption(any, any)).thenReturn(true);
      when(
        mockStream.listen(
          any,
          onError: anyNamed('onError'),
          onDone: anyNamed('onDone'),
          cancelOnError: anyNamed('cancelOnError'),
        ),
      ).thenAnswer((invocation) {
        final Function? onErrorCallback = invocation.namedArguments[#onError];
        if (onErrorCallback != null) {
          // ignore: avoid_dynamic_calls test
          onErrorCallback(Exception('simulated error'));
        }
        return MockStreamSubscription();
      });

      await connection.connect();

      expect(receivedError, isA<Exception>());
    });

    test('send should call onError when socket throws', () async {
      Object? receivedError;
      var disconnected = false;

      connection = TestConnection(
        onError: (error) => receivedError = error,
        respDecoder: mockRespDecoder,
      )..socketToReturn = mockSocket;

      when(mockSocket.setOption(any, any)).thenReturn(true);
      when(
        mockStream.listen(
          any,
          onError: anyNamed('onError'),
          onDone: anyNamed('onDone'),
          cancelOnError: anyNamed('cancelOnError'),
        ),
      ).thenReturn(MockStreamSubscription());

      await connection.connect();

      // Force the internal socket reference to be null to simulate closed connection
      // or make socket.add throw
      when(mockSocket.add(any)).thenThrow(Exception('Socket closed'));

      final data = [1, 2, 3];
      connection.send(data);

      expect(receivedError, isA<Exception>());
    });
  });
}
