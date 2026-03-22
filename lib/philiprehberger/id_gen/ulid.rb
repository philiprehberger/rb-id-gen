# frozen_string_literal: true

require 'securerandom'

module Philiprehberger
  module IdGen
    module Ulid
      CROCKFORD_BASE32 = '0123456789ABCDEFGHJKMNPQRSTVWXYZ'

      TIMESTAMP_LENGTH = 10
      RANDOM_LENGTH = 16
      ULID_LENGTH = TIMESTAMP_LENGTH + RANDOM_LENGTH

      module_function

      def generate
        timestamp_ms = (Time.now.to_f * 1000).to_i
        encode_timestamp(timestamp_ms) + encode_random
      end

      def monotonic
        thread_state = Thread.current[:philiprehberger_ulid_monotonic] ||= { timestamp: 0, random: nil }

        timestamp_ms = (Time.now.to_f * 1000).to_i

        if timestamp_ms == thread_state[:timestamp] && thread_state[:random]
          thread_state[:random] += 1
        else
          thread_state[:timestamp] = timestamp_ms
          random_bytes = SecureRandom.random_bytes(10)
          thread_state[:random] = bytes_to_integer(random_bytes)
        end

        random_part = encode_integer(thread_state[:random], RANDOM_LENGTH)
        encode_timestamp(timestamp_ms) + random_part
      end

      def timestamp(ulid_string)
        raise Error, "ULID must be #{ULID_LENGTH} characters" unless ulid_string.length == ULID_LENGTH

        timestamp_part = ulid_string[0, TIMESTAMP_LENGTH]
        timestamp_ms = decode_crockford(timestamp_part)
        Time.at(timestamp_ms / 1000.0)
      end

      def encode_timestamp(timestamp_ms)
        encode_integer(timestamp_ms, TIMESTAMP_LENGTH)
      end

      def encode_random
        random_bytes = SecureRandom.random_bytes(10)
        encode_integer(bytes_to_integer(random_bytes), RANDOM_LENGTH)
      end

      def encode_integer(value, length)
        result = +''
        length.times do
          result.prepend(CROCKFORD_BASE32[value & 0x1F])
          value >>= 5
        end
        result
      end

      def decode_crockford(string)
        value = 0
        string.each_char do |char|
          value = (value << 5) | CROCKFORD_BASE32.index(char.upcase)
        end
        value
      end

      def bytes_to_integer(bytes)
        bytes.each_byte.reduce(0) { |acc, byte| (acc << 8) | byte }
      end

      private_class_method :encode_timestamp, :encode_random, :encode_integer, :decode_crockford, :bytes_to_integer
    end
  end
end
