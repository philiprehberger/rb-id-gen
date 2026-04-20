# philiprehberger-id_gen

[![Tests](https://github.com/philiprehberger/rb-id-gen/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-id-gen/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-id_gen.svg)](https://rubygems.org/gems/philiprehberger-id_gen)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-id-gen)](https://github.com/philiprehberger/rb-id-gen/commits/main)

Multi-format unique ID generator with ULID, nanoid, UUID v7, CUID2, prefixed, snowflake, hashid, and encoding support

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
Philiprehberger::IdGen.cuid2             # => "k8f3h2j1m4n5p6q7r8s9t0u1"
Philiprehberger::IdGen.prefixed("usr")   # => "usr_01hz3v5k8e9abcdefghjkmnpqr"
Philiprehberger::IdGen.snowflake         # => 7089552452952064
Philiprehberger::IdGen.hashid(42)        # => "aB3kZ9mQ"
Philiprehberger::IdGen.encode(12345)     # => "3d7"
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

### CUID2

Collision-resistant, compact identifiers safe for use as HTML element IDs and database keys:

```ruby
require "philiprehberger/id_gen"

Philiprehberger::IdGen.cuid2                # => 24-char lowercase alphanumeric, starts with letter
Philiprehberger::IdGen.cuid2(length: 10)    # => custom length (2-32)
Philiprehberger::IdGen.cuid2_batch(5)       # => Array of 5 CUID2s
Philiprehberger::IdGen.valid_cuid2?("k8f3h2j1m4n5p6q7r8s9t0u1") # => true
```

### Encoding

Encode and decode integers using customizable alphabets (base62 by default):

```ruby
require "philiprehberger/id_gen"

Philiprehberger::IdGen.encode(12345)          # => base62 encoded string
Philiprehberger::IdGen.decode("3d7")          # => integer value
Philiprehberger::IdGen.encode(255, alphabet: "0123456789abcdef") # => "ff"
Philiprehberger::IdGen.decode("ff", alphabet: "0123456789abcdef") # => 255
```

### Hashid

Obfuscate integers into short, URL-safe strings using a salt:

```ruby
require "philiprehberger/id_gen"

Philiprehberger::IdGen.hashid(42)                           # => obfuscated string (min 8 chars)
Philiprehberger::IdGen.hashid(42, salt: "my-secret")        # => different output per salt
Philiprehberger::IdGen.hashid(42, salt: "s", min_length: 12) # => at least 12 chars
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
Philiprehberger::IdGen.cuid2_batch(10)               # => Array of 10 CUID2s
```

### Validation

Validate ID format:

```ruby
require "philiprehberger/id_gen"

Philiprehberger::IdGen.valid_ulid?("01HZ3V5K8E9ABCDEFGHJKMNPQR")   # => true
Philiprehberger::IdGen.valid_nanoid?("V1StGXR8_Z5jdHi6B-myT")      # => true
Philiprehberger::IdGen.valid_uuid_v7?("01902e6e-f460-7b1a-8c9d-e0f1a2b3c4d5") # => true
Philiprehberger::IdGen.valid_snowflake?(7089552452952064)           # => true
Philiprehberger::IdGen.valid_cuid2?("k8f3h2j1m4n5p6q7r8s9t0u1")   # => true

Philiprehberger::IdGen.detect_format(Philiprehberger::IdGen.ulid)    # => :ulid
Philiprehberger::IdGen.detect_format(Philiprehberger::IdGen.uuid_v7) # => :uuid_v7
Philiprehberger::IdGen.detect_format("not-an-id")                    # => nil
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
| `IdGen.cuid2(length: 24)` | Generate a CUID2 identifier |
| `IdGen.cuid2_batch(count, length: 24)` | Generate an array of CUID2s |
| `IdGen.valid_cuid2?(string, length: 24)` | Validate CUID2 format |
| `IdGen.detect_format(id)` | Detect ID format: `:ulid`, `:uuid_v7`, `:snowflake`, `:cuid2`, `:nanoid`, or `nil` |
| `IdGen.encode(integer, alphabet:)` | Encode integer to base-N string (default base62) |
| `IdGen.decode(string, alphabet:)` | Decode base-N string to integer |
| `IdGen.hashid(integer, salt:, min_length:)` | Encode integer to obfuscated hashid string |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-id-gen)

🐛 [Report issues](https://github.com/philiprehberger/rb-id-gen/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-id-gen/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
