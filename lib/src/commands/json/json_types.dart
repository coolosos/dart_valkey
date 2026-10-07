import 'dart:convert';

/// Function signature for JSON encoders.
typedef JsonEncoderFn = String Function(Object? value);

/// Function signature for JSON decoders.
typedef JsonDecoderFn = dynamic Function(String jsonString);

/// Default JSON encoder using standard [jsonEncode].
String defaultJsonEncoder(Object? value) => jsonEncode(value);

/// Default JSON decoder using standard [jsonDecode].
dynamic defaultJsonDecoder(String jsonString) => jsonDecode(jsonString);
