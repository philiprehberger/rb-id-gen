# philiprehberger-id_gen

[![Tests](https://github.com/philiprehberger/rb-id-gen/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-id-gen/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-id_gen.svg)](https://rubygems.org/gems/philiprehberger-id_gen)
[![GitHub release](https://img.shields.io/github/v/release/philiprehberger/rb-id-gen)](https://github.com/philiprehberger/rb-id-gen/releases)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-id-gen)](https://github.com/philiprehberger/rb-id-gen/commits/main)
[![License](https://img.shields.io/github/license/philiprehberger/rb-id-gen)](LICENSE)
[![Bug Reports](https://img.shields.io/github/issues/philiprehberger/rb-id-gen/bug)](https://github.com/philiprehberger/rb-id-gen/issues?q=is%3Aissue+is%3Aopen+label%3Abug)
[![Feature Requests](https://img.shields.io/github/issues/philiprehberger/rb-id-gen/enhancement)](https://github.com/philiprehberger/rb-id-gen/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)
[![Sponsor](https://img.shields.io/badge/sponsor-GitHub%20Sponsors-ec6cb9)](https://github.com/sponsors/philiprehberger)

Multi-format unique ID generator with ULID, nanoid, UUID v7, prefixed, and snowflake support

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-id_gen"
```

Or install directly:

```bash
gem install philiprehberger-id_gen
```

## Usage

```ruby
require "philiprehberger/id_gen"

Philiprehberger::IdGen.ulid              # => "01HZ3V5K8E9ABCDEFGHJKMNPQR"
Philiprehberger::IdGen.nanoid            # => "V1StGXR8_Z5jdHi6B-myT"
Philiprehberger::IdGen.uuid_v7           # => "01902e6e-f460-7b1a-8c9d-e0f1a2b3c4d5"
Philiprehberger::IdGen.prefixed("usr")   # => "usr_01hz3v5k8e9abcdefghjkmnpqr"
Philiprehberger::IdGen.snowflake         # => 7089552452952064
```

### ULID

Time-sortable, Crockford base32 encoded identifiers:

```ruby
require "philiprehberger/id_gen"

ulid = Philiprehberger::IdGen.ulid                    # => "01HZ3V5K8E9ABCDEFGHJKMNPQR"
monotonic = Philiprehberger::IdGen.ulid_monotonic      # => guaranteed ordering within same ms
timestamp = Philiprehberger::IdGen.ulid_timestamp(ulid) # => 2026-03-21 12:00:00 UTC
```

### Nanoid

Compact, URL-safe random identifiers:

```ruby
require "philiprehberger/id_gen"

Philiprehberger::IdGen.nanoid             # => 21 chars, default alphabet
Philiprehberger::IdGen.nanoid(10)         # => 10 chars
Philiprehberger::IdGen.nanoid(12, alphabet: "0123456789abcdef") # => hex nanoid
```

### UUID v7

Time-ordered UUIDs per RFC 9562:

```ruby
require "philiprehberger/id_gen"

uuid = Philiprehberger::IdGen.uuid_v7                    # => "01902e6e-f460-7b1a-8c9d-e0f1a2b3c4d5"
timestamp = Philiprehberger::IdGen.uuid_v7_timestamp(uuid) # => 2026-03-28 12:00:00 UTC
```

### Prefixed IDs

Stripe-style identifiers with a type prefix:

```ruby
require "philiprehberger/id_gen"

Philiprehberger::IdGen.prefixed("usr")  # => "usr_01hz3v5k8e9abcdefghjkmnpqr"
Philiprehberger::IdGen.prefixed("org")  # => "org_01hz3v5k8e9abcdefghjkmnpqr"
Philiprehberger::IdGen.prefixed("txn")  # => "txn_01hz3v5k8e9abcdefghjkmnpqr"
```

### Snowflake IDs

Twitter-style 64-bit integer identifiers:

```ruby
require "philiprehberger/id_gen"

id = Philiprehberger::IdGen.snowflake                    # => 7089552452952064
id = Philiprehberger::IdGen.snowflake(worker_id: 5)      # => different sequence per worker
timestamp = Philiprehberger::IdGen.snowflake_timestamp(id) # => 2026-03-21 12:00:00 UTC

# Custom epoch
custom_epoch = Time.utc(2015, 1, 1)
id = Philiprehberger::IdGen.snowflake(worker_id: 0, epoch: custom_epoch)
timestamp = Philiprehberger::IdGen.snowflake_timestamp(id, epoch: custom_epoch)
```

### Batch Generation

Generate multiple IDs at once:

```ruby
require "philiprehberger/id_gen"

Philiprehberger::IdGen.ulid_batch(10)                # => Array of 10 ULIDs
Philiprehberger::IdGen.nanoid_batch(5, size: 12)     # => Array of 5 nanoids (12 chars each)
Philiprehberger::IdGen.uuid_v7_batch(10)             # => Array of 10 UUID v7s
Philiprehberger::IdGen.prefixed_batch("usr", 5)      # => Array of 5 prefixed IDs
```

### Validation

Validate ID format:

```ruby
require "philiprehberger/id_gen"

Philiprehberger::IdGen.valid_ulid?("01HZ3V5K8E9ABCDEFGHJKMNPQR")   # => true
Philiprehberger::IdGen.valid_nanoid?("V1StGXR8_Z5jdHi6B-myT")      # => true
Philiprehberger::IdGen.valid_uuid_v7?("01902e6e-f460-7b1a-8c9d-e0f1a2b3c4d5") # => true
Philiprehberger::IdGen.valid_snowflake?(7089552452952064)           # => true
```

### ULID Parsing

Parse a ULID into its components:

```ruby
require "philiprehberger/id_gen"

result = Philiprehberger::IdGen.parse_ulid("01HZ3V5K8E9ABCDEFGHJKMNPQR")
result[:timestamp] # => Time object
result[:random]    # => hex string of the random component
```

## API

| Method | Description |
|--------|-------------|
| `IdGen.ulid` | Generate a random ULID (26 chars, Crockford base32) |
| `IdGen.ulid_monotonic` | Generate a monotonically increasing ULID |
| `IdGen.ulid_timestamp(ulid_string)` | Extract a `Time` from a ULID string |
| `IdGen.parse_ulid(ulid_string)` | Parse a ULID into `{timestamp:, random:}` hash |
| `IdGen.nanoid(size = 21, alphabet: DEFAULT_ALPHABET)` | Generate a nanoid with optional size and alphabet |
| `IdGen.uuid_v7` | Generate a RFC 9562 UUID v7 (time-ordered) |
| `IdGen.uuid_v7_timestamp(uuid_string)` | Extract a `Time` from a UUID v7 string |
| `IdGen.prefixed(prefix)` | Generate a prefixed ID (e.g., `usr_...`) |
| `IdGen.snowflake(worker_id: 0, epoch: nil)` | Generate a 64-bit snowflake ID with optional custom epoch |
| `IdGen.snowflake_timestamp(id, epoch: nil)` | Extract a `Time` from a snowflake ID |
| `IdGen.ulid_batch(count)` | Generate an array of ULIDs |
| `IdGen.nanoid_batch(count, size:, alphabet:)` | Generate an array of nanoids |
| `IdGen.uuid_v7_batch(count)` | Generate an array of UUID v7s |
| `IdGen.prefixed_batch(prefix, count)` | Generate an array of prefixed IDs |
| `IdGen.valid_ulid?(string)` | Validate ULID format |
| `IdGen.valid_nanoid?(string, size:, alphabet:)` | Validate nanoid format |
| `IdGen.valid_uuid_v7?(string)` | Validate UUID v7 format |
| `IdGen.valid_snowflake?(id)` | Validate snowflake ID |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this package useful, consider giving it a star on GitHub — it helps motivate continued maintenance and development.

[![LinkedIn](https://img.shields.io/badge/Philip%20Rehberger-LinkedIn-0A66C2?logo=linkedin)](https://www.linkedin.com/in/philiprehberger)
[![More packages](https://img.shields.io/badge/more-open%20source%20packages-blue)](https://philiprehberger.com/open-source-packages)

## License

[MIT](LICENSE)
