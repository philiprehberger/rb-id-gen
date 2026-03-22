# frozen_string_literal: true

module Philiprehberger
  module IdGen
    module Prefixed
      module_function

      def generate(prefix)
        validate_prefix!(prefix)

        ulid_part = Ulid.generate.downcase
        "#{prefix}_#{ulid_part}"
      end

      def validate_prefix!(prefix)
        raise Error, 'Prefix must be a non-empty string' if prefix.nil? || !prefix.is_a?(String) || prefix.empty?
        raise Error, 'Prefix must contain only lowercase letters' unless prefix.match?(/\A[a-z]+\z/)
      end

      private_class_method :validate_prefix!
    end
  end
end
