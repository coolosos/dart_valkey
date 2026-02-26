import 'dart:async';

import 'package:dart_valkey/dart_valkey.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../mocks.mocks.dart';

base class FakeFailingCommand extends FakeCommand<String> {
  FakeFailingCommand() : super(fakeEncoded: [1], fakeResult: 'wont happen');

  @override
  String parse(dynamic data) {
    throw Exception('Parse error!');
  }
}

void main() {
  group('ValkeyCommandClient', () {
    late MockConnection mockConnection;
    late ValkeyCommandClient client;

    setUp(() {
      mockConnection = MockConnection();
      client = ValkeyCommandClient(
        host: 'localhost',
        port: 6379,
        connection: mockConnection,
      );
      when(mockConnection.isConnected).thenReturn(false);
      when(mockConnection.connect()).thenAnswer((_) async {
        when(mockConnection.isConnected).thenReturn(true);
      });
    });

    test('should create client with secure true', () {
      ValkeyCommandClient(
        host: 'localhost',
        port: 6379,
        secure: true,
      );
    });

    test('should create client with secure false', () {
      ValkeyCommandClient(
        host: 'localhost',
        port: 6379,
        secure: false,
      );
    });

    test('execute should enqueue command and send encoded data', () async {
      final command = FakeCommand(fakeEncoded: [1, 2, 3], fakeResult: 'OK');

      unawaited(client.execute(command));

      verify(mockConnection.send([1, 2, 3])).called(1);
    });

    test('_onData should complete the first queued command', () async {
      final command = FakeCommand(fakeEncoded: [1], fakeResult: 'OK');
      final future = client.execute(command);

      client.handleDataMock('OK'); // helper to call _onData

      expect(await future, equals('OK'));
    });

    test('connect should not reconnect if already connected', () async {
      // Connect once in setUp
      await client.connect();
      // Connect again
      await client.connect();

      verify(mockConnection.connect()).called(1);
    });

    test('onDone should complete pending commands with an error', () {
      final command = FakeCommand(fakeEncoded: [1], fakeResult: 'OK');
      final future = client.execute(command);

      client.handleDoneMock();

      expect(future, throwsA(isA<StateError>()));
    });

    test('onError should complete pending commands with an error', () {
      final command = FakeCommand(fakeEncoded: [1], fakeResult: 'OK');
      final future = client.execute(command);
      final error = Exception('Network error');

      client.handleErrorMock(error);

      expect(future, throwsA(equals(error)));
    });

    test('_onData should complete with error if command parsing fails', () {
      final command = FakeFailingCommand();
      final future = client.execute(command);

      client.handleDataMock('some data');

      expect(future, throwsA(isA<Exception>()));
    });

    group('with keyPrefix', () {
      late ValkeyCommandClient clientWithPrefix;

      setUp(() {
        clientWithPrefix = ValkeyCommandClient(
          host: 'localhost',
          port: 6379,
          connection: mockConnection,
          keyPrefix: 'test:',
        );
        when(mockConnection.isConnected).thenReturn(true);
      });

      test('should apply prefix to KeyCommands', () {
        final command = GetCommand('mykey');
        final prefixedCommand = GetCommand('test:mykey');

        when(mockConnection.send(any)).thenReturn(null);

        clientWithPrefix.execute(command);

        verify(mockConnection.send(prefixedCommand.encoded)).called(1);
      });
    });

    group('_onConnected (simpler test)', () {
      late ValkeyCommandClient client;
      late MockConnection mockConnection;

      setUp(() {
        mockConnection = MockConnection();
        client = ValkeyCommandClient(
          host: 'localhost',
          port: 6379,
          connection: mockConnection,
        );
      });

      test('should call execute for SelectCommand and resend queued commands',
          () async {
        final command = FakeCommand(fakeEncoded: [1, 2, 3], fakeResult: 'OK');

        Future.delayed(
          const Duration(),
          () => client.handleDataMock('ok'),
        );

        await client.execute(command);
        client.handleDataMock('ok');
        Future.delayed(
          const Duration(),
          () => client.handleDataMock('ok'),
        );
        unawaited(client.handleOnConnectedMock());
        Future.delayed(
          const Duration(),
          () => client.handleDataMock('ok'),
        );
        await client.execute(command);

        verify(mockConnection.send(command.encoded)).called(3);
        verify(mockConnection.send(argThat(isA<List<int>>()))).called(1);
      });
    });
  });

  group('ValkeySubscriptionClient', () {
    late ValkeySubscriptionClient subClient;
    late MockConnection mockConnection;

    setUp(() {
      mockConnection = MockConnection();
      subClient = ValkeySubscriptionClient(
        host: 'localhost',
        port: 6379,
        connection: mockConnection,
      );
    });

    test('onData should emit message events', () async {
      final messages = <PubSubMessage>[];
      subClient.messages.listen(messages.add);

      subClient.handleDataMock(['message', 'channel1', 'hello']);

      await Future.delayed(const Duration());

      expect(messages.first.message, equals('hello'));
    });

    test('onData with unknown type should emit error', () async {
      Object? receivedError;
      subClient.messages.listen(null, onError: (e) => receivedError = e);

      subClient.handleDataMock(['wtf', '???']);
      await Future.delayed(const Duration());

      expect(receivedError, isA<ValkeyException>());
    });

    group('_onData', () {
      test('should handle "message" type', () async {
        final data = ['message', 'channel1', 'hello'];
        final expectation = expectLater(
          subClient.messages,
          emits(
            isA<PubSubMessage>()
                .having((m) => m.type, 'type', 'message')
                .having((m) => m.channel, 'channel', 'channel1')
                .having((m) => m.message, 'message', 'hello'),
          ),
        );
        subClient.handleDataMock(data);
        await expectation;
      });

      test('should handle "pmessage" type', () async {
        final data = ['pmessage', 'patt*', 'channel2', 'world'];
        final expectation = expectLater(
          subClient.messages,
          emits(
            isA<PubSubMessage>()
                .having((m) => m.type, 'type', 'pmessage')
                .having((m) => m.pattern, 'pattern', 'patt*')
                .having((m) => m.channel, 'channel', 'channel2')
                .having((m) => m.message, 'message', 'world'),
          ),
        );
        subClient.handleDataMock(data);
        await expectation;
      });

      test('should handle "smessage" type', () async {
        final data = ['smessage', 'shard-channel', 'shard-message'];
        final expectation = expectLater(
          subClient.messages,
          emits(
            isA<PubSubMessage>()
                .having((m) => m.type, 'type', 'smessage')
                .having((m) => m.channel, 'channel', 'shard-channel')
                .having((m) => m.message, 'message', 'shard-message'),
          ),
        );
        subClient.handleDataMock(data);
        await expectation;
      });

      test('should handle "subscribe" type', () async {
        final data = ['subscribe', 'channel1', 1];
        final expectation = expectLater(
          subClient.messages,
          emits(
            isA<PubSubMessage>()
                .having((m) => m.type, 'type', 'subscribe')
                .having((m) => m.channel, 'channel', 'channel1')
                .having((m) => m.count, 'count', 1),
          ),
        );
        subClient.handleDataMock(data);
        await expectation;
      });

      test('should handle unknown type with an error', () async {
        final data = ['unknown', 'some', 'data'];
        final expectation = expectLater(
          subClient.messages,
          emitsError(isA<ValkeyException>()),
        );
        subClient.handleDataMock(data);
        await expectation;
      });
    });

    group('RegularSubscriptionMixin', () {
      test('subscribe should send subscribe command', () {
        subClient.subscribe(['channel1', 'channel2']);
        verify(mockConnection.send(any)).called(1);
      });

      test('unsubscribe should send unsubscribe command', () {
        subClient
          ..subscribe(['channel1'])
          ..unsubscribe(['channel1']);
        verify(mockConnection.send(any)).called(2);
      });

      test(
          'unsubscribe with no channels should not send command if not subscribed',
          () {
        subClient.unsubscribe();
        verifyNever(mockConnection.send(any));
      });

      test('subscribedChannels should return list of subscribed channels', () {
        subClient.subscribe(['channel1', 'channel2']);
        expect(
          subClient.subscribedChannels,
          containsAll(['channel1', 'channel2']),
        );
      });
    });

    group('PatternSubscriptionMixin', () {
      test('psubscribe should send psubscribe command', () {
        subClient.psubscribe(['patt*']);
        verify(mockConnection.send(any)).called(1);
      });

      test('punsubscribe should send punsubscribe command', () {
        subClient
          ..psubscribe(['patt*'])
          ..punsubscribe(['patt*']);
        verify(mockConnection.send(any)).called(2);
      });

      test(
          'punsubscribe with no patterns should not send command if not subscribed',
          () {
        subClient.punsubscribe();
        verifyNever(mockConnection.send(any));
      });

      test('subscribedPatterns should return list of subscribed patterns', () {
        subClient.psubscribe(['pattern*']);
        expect(subClient.subscribedPatterns, contains('pattern*'));
      });
    });

    group('ShardSubscriptionMixin', () {
      test('ssubscribe should send ssubscribe command', () {
        subClient.ssubscribe(['shard-channel']);
        verify(mockConnection.send(any)).called(1);
      });

      test('sunsubscribe should send sunsubscribe command', () {
        subClient
          ..ssubscribe(['shard-channel'])
          ..sunsubscribe(['shard-channel']);
        verify(mockConnection.send(any)).called(2);
      });

      test(
          'sunsubscribe with no channels should not send command if not subscribed',
          () {
        subClient.sunsubscribe();
        verifyNever(mockConnection.send(any));
      });

      test(
          'subscribedShardChannels should return list of subscribed shard channels',
          () {
        subClient.ssubscribe(['shard-channel']);
        expect(subClient.subscribedShardChannels, contains('shard-channel'));
      });
    });

    group('Lifecycle event handlers', () {
      test('_onError should forward error to message stream', () async {
        final testException = Exception('test error');
        final expectation =
            expectLater(subClient.messages, emitsError(testException));
        subClient.handleErrorMock(testException);
        await expectation;
      });

      test('_onDone should be callable', () {
        // No real way to test the outcome without a pending command future,
        // but we can call it for coverage.
        subClient.handleDoneMock();
      });
    });

    test('close should close the connection and message stream', () async {
      when(mockConnection.close()).thenAnswer((_) async {});
      await subClient.close();
      verify(mockConnection.close()).called(1);
    });

    test('_onConnected should resubscribe after reconnection', () async {
      when(mockConnection.send(any)).thenAnswer((_) async {});

      subClient.subscribe(['channel1']);
      await subClient.handleOnConnectedMock();
    });

    test('_onConnected should resubscribe to shard channels after reconnection',
        () async {
      when(mockConnection.send(any)).thenAnswer((_) async {});

      subClient.ssubscribe(['shard-channel']);
      await subClient.handleOnConnectedMock();
    });
  });
}
