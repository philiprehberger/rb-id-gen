# philiprehberger-id_gen

[![Tests](https://github.com/philiprehberger/rb-id-gen/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-id-gen/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-id_gen.svg)](https://rubygems.org/gems/philiprehberger-id_gen)
[![License](https://img.shields.io/github/license/philiprehberger/rb-id-gen)](LICENSE)

Multi-format unique ID generator with ULID, nanoid, prefixed, and snowflake support

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

Philiprehberger::IdGen.ulid           # => "01HZ3V5K8E9ABCDEFGHJKMNPQR"
Philiprehberger::IdGen.nanoid         # => "V1StGXR8_Z5jdHi6B-myT"
Philiprehberger::IdGen.prefixed("usr") # => "usr_01hz3v5k8e9abcdefghjkmnpqr"
Philiprehberger::IdGen.snowflake      # => 7089552452952064
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
```

## API

| Method | Description |
|--------|-------------|
| `IdGen.ulid` | Generate a random ULID (26 chars, Crockford base32) |
| `IdGen.ulid_monotonic` | Generate a monotonically increasing ULID |
| `IdGen.ulid_timestamp(ulid_string)` | Extract a `Time` from a ULID string |
| `IdGen.nanoid(size = 21, alphabet: DEFAULT_ALPHABET)` | Generate a nanoid with optional size and alphabet |
| `IdGen.prefixed(prefix)` | Generate a prefixed ID (e.g., `usr_...`) |
| `IdGen.snowflake(worker_id: 0)` | Generate a 64-bit snowflake ID |
| `IdGen.snowflake_timestamp(id)` | Extract a `Time` from a snowflake ID |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
