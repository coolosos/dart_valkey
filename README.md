# dart_valkey

A robust, type-safe Dart client for Valkey and Redis.

[![Pub Version](https://badgen.net/pub/v/dart_valkey)](https://pub.dev/packages/dart_valkey/)
[![Pub Likes](https://badgen.net/pub/likes/dart_valkey)](https://pub.dev/packages/dart_valkey/score)
[![Pub Points](https://badgen.net/pub/points/dart_valkey)](https://pub.dev/packages/dart_valkey/score)
[![Pub Downloads](https://badgen.net/pub/dm/dart_valkey)](https://pub.dev/packages/dart_valkey)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/dart_valkey)](https://pub.dev/packages/dart_valkey/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/coolosos/dart_valkey/blob/main/LICENSE)
[![codecov](https://codecov.io/gh/coolosos/dart_valkey/graph/badge.svg)](https://codecov.io/gh/coolosos/dart_valkey)


dart_valkey is a robust, type-safe Dart client for Redis and Valkey that manages both command and Pub/Sub interactions. It provides built-in connection management, automatic reconnection, and pluggable authentication.

---

## Why dart_valkey?

- **SSL Certificate Management**: Unlike other Dart clients, dart_valkey provides `onBadCertificate` callback for handling self-signed certificates in development or internal servers.

- **Easy Extensibility**: Create custom commands easily by extending `ValkeyCommand<T>`. The parser handles RESP2 and RESP3 automatically.

- **Automatic Reconnection**: Built-in exponential backoff with jitter (500ms → 30s) and auto-resubscribe for Pub/Sub when connection is restored.

- **Type-Safe Design**: From predefined commands to Dart extensions, everything is type-safe. The compiler helps catch errors before runtime.

---

## Features

- **Connection Management**  
  Uses the Template Method pattern in `BaseConnection` to handle socket connection, reconnection logic, and error management automatically.

- **Authentication and Command Execution**  
  Implements authentication commands (HELLO and AUTH) for secure data exchange with the server.

- **Pub/Sub Support**  
  Supports regular, pattern, and sharded Pub/Sub operations with the `ValkeySubscriptionClient`.

- **RESP2 and RESP3 Support**  
  Automatically detects and uses the appropriate protocol version.

- **Extensible & Modular**  
  Commands are organized into modules. New commands can be added as extensions or by creating custom `ValkeyCommand` classes.

---

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  dart_valkey: any
```

Or with a specific version:

```yaml
dependencies:
  dart_valkey: ^0.0.4
```

Then run:

```sh
dart pub get
```

---

## Quick Start

### Connecting and Sending Commands

```dart
import 'package:dart_valkey/dart_valkey.dart';

Future<void> main() async {
  final client = ValkeyCommandClient(
    host: 'localhost',
    port: 6379,
    // username: 'your-username',  // optional
    // password: 'your-password',  // optional
  );

  await client.connect();

  // Using extensions
  await client.set('key', 'value');
  final value = await client.get('key');
  print('Value: $value');

  await client.close();
}
```

### Pub/Sub Example

```dart
import 'package:dart_valkey/dart_valkey.dart';

Future<void> main() async {
  final subClient = ValkeySubscriptionClient(
    host: 'localhost',
    port: 6379,
  );

  await subClient.connect();

  // Subscribe to channels
  subClient.subscribe(['notifications']);

  // Listen for messages
  subClient.messages.listen((PubSubMessage msg) {
    print('Message: ${msg.message} on channel: ${msg.channel}');
  });

  await Future.delayed(const Duration(seconds: 30));
  await subClient.close();
}
```

---

## Running Tests

To run the tests, you need a Valkey or Redis server running on `localhost:6379`.

```bash
# Start Valkey server (if not running)
valkey-server --daemonize yes

# Run all tests
dart test

# Run only unit tests (skip integration tests)
dart test -x integration
```

---

## Documentation

- **Commands Implementation**: See [COMMANDS.md](./COMMANDS.md) for the complete list of supported commands.
- **Benchmark**: See [BENCHMARK.md](./BENCHMARK.md) for performance comparisons with other Dart Redis clients.
- **API Reference**: Visit [pub.dev](https://pub.dev/packages/dart_valkey) for the full API documentation.

---

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests on our [GitHub repository](https://github.com/coolosos/dart_valkey).

To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `dart test`
5. Submit a pull request

---

## Links

- [Package on pub.dev](https://pub.dev/packages/dart_valkey)
- [GitHub Repository](https://github.com/coolosos/dart_valkey)
- [Valkey Documentation](https://valkey.io/)
- [Redis Documentation](https://redis.io/docs/)
