import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'resp_constants.dart';

typedef ItemParser = ParseResult<dynamic> Function(
  Uint8List buffer,
  int offset,
);

class RespException implements Exception {
  const new(this.message);
  final String message;
  @override
  String toString() => 'RespException: $message';
}

class _IncompleteDataException implements Exception {
  const new();
}

final class ParseResult<T> {
  const new(this.value, this.bytesConsumed);
  final T value;
  final int bytesConsumed;
}

// Base codec class
sealed class BaseRespCodec extends StreamTransformerBase<Uint8List, dynamic> {
  const new();

  @override
  Stream<dynamic> bind(Stream<Uint8List> stream) {
    final controller = StreamController<dynamic>();
    // final buffer = <int>[];
    final bytesBuilder = BytesBuilder(); // Use BytesBuilder
    var offset = 0;

    stream.listen(
      (chunk) {
        bytesBuilder.add(chunk);
        final buffer = bytesBuilder.takeBytes();
        try {
          while (offset < buffer.length) {
            final result = _parse(buffer, offset);
            controller.add(result.value);
            offset += result.bytesConsumed;
          }
        } on _IncompleteDataException {
          // Need more data. Put remaining bytes back into BytesBuilder.
          bytesBuilder.add(
            Uint8List.view(buffer.buffer, offset, buffer.length - offset),
          );
          offset = 0; // Reset offset for next chunk
        } on FormatException catch (e) {
          controller.addError(
            RespException(
              'Protocol parsing error: ${e.message} at offset $offset',
            ),
          );
          bytesBuilder.clear();
          offset = 0;
        } on RespException catch (e) {
          controller.addError(e);
          bytesBuilder.clear();
          offset = 0;
        } catch (e) {
          controller.addError(
            RespException('Unexpected decoder error: $e at offset $offset'),
          );
          bytesBuilder.clear();
          offset = 0;
        }

        if (offset == buffer.length) {
          bytesBuilder.clear();
          offset = 0;
        }
      },
      onError: controller.addError,
      onDone: controller.close,
      cancelOnError: true,
    );

    return controller.stream;
  }

  ParseResult<dynamic> _parse(Uint8List buffer, int offset);
}

// RESP2 helpers
mixin Resp2ParsingHelpers {
  Encoding get encoding => const Utf8Codec();

  String decodeString(Uint8List buffer, int start, int end) =>
      // String.fromCharCodes(buffer, start, end);
      // encoding.decode(buffer.sublist(start, end));
      encoding.decode(Uint8List.view(buffer.buffer, start, end - start));

  int findCRLF(Uint8List buffer, int from) {
    for (var i = from; i < buffer.length - 1; i++) {
      if (buffer[i] == respCarriageReturn && buffer[i + 1] == respLineFeed) {
        return i;
      }
    }
    return -1;
  }

  ParseResult<String> parseSimpleString(Uint8List buffer, int offset) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    return ParseResult(
      decodeString(buffer, offset + 1, crlf),
      crlf - offset + 2,
    );
  }

  ParseResult<RespException> parseError(Uint8List buffer, int offset) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    return ParseResult(
      RespException(decodeString(buffer, offset + 1, crlf)),
      crlf - offset + 2,
    );
  }

  ParseResult<int> parseInteger(Uint8List buffer, int offset) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    return ParseResult(
      int.parse(decodeString(buffer, offset + 1, crlf)),
      crlf - offset + 2,
    );
  }

  ParseResult<String?> parseBulkString(Uint8List buffer, int offset) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    final length = int.parse(decodeString(buffer, offset + 1, crlf));
    if (length == -1) return ParseResult(null, crlf - offset + 2);
    final dataStart = crlf + 2;
    final totalLength = dataStart + length + 2;
    if (buffer.length < totalLength) throw const _IncompleteDataException();
    return ParseResult(
      decodeString(buffer, dataStart, dataStart + length),
      totalLength - offset,
    );
  }

  ParseResult<List<dynamic>?> parseArray(
    Uint8List buffer,
    int offset,
    ItemParser parseItem,
  ) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    final count = int.parse(decodeString(buffer, offset + 1, crlf));
    if (count == -1) return ParseResult(null, crlf - offset + 2);

    final items = <dynamic>[];
    var currentOffset = crlf + 2;
    for (var i = 0; i < count; i++) {
      final result = parseItem(buffer, currentOffset);
      items.add(result.value);
      currentOffset += result.bytesConsumed;
    }
    return ParseResult(items, currentOffset - offset);
  }
}

class Resp2Decoder extends BaseRespCodec with Resp2ParsingHelpers {
  const new();

  @override
  ParseResult<dynamic> _parse(Uint8List buffer, int offset) {
    if (offset >= buffer.length) throw const _IncompleteDataException();
    switch (buffer[offset]) {
      case respSimpleString:
        return parseSimpleString(buffer, offset);
      case respError:
        return parseError(buffer, offset);
      case respInteger:
        return parseInteger(buffer, offset);
      case respBulkString:
        return parseBulkString(buffer, offset);
      case respArray:
        return parseArray(buffer, offset, _parse);
      default:
        throw FormatException(
          'Unknown RESP2 type: ${String.fromCharCode(buffer[offset])}',
        );
    }
  }
}

mixin Resp3ParsingHelpers on Resp2ParsingHelpers {
  ParseResult<bool> parseBoolean(Uint8List buffer, int offset) {
    if (offset + 3 >= buffer.length) throw const _IncompleteDataException();
    if (buffer[offset + 2] != respCarriageReturn ||
        buffer[offset + 3] != respLineFeed) {
      throw const FormatException('Formato de booleano inválido: falta CRLF');
    }
    final char = buffer[offset + 1];

    if (char == respTrue || char == 1) {
      return const ParseResult(true, 4); // ~t\r\n son 4 bytes
    } else if (char == respFalse || char == 0) {
      return const ParseResult(false, 4); // ~f\r\n son 4 bytes
    } else {
      throw FormatException(
        'Valor booleano inválido: ${String.fromCharCode(char)}',
      );
    }
  }

  ParseResult<double> parseDouble(Uint8List buffer, int offset) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    return ParseResult(
      double.parse(decodeString(buffer, offset + 1, crlf)),
      crlf - offset + 2,
    );
  }

  ParseResult<dynamic> parseNull(Uint8List buffer, int offset) {
    if (offset + 2 >= buffer.length) throw const _IncompleteDataException();
    if (buffer[offset + 1] != respCarriageReturn ||
        buffer[offset + 2] != respLineFeed) {
      throw const FormatException('Formato de nulo inválido: falta CRLF');
    }
    return const ParseResult(null, 3);
  }

  ParseResult<Map<dynamic, dynamic>?> parseMap(
    Uint8List buffer,
    int offset,
    ItemParser parseItem,
  ) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    final count = int.parse(decodeString(buffer, offset + 1, crlf));
    if (count == -1) return ParseResult(null, crlf - offset + 2);

    final items = <dynamic, dynamic>{};
    var currentOffset = crlf + 2;
    for (var i = 0; i < count; i++) {
      final keyResult = parseItem(buffer, currentOffset);
      currentOffset += keyResult.bytesConsumed;

      final valueResult = parseItem(buffer, currentOffset);
      currentOffset += valueResult.bytesConsumed;

      items[keyResult.value] = valueResult.value;
    }
    return ParseResult(items, currentOffset - offset);
  }

  ParseResult<RespException?> parseBlobError(Uint8List buffer, int offset) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    final length = int.parse(decodeString(buffer, offset + 1, crlf));
    if (length == -1) {
      return ParseResult(null, crlf - offset + 2);
    }
    final dataStart = crlf + 2;
    final totalLength = dataStart + length + 2;
    if (buffer.length < totalLength) throw const _IncompleteDataException();

    final errorMessage = decodeString(buffer, dataStart, dataStart + length);
    return ParseResult(RespException(errorMessage), totalLength - offset);
  }

  ParseResult<String?> parseVerbatimString(Uint8List buffer, int offset) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    final length = int.parse(decodeString(buffer, offset + 1, crlf));
    if (length == -1) {
      return ParseResult(null, crlf - offset + 2); // String Verbatim Nulo
    }
    final dataStart = crlf + 2;
    final totalLength = dataStart + length + 2;
    if (buffer.length < totalLength) throw const _IncompleteDataException();

    final fullString = decodeString(buffer, dataStart, dataStart + length);

    return ParseResult(fullString, totalLength - offset);
  }

  ParseResult<BigInt> parseBigNumber(Uint8List buffer, int offset) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    return ParseResult(
      BigInt.parse(decodeString(buffer, offset + 1, crlf)),
      crlf - offset + 2,
    );
  }

  ParseResult<List<dynamic>?> parsePush(
    Uint8List buffer,
    int offset,
    ItemParser parseItem,
  ) {
    // La lógica de parsing es idéntica a parseArray
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    final count = int.parse(decodeString(buffer, offset + 1, crlf));
    if (count == -1) return ParseResult(null, crlf - offset + 2); // Push Nulo

    final items = <dynamic>[];
    var currentOffset = crlf + 2;
    for (var i = 0; i < count; i++) {
      final result = parseItem(buffer, currentOffset);
      items.add(result.value);
      currentOffset += result.bytesConsumed;
    }
    return ParseResult(items, currentOffset - offset);
  }

  ParseResult<Set<dynamic>?> parseSet(
    Uint8List buffer,
    int offset,
    ItemParser parseItem,
  ) {
    final crlf = findCRLF(buffer, offset);
    if (crlf == -1) throw const _IncompleteDataException();
    final count = int.parse(decodeString(buffer, offset + 1, crlf));
    if (count == -1) return ParseResult(null, crlf - offset + 2);

    final items = <dynamic>{};
    var currentOffset = crlf + 2;
    for (var i = 0; i < count; i++) {
      final result = parseItem(buffer, currentOffset);
      items.add(result.value);
      currentOffset += result.bytesConsumed;
    }
    return ParseResult(items, currentOffset - offset);
  }
}

// RESP3 Decoder
class Resp3Decoder extends BaseRespCodec
    with Resp2ParsingHelpers, Resp3ParsingHelpers {
  const new();

  @override
  ParseResult<dynamic> _parse(Uint8List buffer, int offset) {
    if (offset >= buffer.length) throw const _IncompleteDataException();
    switch (buffer[offset]) {
      // Tipos RESP2 (también válidos en RESP3)
      case respSimpleString:
        return parseSimpleString(buffer, offset);
      case respError:
        return parseError(buffer, offset);
      case respInteger:
        return parseInteger(buffer, offset);
      case respBulkString:
        return parseBulkString(buffer, offset);
      case respArray:
        return parseArray(buffer, offset, _parse);

      // Nuevos tipos RESP3
      case respBoolean:
        return parseBoolean(buffer, offset);
      case respDouble:
        return parseDouble(buffer, offset);
      case respNull:
        return parseNull(buffer, offset);
      case respMap:
        return parseMap(buffer, offset, _parse);
      case respSet:
        return parseSet(buffer, offset, _parse);
      case respBlobError:
        return parseBlobError(buffer, offset);
      case respPush:
        return parsePush(buffer, offset, _parse);
      case respVerbatimString:
        return parseVerbatimString(buffer, offset);
      case respBigNumber:
        return parseBigNumber(buffer, offset);

      default:
        throw FormatException(
          'Tipo RESP3 desconocido: ${String.fromCharCode(buffer[offset])}',
        );
    }
  }
}
