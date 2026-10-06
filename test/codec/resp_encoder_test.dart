import 'dart:typed_data';

import 'package:dart_valkey/src/codec/resp_encoder.dart';
import 'package:test/test.dart';

void main() {
  group('RespEncoder', () {
    test('should encode a simple command', () {
      final command = ['PING'];
      final expected = Uint8List.fromList([
        42,
        49,
        13,
        10,
        36,
        52,
        13,
        10,
        80,
        73,
        78,
        71,
        13,
        10,
      ]);
      expect(RespEncoder.encode(command), expected);
    });

    test('should encode a command with multiple arguments', () {
      final command = ['SET', 'mykey', 'myvalue'];
      final expected = Uint8List.fromList([
        42,
        51,
        13,
        10,
        36,
        51,
        13,
        10,
        83,
        69,
        84,
        13,
        10,
        36,
        53,
        13,
        10,
        109,
        121,
        107,
        101,
        121,
        13,
        10,
        36,
        55,
        13,
        10,
        109,
        121,
        118,
        97,
        108,
        117,
        101,
        13,
        10,
      ]);
      expect(RespEncoder.encode(command), expected);
    });

    test('should encode a command with integer argument', () {
      final command = ['INCRBY', 'mycounter', '10'];
      final expected = Uint8List.fromList([
        42,
        51,
        13,
        10,
        36,
        54,
        13,
        10,
        73,
        78,
        67,
        82,
        66,
        89,
        13,
        10,
        36,
        57,
        13,
        10,
        109,
        121,
        99,
        111,
        117,
        110,
        116,
        101,
        114,
        13,
        10,
        36,
        50,
        13,
        10,
        49,
        48,
        13,
        10,
      ]);
      expect(RespEncoder.encode(command), expected);
    });

    test('should encode an empty command list', () {
      final command = <Object>[];
      final expected = Uint8List.fromList([42, 48, 13, 10]);
      expect(RespEncoder.encode(command), expected);
    });
  });
}
