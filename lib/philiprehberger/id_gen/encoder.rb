# frozen_string_literal: true

module Philiprehberger
  module IdGen
    module Encoder
      DEFAULT_ALPHABET = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

      module_function

      def encode(integer, alphabet: DEFAULT_ALPHABET)
        raise Error, 'Value must be a non-negative integer' unless integer.is_a?(Integer) && integer >= 0

        base = alphabet.length
        return alphabet[0] if integer.zero?

        result = +''
        value = integer
        while value.positive?
          result.prepend(alphabet[value % base])
          value /= base
        end
        result
      end

      def decode(string, alphabet: DEFAULT_ALPHABET)
        raise Error, 'String must not be empty' if string.nil? || string.empty?

        base = alphabet.length
        string.each_char.reduce(0) do |acc, char|
          index = alphabet.index(char)
          raise Error, "Character '#{char}' not in alphabet" unless index

          (acc * base) + index
        end
      end
    end
  end
end
