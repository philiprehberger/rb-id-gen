# frozen_string_literal: true

require_relative 'id_gen/version'
require_relative 'id_gen/ulid'
require_relative 'id_gen/nanoid'
require_relative 'id_gen/prefixed'
require_relative 'id_gen/snowflake'
require_relative 'id_gen/uuid'

module Philiprehberger
  module IdGen
    class Error < StandardError; end

    def self.ulid
      Ulid.generate
    end

    def self.ulid_monotonic
      Ulid.monotonic
    end

    def self.ulid_timestamp(ulid_string)
      Ulid.timestamp(ulid_string)
    end

    def self.nanoid(size = 21, alphabet: Nanoid::DEFAULT_ALPHABET)
      Nanoid.generate(size, alphabet: alphabet)
    end

    def self.prefixed(prefix)
      Prefixed.generate(prefix)
    end

    def self.snowflake(worker_id: 0, epoch: nil)
      if epoch
        epoch_ms = (epoch.to_f * 1000).to_i
        key = [worker_id, epoch_ms]
        @snowflake_custom_generators ||= {}
        @snowflake_custom_generators[key] ||= Snowflake::Generator.new(worker_id: worker_id, epoch: epoch)
        @snowflake_custom_generators[key].generate
      else
        @snowflake_generators ||= {}
        @snowflake_generators[worker_id] ||= Snowflake::Generator.new(worker_id: worker_id)
        @snowflake_generators[worker_id].generate
      end
    end

    def self.snowflake_timestamp(id, epoch: nil)
      if epoch
        epoch_ms = (epoch.to_f * 1000).to_i
        Snowflake.timestamp(id, epoch_ms: epoch_ms)
      else
        Snowflake.timestamp(id)
      end
    end

    def self.uuid_v7
      Uuid.generate_v7
    end

    def self.uuid_v7_timestamp(uuid_string)
      Uuid.timestamp_v7(uuid_string)
    end

    # Batch generation methods

    def self.ulid_batch(count)
      validate_batch_count!(count)
      Array.new(count) { Ulid.generate }
    end

    def self.nanoid_batch(count, size: 21, alphabet: Nanoid::DEFAULT_ALPHABET)
      validate_batch_count!(count)
      Array.new(count) { Nanoid.generate(size, alphabet: alphabet) }
    end

    def self.uuid_v7_batch(count)
      validate_batch_count!(count)
      Array.new(count) { Uuid.generate_v7 }
    end

    def self.prefixed_batch(prefix, count)
      validate_batch_count!(count)
      Array.new(count) { Prefixed.generate(prefix) }
    end

    # Validation methods

    def self.valid_ulid?(string)
      return false unless string.is_a?(String)
      return false unless string.length == 26

      string.match?(/\A[0-9A-HJKMNP-TV-Z]+\z/)
    end

    def self.valid_nanoid?(string, size: 21, alphabet: Nanoid::DEFAULT_ALPHABET)
      return false unless string.is_a?(String)
      return false unless string.length == size

      escaped = Regexp.escape(alphabet)
      string.match?(/\A[#{escaped}]+\z/)
    end

    def self.valid_uuid_v7?(string)
      Uuid.valid_v7?(string)
    end

    def self.valid_snowflake?(id)
      return false unless id.is_a?(Integer)
      return false unless id.positive?

      timestamp_ms = (id >> Snowflake::TIMESTAMP_SHIFT) + Snowflake::CUSTOM_EPOCH
      # Reasonable timestamp: between epoch (2020-01-01) and ~100 years after
      timestamp_ms.positive? && timestamp_ms < (Snowflake::CUSTOM_EPOCH + (100 * 365.25 * 24 * 60 * 60 * 1000).to_i)
    end

    # ULID parsing

    def self.parse_ulid(string)
      raise Error, 'Invalid ULID format' unless valid_ulid?(string)

      timestamp = Ulid.timestamp(string)
      random_part = string[10, 16]
      random_value = Ulid.send(:decode_crockford, random_part)
      random_hex = format('%020x', random_value)

      { timestamp: timestamp, random: random_hex }
    end

    def self.validate_batch_count!(count)
      raise Error, 'Count must be a positive integer' unless count.is_a?(Integer) && count.positive?
    end

    private_class_method :validate_batch_count!
  end
end
