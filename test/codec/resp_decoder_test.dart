import 'dart:async';
import 'dart:convert';

import 'package:dart_valkey/src/codec/resp_decoder.dart';
import 'package:test/test.dart';

void main() {
  group('RespDecoder', () {
    const decoder = Resp3Decoder();

    Future<dynamic> testDecode(String encoded) {
      return Stream.value(utf8.encode(encoded)).transform(decoder).first;
    }

    group('Simple Types', () {
      test('should decode simple string', () {
        expect(testDecode('+OK\r\n'), completion('OK'));
      });

      test('should decode error', () async {
        final aa = await testDecode('-ERR unknown command\r\n');
        expect(aa, isA<RespException>());
        expect((aa as RespException).message, 'ERR unknown command');
      });

      test('should decode integer', () {
        expect(testDecode(':1000\r\n'), completion(1000));
      });
    });

    group('Bulk Strings', () {
      test('should decode bulk string', () {
        expect(testDecode('\$6\r\nfoobar\r\n'), completion('foobar'));
      });

      test('should decode empty bulk string', () {
        expect(testDecode('\$0\r\n\r\n'), completion(''));
      });

      test('should decode null bulk string', () {
        expect(testDecode('\$-1\r\n'), completion(isNull));
      });
    });

    group('Arrays', () {
      test('should decode array of bulk strings', () {
        expect(
          testDecode('*2\r\n\$3\r\nfoo\r\n\$3\r\nbar\r\n'),
          completion(['foo', 'bar']),
        );
      });

      test('should decode empty array', () {
        expect(testDecode('*0\r\n'), completion([]));
      });

      test('should decode null array', () {
        expect(testDecode('*-1\r\n'), completion(isNull));
      });

      test('should decode array with null element', () {
        expect(
          testDecode('*3\r\n\$3\r\nfoo\r\n\$-1\r\n\$3\r\nbar\r\n'),
          completion(['foo', null, 'bar']),
        );
      });

      test('should decode nested arrays', () {
        expect(
          testDecode('*2\r\n*3\r\n:1\r\n:2\r\n:3\r\n*2\r\n+Foo\r\n+Bar\r\n'),
          completion([
            [1, 2, 3],
            ['Foo', 'Bar'],
          ]),
        );
      });
    });

    group('BigNumber', () {
      test('should decode positive big number', () async {
        final result = await testDecode(
          '(34928903284092385093248509438509438250\r\n',
        );
        expect(result, BigInt.parse('34928903284092385093248509438509438250'));
      });

      test('should decode negative big number', () async {
        final result = await testDecode(
          '(-34928903284092385093248509438509438250\r\n',
        );
        expect(result, BigInt.parse('-34928903284092385093248509438509438250'));
      });
    });

    group('Verbatim Strings', () {
      test('should decode a verbatim string', () async {
        final result = await testDecode('=15\r\ntxt:Some string\r\n');
        expect(result, 'txt:Some string');
      });
    });

    group('Maps', () {
      test('should decode a map', () async {
        final result = await testDecode(
          '%2\r\n+first\r\n:1\r\n+second\r\n:2\r\n',
        );
        expect(result, {'first': 1, 'second': 2});
      });

      test('should decode a map with different value types', () async {
        final result = await testDecode(
          '%3\r\n+first\r\n:1\r\n+second\r\n#t\r\n+third\r\n,1.23\r\n',
        );
        expect(result, {'first': 1, 'second': true, 'third': 1.23});
      });
    });

    group('Sets', () {
      test('should decode a set', () async {
        final result = await testDecode(
          '~5\r\n+orange\r\n+apple\r\n:100\r\n+orange\r\n#t\r\n',
        );
        expect(result, {'orange', 'apple', 100, true});
      });

      test('should decode a set with different value types', () async {
        final result = await testDecode(
          '~4\r\n+apple\r\n:1\r\n#f\r\n,4.56\r\n',
        );
        expect(result, {'apple', 1, false, 4.56});
      });
    });

    group('Push', () {
      test('should decode a push message', () async {
        final result = await testDecode(
          '>4\r\n+pubsub\r\n+message\r\n+some-channel\r\n+some-message\r\n',
        );
        expect(result, ['pubsub', 'message', 'some-channel', 'some-message']);
      });
    });

    group('Boolean', () {
      test('should decode a boolean true', () async {
        final result = await testDecode('#t\r\n');
        expect(result, true);
      });

      test('should decode a boolean false', () async {
        final result = await testDecode('#f\r\n');
        expect(result, false);
      });
    });

    group('Double', () {
      test('should decode a double', () async {
        final result = await testDecode(',1.23\r\n');
        expect(result, 1.23);
      });
    });

    group('Null', () {
      test('should decode null', () async {
        final result = await testDecode('_\r\n');
        expect(result, isNull);
      });
      test(
        'should throw RespException for invalid bulk string length',
        () async {
          expect(testDecode('\$-2\r\n'), throwsA(isA<RespException>()));
        },
      );
    });
  });
}
