/// Public interface for a connection to a Valkey/Redis server.
abstract class Connection {
  /// Initiates the connection to the server.
  Future<void> connect({String? username, String? password});

  /// Sends a command (encoded as a list of bytes) to the server.
  void send(List<int> data);

  /// Closes the connection and releases all resources.
  Future<void> close();

  bool get isConnected;
}
