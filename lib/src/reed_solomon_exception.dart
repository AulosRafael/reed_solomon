class ReedSolomonException implements Exception {
  final String message;

  const ReedSolomonException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}
