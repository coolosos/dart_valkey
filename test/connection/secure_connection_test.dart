import 'package:dart_valkey/src/codec/resp_decoder.dart';
import 'package:dart_valkey/src/connection/secure_connection.dart';
import 'package:test/test.dart';

void main() {
  group('SecureConnection', tags: 'integration', () {
    test('can be instantiated without onBadCertificate', () {
      const respDecoder = Resp3Decoder(); // Dummy decoder
      final connection = SecureConnection(respDecoder: respDecoder);
      expect(connection, isA<SecureConnection>());
    });

    test('can be instantiated with onBadCertificate', () {
      const respDecoder = Resp3Decoder(); // Dummy decoder
      final connection = SecureConnection(
        respDecoder: respDecoder,
        onBadCertificate: (cert) => true,
      );
      expect(connection, isA<SecureConnection>());
    });
  });
}
