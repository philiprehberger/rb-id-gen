# frozen_string_literal: true

require "securerandom"

module Philiprehberger
  module IdGen
    module Nanoid
      DEFAULT_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-"

      module_function

      def generate(size = 21, alphabet: DEFAULT_ALPHABET)
        raise Error, "Size must be positive" unless size.positive?
        raise Error, "Alphabet must not be empty" if alphabet.empty?
        raise Error, "Alphabet must be 256 characters or fewer" if alphabet.length > 256

        mask = (1 << Math.log2(alphabet.length - 1).ceil) - 1 | 1
        step = (1.6 * mask * size / alphabet.length).ceil

        id = +""
        loop do
          bytes = SecureRandom.random_bytes(step)
          bytes.each_byte do |byte|
            index = byte & mask
            next if index >= alphabet.length

            id << alphabet[index]
            return id if id.length == size
          end
        end
      end
    end
  end
end
