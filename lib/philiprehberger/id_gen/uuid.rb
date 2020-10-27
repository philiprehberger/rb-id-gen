# frozen_string_literal: true

require 'securerandom'

module Philiprehberger
  module IdGen
    module Uuid
      module_function

      def generate_v7
        timestamp_ms = (Time.now.to_f * 1000).to_i
        random_bytes = SecureRandom.random_bytes(10)

        # 48-bit timestamp split into 32-bit high and 16-bit low
        time_high = (timestamp_ms >> 16) & 0xFFFFFFFF
        time_low = timestamp_ms & 0xFFFF

        # 4-bit version (0111) + 12-bit random
        rand_a = ((random_bytes.getbyte(0) << 4) | (random_bytes.getbyte(1) >> 4)) & 0x0FFF
        ver_rand_a = 0x7000 | rand_a

        # 2-bit variant (10) + 14-bit random
        rand_b = ((random_bytes.getbyte(1) & 0x0F) << 10) |
                 (random_bytes.getbyte(2) << 2) |
                 (random_bytes.getbyte(3) >> 6)
        var_rand_b = 0x8000 | (rand_b & 0x3FFF)

        # 48-bit random node
        rand_c = 0
        (4...10).each do |i|
          rand_c = (rand_c << 8) | random_bytes.getbyte(i)
        end

        format(
          '%08x-%04x-%04x-%04x-%012x',
          time_high, time_low, ver_rand_a, var_rand_b, rand_c
        )
      end

      def timestamp_v7(uuid_string)
        raise Error, 'Invalid UUID v7 format' unless valid_v7?(uuid_string)

        hex = uuid_string.delete('-')
        timestamp_ms = hex[0, 12].to_i(16)
        Time.at(timestamp_ms / 1000.0)
      end

      def valid_v7?(uuid_string)
        return false unless uuid_string.is_a?(String)
        return false unless uuid_string.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/)

        true
      end
    end
  end
end
