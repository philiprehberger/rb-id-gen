# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this gem adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.2] - 2026-04-08

### Changed
- Align gemspec summary with README description.

## [0.3.1] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.3.0] - 2026-03-31

### Added
- CUID2 generation with `IdGen.cuid2(length:)` and batch/validation methods
- Integer encoding/decoding with `IdGen.encode` and `IdGen.decode` using custom alphabets
- Hashid encoding with `IdGen.hashid(integer, salt:, min_length:)` for obfuscated IDs

## [0.2.0] - 2026-03-28

### Added
- UUID v7 generation (`IdGen.uuid_v7`) per RFC 9562 with timestamp extraction
- Batch generation methods for all ID types (`ulid_batch`, `nanoid_batch`, `uuid_v7_batch`, `prefixed_batch`)
- ID validation methods (`valid_ulid?`, `valid_nanoid?`, `valid_uuid_v7?`, `valid_snowflake?`)
- ULID parsing with `IdGen.parse_ulid` returning timestamp and random components
- Configurable epoch for snowflake ID generation

## [0.1.0] - 2026-03-21

### Added
- Initial release
- ULID generation (time-sortable, Crockford base32)
- Monotonic ULID mode for guaranteed ordering
- ULID timestamp extraction
- Nanoid generation with configurable length and alphabet
- Stripe-style prefixed ID generation
- Twitter-style snowflake ID generation
- Snowflake timestamp extraction
