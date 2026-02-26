# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
