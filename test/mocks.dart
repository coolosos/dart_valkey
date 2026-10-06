// ignore_for_file: unreachable_from_main, close_sinks test

import 'dart:async';
import 'dart:io';

import 'package:dart_valkey/dart_valkey.dart';
import 'package:dart_valkey/src/connection/base_connection.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  Socket,
  StreamSubscription,
  Connection,
  Stream,
  Resp2Decoder,
  Resp3Decoder,
  ValkeyCommandClient,
  ValkeySubscriptionClient,
])
void main() {}

class TestConnection extends BaseConnection {
  new({super.onConnected, super.onData, super.onDone, super.onError})
    : super(respDecoder: const Resp3Decoder());

  late Socket socketToReturn;

  @override
  Future<Socket> performSocketConnection() async {
    return socketToReturn;
  }
}

base class FakeCommand<T> extends ValkeyCommand<T> {
  new({required this.fakeEncoded, required this.fakeResult});

  /// The encoded bytes that will be sent via _send.
  final List<int> fakeEncoded;

  /// The value to return when `parse` is called.
  final T fakeResult;

  /// Dummy command parts to satisfy the abstract property.
  @override
  List<String> get commandParts => ['FAKE'];

  /// Returns the fake encoded data to be sent.
  @override
  List<int> get encoded => fakeEncoded;

  /// Returns the fake result for testing purposes.
  @override
  T parse(dynamic data) => fakeResult;
}
