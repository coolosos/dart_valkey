import 'package:dart_valkey/src/codec/resp_decoder.dart';
import 'package:dart_valkey/src/connection/insecure_connection.dart';
import 'package:test/test.dart';

void main() {
  group('InsecureConnection', tags: 'integration', () {
    test('can be instantiated', () {
      const respDecoder = Resp3Decoder(); // Dummy decoder
      final connection = InsecureConnection(respDecoder: respDecoder);
      expect(connection, isA<InsecureConnection>());
    });
  });
}
