# frozen_string_literal: true

require_relative 'id_gen/version'
require_relative 'id_gen/ulid'
require_relative 'id_gen/nanoid'
require_relative 'id_gen/prefixed'
require_relative 'id_gen/snowflake'

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

    def self.snowflake(worker_id: 0)
      @snowflake_generators ||= {}
      @snowflake_generators[worker_id] ||= Snowflake::Generator.new(worker_id: worker_id)
      @snowflake_generators[worker_id].generate
    end

    def self.snowflake_timestamp(id)
      Snowflake.timestamp(id)
    end
  end
end
