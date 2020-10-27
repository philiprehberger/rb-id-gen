# frozen_string_literal: true

module Philiprehberger
  module IdGen
    module Snowflake
      CUSTOM_EPOCH = 1_577_836_800_000 # 2020-01-01 00:00:00 UTC in milliseconds

      TIMESTAMP_BITS = 41
      WORKER_ID_BITS = 10
      SEQUENCE_BITS = 12

      MAX_WORKER_ID = (1 << WORKER_ID_BITS) - 1
      MAX_SEQUENCE = (1 << SEQUENCE_BITS) - 1

      WORKER_ID_SHIFT = SEQUENCE_BITS
      TIMESTAMP_SHIFT = WORKER_ID_BITS + SEQUENCE_BITS

      class Generator
        def initialize(worker_id: 0, epoch: nil)
          raise Error, "Worker ID must be between 0 and #{MAX_WORKER_ID}" unless worker_id.between?(0, MAX_WORKER_ID)

          @worker_id = worker_id
          @epoch_ms = epoch ? (epoch.to_f * 1000).to_i : CUSTOM_EPOCH
          @sequence = 0
          @last_timestamp = -1
          @mutex = Mutex.new
        end

        def generate
          @mutex.synchronize do
            timestamp_ms = current_timestamp

            if timestamp_ms == @last_timestamp
              @sequence = (@sequence + 1) & MAX_SEQUENCE
              timestamp_ms = wait_next_millis(@last_timestamp) if @sequence.zero?
            else
              @sequence = 0
            end

            @last_timestamp = timestamp_ms

            (timestamp_ms << TIMESTAMP_SHIFT) |
              (@worker_id << WORKER_ID_SHIFT) |
              @sequence
          end
        end

        private

        def current_timestamp
          (Time.now.to_f * 1000).to_i - @epoch_ms
        end

        def wait_next_millis(last_timestamp)
          timestamp = current_timestamp
          timestamp = current_timestamp while timestamp <= last_timestamp
          timestamp
        end
      end

      module_function

      def timestamp(id, epoch_ms: CUSTOM_EPOCH)
        timestamp_ms = (id >> TIMESTAMP_SHIFT) + epoch_ms
        Time.at(timestamp_ms / 1000.0)
      end
    end
  end
end
