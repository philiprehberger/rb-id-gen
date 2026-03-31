# frozen_string_literal: true

require 'securerandom'
require 'digest'

module Philiprehberger
  module IdGen
    module Cuid2
      DEFAULT_LENGTH = 24
      ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

      module_function

      def generate(length = DEFAULT_LENGTH)
        raise Error, 'Length must be between 2 and 32' unless length.between?(2, 32)

        timestamp = Time.now.to_f.to_s
        random = SecureRandom.hex(32)
        counter_value = counter
        entropy = "#{timestamp}#{random}#{counter_value}"
        hash = Digest::SHA256.hexdigest(entropy)

        # First char is always a letter (for safe use as identifiers)
        first_char = ALPHABET[SecureRandom.random_number(ALPHABET.length)]
        # Remaining chars from the hash, converted to base36
        body = hash.to_i(16).to_s(36)

        result = first_char + body
        result[0, length]
      end

      def counter
        @counter_mutex ||= Mutex.new
        @counter ||= SecureRandom.random_number(2**32)
        @counter_mutex.synchronize do
          @counter += 1
          @counter
        end
      end

      private_class_method :counter
    end
  end
end
