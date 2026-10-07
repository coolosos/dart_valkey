# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.2.0 - 2026-10-07

### Added
- **Valkey & Redis JSON Module Support**:
  - Implemented all 23 JSON commands: `JSON.SET`, `JSON.GET`, `JSON.DEL`, `JSON.FORGET`, `JSON.MGET`, `JSON.MSET`, `JSON.DEBUG` (`MEMORY` & `HELP`), `JSON.TYPE`, `JSON.NUMINCRBY`, `JSON.NUMMULTBY`, `JSON.TOGGLE`, `JSON.STRAPPEND`, `JSON.STRLEN`, `JSON.ARRAPPEND`, `JSON.ARRINSERT`, `JSON.ARRLEN`, `JSON.ARRPOP`, `JSON.ARRINDEX`, `JSON.ARRTRIM`, `JSON.OBJKEYS`, `JSON.OBJLEN`, `JSON.MERGE`, `JSON.CLEAR`, `JSON.RESP`.
  - Added high-level, type-safe client extension methods in `ValkeyCommands`: `jsonSet`, `jsonSetRaw`, `jsonGet<T>`, `jsonGetRaw`, `jsonGetTyped<T>`, `jsonDel`, `jsonForget`, `jsonMGet<T>`, `jsonMGetRaw`, `jsonMSet`, `jsonMSetRaw`, `jsonDebugMemory`, `jsonDebugHelp`, `jsonType`, `jsonNumIncrBy`, `jsonNumMultBy`, `jsonToggle`, `jsonStrAppend`, `jsonStrAppendRaw`, `jsonStrLen`, `jsonArrAppend`, `jsonArrAppendRaw`, `jsonArrInsert`, `jsonArrLen`, `jsonArrPop<T>`, `jsonArrPopRaw`, `jsonArrIndex`, `jsonArrTrim`, `jsonObjKeys`, `jsonObjLen`, `jsonMerge`, `jsonClear`, `jsonResp`.
  - Added **`ValkeyJsonStore<T>`**: Strongly-typed repository pattern for managing JSON documents with automatic key generation, TTL handling, atomic batch saving (`saveMany`), and sub-field mutations.
  - Added **`JsonPath` Builder**: Type-safe, fluent JSONPath DSL supporting nested fields, array indices, wildcards, slicing, and filter expressions (`JsonPath.root['store']['items'][0]`).
  - Added **`JsonUpdateBuilder` (`client.jsonUpdate`)**: Fluent batch document updater for applying multiple atomic mutations in a single cascade.
  - Added **`jsonStreamArray<T>`**: Paginated chunked streaming for processing massive JSON arrays without loading them entirely into memory.
  - Added default root path (`r'$'`) for simplified calls like `client.jsonSet(key, value)` and `client.jsonMerge(key, value)`.
  - Added generic type support in `jsonGet<T>`, `jsonMGet<T>`, and `jsonArrPop<T>` for ergonomic static typing.
  - Seamless interoperability with Dart 3 Pattern Matching, custom model factories (`fromJson`), and pluggable serialization / streaming libraries like [`coolson`](https://github.com/coolosos/coolson).
  - Achieved **100% test coverage** on all JSON commands, repository store, builders, and helpers.

### Fixed
- Fixed an issue where a null `keyPrefix` in `ValkeyCommandClient` was stringified as `'null:'`.
- Fixed error propagation in `ValkeyCommandClient._onData` to directly reject command futures with `RespException` when the server returns a protocol error.

## 0.1.0 - 2026-10-06

### Changed
- Upgraded minimum Dart SDK constraint to `>=3.13.0 <4.0.0`.
- Upgraded dev dependencies (`coolint: ^3.0.0`, `meta: ^1.19.0`, `mockito: ^5.8.1`, `build_runner: ^2.16.1`, `test: ^1.32.0`, `coverage: ^1.15.1`).
- Migrated all command and model classes to **Dart 3.13 Primary Constructors** for clean, declarative, and concise code.
- Refactored command response parsing using reusable base mixins (`OkStringResponse`, `OkBoolResponse`, `ExpectOkBoolResponse`, `PongBoolResponse`, `ResetStringResponse`).
- Enhanced error reporting to use human-readable `commandName` derived directly from command parts instead of minified `runtimeType`.

### Documentation
- Updated `README.md` with complete documentation for TLS / self-signed certificate handling (`onBadCertificate`), client configuration options (`db`, `keyPrefix`, `commandTimeout`, `respDecoder`), and custom command execution.
- Added package publishing configuration (`.pubignore`).

## 0.0.6 - 2026-06-09

### Added

- Added `commandTimeout` parameter to `ValkeyCommandClient` constructor (defaults to 1 seconds).
- Added support for command-specific timeout overriding in the `execute` method.
- Added option to disable timeouts globally or per command by passing `Duration.zero` or negative durations.

### Fixed

- Fixed a critical issue where commands queued up indefinitely and futures never completed when the connection was lost, preventing consuming application servers (like Shelf) from hanging forever.

## 0.0.5 - 2026-03-05

### Fixed

- Fixed name parsing in a component (#14)

### Changed

- Improved and fixed benchmark performance and accuracy.

## 0.0.4 - 2026-02-27

### Added

- Implemented comprehensive tests for Valkey client, achieving 96.4% coverage.
- Added tests for `SecureConnection` and `InsecureConnection`.
- Added tests for `SetCommand` options (PX, PXAT, KeepTtl, strategy + expire).
- Added tests for `SetAndGetCommand`.
- Added tests for `ValkeyCommandClient` (secure/insecure).
- Added tests for `ValkeySubscriptionClient` (resubscription, pending commands on errors).
- Added test for sending data when socket is closed (`base_connection`).
- Added tests for authentication failures (RESP2 and RESP3).

### Fixed

- Fixed issues with `valkey_command_client.dart` imports and constructor.
- Corrected test imports in `all_commands_test.dart`.
- Updated mock client in `all_commands_test.dart` for accurate testing.
- Fixed response parsing in tests for commands like `HincrByFloatCommand`, `ZRangeCommand`, etc.

### Refactored

- Improved test coverage across the project, focusing on edge cases and error handling.

## 0.0.3 - 2025-10-20

### Changed
- Enhanced repository quality and project standards with a wide range of documentation, CI, and metadata improvements.
- Added community standards files: `AUTHORS.md`, `CONTRIBUTING.md`.
- Added GitHub templates for bug reports, feature requests, and pull requests.
- Added a runnable example in the `example/` directory.
- Updated `pubspec.yaml` with `topics` for better discoverability.
- Added a comprehensive set of badges and a Codecov graph to `README.md`.
- Configured Dependabot for automatic dependency updates.
- Integrated Codecov for test coverage reporting in the CI workflow.

## 0.0.2 - 2025-09-14
### Added
- Added the ability to customize the Nagle algorithm (`socket.setOption(SocketOption.tcpNoDelay, true)`).

## 0.0.1

- Initial version.
### Added
- Initial release of the package.
- Added core client functionality.
- Implemented basic RESP decoding and encoding.
- Included initial set of commands (e.g., PING, ECHO).
- Implemented connection management (secure and insecure).
- Added Pub/Sub client with regular, pattern, and shard subscription mixins.
- Implemented various command groups (Hashes, Keys, Lists, Sets, Strings, ZSets).
