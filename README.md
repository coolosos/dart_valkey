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
  dart_valkey: ^0.0.6
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

### JSON Operations (Valkey & RedisJSON)

Full support for the Valkey and Redis JSON module with Dart 3 Pattern Matching, custom models, atomic sub-path queries, and pluggable serialization (e.g. [`coolson`](https://github.com/coolosos/coolson)):

```dart
import 'package:dart_valkey/dart_valkey.dart';

Future<void> main() async {
  final client = ValkeyCommandClient(host: 'localhost', port: 6379);
  await client.connect();

  // 1. Store documents (path defaults to root '$')
  await client.jsonSet('user:100', {
    'name': 'Alice',
    'age': 28,
    'roles': ['developer'],
    'active': true,
  });

  // 2. Query and map to typed object using Dart 3 Pattern Matching
  final user = await client.jsonGetTyped<(String, int)>(
    'user:100',
    fromJson: (json) => switch (json) {
      {'name': final String name, 'age': final int age} => (name, age),
      _ => throw const FormatException('Invalid user schema'),
    },
  );
  print('User: $user');

  // 3. Sub-path modifications in the database
  await client.jsonNumIncrBy('user:100', r'$.age', 1);
  await client.jsonArrAppend('user:100', ['lead'], path: r'$.roles');
  await client.jsonToggle('user:100', path: r'$.active');
  await client.jsonMerge('user:100', {'department': 'Engineering'});

  // 4. Raw JSON queries (zero decoding overhead)
  final String? rawJson = await client.jsonGetRaw('user:100');
  print('Raw JSON: $rawJson');

  await client.close();
}
```

### SSL / TLS & Self-Signed Certificates

Connect securely using TLS/SSL with optional certificate verification override (ideal for internal environments, staging, or self-signed certs):

```dart
final client = ValkeyCommandClient(
  host: 'valkey.internal',
  port: 6379,
  secure: true,
  onBadCertificate: (certificate) {
    // Return true to accept self-signed or internal CA certificates
    return true;
  },
);
```

### Advanced Client Configuration

Customize database index, key prefix, or protocol decoder:

```dart
final client = ValkeyCommandClient(
  host: 'localhost',
  port: 6379,
  db: 1, // Select database 1 on connect
  keyPrefix: 'myapp', // Automatically prefixes keys with 'myapp:'
  respDecoder: const Resp3Decoder(), // or Resp2Decoder() for legacy Redis 5/6
);
```

### Command Timeout

`ValkeyCommandClient` supports command timeout execution to prevent operations from hanging indefinitely due to lost network connections or slow database responses.

> [!IMPORTANT]
> Without a command timeout, if the connection to the server drops, any commands sent will queue up in memory indefinitely and their returned `Future`s will never resolve. This can block the event loop and cause consuming application servers (like Shelf) to hang forever. Setting a command timeout ensures that these futures complete with a `TimeoutException`, releasing memory and allowing the server to fail-fast.

#### Global Timeout Configuration
By default, the client is initialized with a global command timeout of **1 second**:

```dart
final client = ValkeyCommandClient(
  host: 'localhost',
  port: 6379,
  commandTimeout: const Duration(seconds: 1), // Default value
);
```

To disable the global timeout completely, set it to `null`:
```dart
final client = ValkeyCommandClient(
  host: 'localhost',
  port: 6379,
  commandTimeout: null, // No timeout by default for any command
);
```

#### Customizing Timeout per Command
You can override or disable the global timeout for individual commands:

```dart
// Override with a specific timeout for a single command
await client.execute(PingCommand(), timeout: const Duration(milliseconds: 500));

// Disable timeout for a heavy command (unlimited execution time)
await client.execute(HGetAllCommand('large_dataset'), timeout: Duration.zero);
```
Passing `Duration.zero` or a negative duration to the `timeout` parameter disables the timeout mechanism for that command execution.

### Creating Custom Commands

You can implement custom or unsupported commands easily by extending `ValkeyCommand<T>`:

```dart
import 'package:dart_valkey/dart_valkey.dart';

final class CustomCommand extends ValkeyCommand<String?> {
  CustomCommand(this.key);
  final String key;

  @override
  List<String> get commandParts => ['CUSTOM.CMD', key];

  @override
  String? parse(dynamic data) => data as String?;
}

// Execution
final result = await client.execute(CustomCommand('my_key'));
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
