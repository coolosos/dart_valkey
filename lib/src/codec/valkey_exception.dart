class ValkeyException implements Exception {
  new(this.message);
  final String message;
  @override
  String toString() => 'ValkeyException: $message';
}
