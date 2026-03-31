# frozen_string_literal: true

require 'digest'

module Philiprehberger
  module IdGen
    module Hashid
      ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

      module_function

      def encode(integer, salt: '', min_length: 8)
        raise Error, 'Value must be a non-negative integer' unless integer.is_a?(Integer) && integer >= 0

        shuffled = shuffle_alphabet(ALPHABET, salt)
        base = shuffled.length

        result = +''
        value = integer + 1 # offset to avoid zero-length for 0
        while value.positive?
          result.prepend(shuffled[value % base])
          value /= base
        end

        # Pad to min_length using deterministic characters
        while result.length < min_length
          pad_char = shuffled[(integer + result.length) % base]
          result.prepend(pad_char)
        end

        result
      end

      def decode(string, salt: '')
        raise Error, 'String must not be empty' if string.nil? || string.empty?

        shuffled = shuffle_alphabet(ALPHABET, salt)
        base = shuffled.length

        string.each_char.reduce(0) do |acc, char|
          index = shuffled.index(char)
          raise Error, "Invalid character '#{char}'" unless index

          (acc * base) + index
        end
      end

      def shuffle_alphabet(alphabet, salt)
        return alphabet if salt.nil? || salt.empty?

        chars = alphabet.chars
        salt_chars = salt.chars
        j = 0
        p = 0

        (chars.length - 1).downto(1) do |i|
          p += salt_chars[j].ord
          swap_index = (p + j + salt_chars[j].ord) % i
          chars[i], chars[swap_index] = chars[swap_index], chars[i]
          j = (j + 1) % salt_chars.length
        end

        chars.join
      end

      private_class_method :shuffle_alphabet
    end
  end
end
