# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'ID validation' do
  describe 'IdGen.valid_ulid?' do
    it 'returns true for a valid ULID' do
      ulid = Philiprehberger::IdGen.ulid
      expect(Philiprehberger::IdGen.valid_ulid?(ulid)).to be true
    end

    it 'returns false for wrong length' do
      expect(Philiprehberger::IdGen.valid_ulid?('short')).to be false
    end

    it 'returns false for non-Crockford characters' do
      expect(Philiprehberger::IdGen.valid_ulid?('01HZ3V5K8E9ABCDEFGHJKMNPQI')).to be false
    end

    it 'returns false for lowercase ULID' do
      expect(Philiprehberger::IdGen.valid_ulid?('01hz3v5k8e9abcdefghjkmnpqr')).to be false
    end

    it 'returns false for non-string input' do
      expect(Philiprehberger::IdGen.valid_ulid?(123)).to be false
      expect(Philiprehberger::IdGen.valid_ulid?(nil)).to be false
    end
  end

  describe 'IdGen.valid_nanoid?' do
    it 'returns true for a valid nanoid' do
      nanoid = Philiprehberger::IdGen.nanoid
      expect(Philiprehberger::IdGen.valid_nanoid?(nanoid)).to be true
    end

    it 'returns false for wrong size' do
      expect(Philiprehberger::IdGen.valid_nanoid?('short')).to be false
    end

    it 'returns true for custom size and alphabet' do
      nanoid = Philiprehberger::IdGen.nanoid(10, alphabet: 'abc')
      expect(Philiprehberger::IdGen.valid_nanoid?(nanoid, size: 10, alphabet: 'abc')).to be true
    end

    it 'returns false for characters outside alphabet' do
      expect(Philiprehberger::IdGen.valid_nanoid?('aaaaaaaaaa', size: 10, alphabet: 'bc')).to be false
    end

    it 'returns false for non-string input' do
      expect(Philiprehberger::IdGen.valid_nanoid?(123)).to be false
    end
  end

  describe 'IdGen.valid_uuid_v7?' do
    it 'returns true for a valid UUID v7' do
      uuid = Philiprehberger::IdGen.uuid_v7
      expect(Philiprehberger::IdGen.valid_uuid_v7?(uuid)).to be true
    end

    it 'returns false for UUID v4' do
      expect(Philiprehberger::IdGen.valid_uuid_v7?('a1b2c3d4-e5f6-4a7b-8c9d-e0f1a2b3c4d5')).to be false
    end

    it 'returns false for random string' do
      expect(Philiprehberger::IdGen.valid_uuid_v7?('not-a-uuid')).to be false
    end

    it 'returns false for non-string input' do
      expect(Philiprehberger::IdGen.valid_uuid_v7?(123)).to be false
    end
  end

  describe 'IdGen.valid_snowflake?' do
    it 'returns true for a valid snowflake ID' do
      id = Philiprehberger::IdGen.snowflake
      expect(Philiprehberger::IdGen.valid_snowflake?(id)).to be true
    end

    it 'returns false for negative numbers' do
      expect(Philiprehberger::IdGen.valid_snowflake?(-1)).to be false
    end

    it 'returns false for zero' do
      expect(Philiprehberger::IdGen.valid_snowflake?(0)).to be false
    end

    it 'returns false for non-integer input' do
      expect(Philiprehberger::IdGen.valid_snowflake?('123')).to be false
      expect(Philiprehberger::IdGen.valid_snowflake?(1.5)).to be false
    end

    it 'returns false for unreasonably large timestamps' do
      # A number so large the timestamp would be far in the future
      huge_id = (200 * 365 * 24 * 60 * 60 * 1000) << Philiprehberger::IdGen::Snowflake::TIMESTAMP_SHIFT
      expect(Philiprehberger::IdGen.valid_snowflake?(huge_id)).to be false
    end
  end

  describe 'IdGen.detect_format' do
    it 'detects a ULID' do
      expect(Philiprehberger::IdGen.detect_format(Philiprehberger::IdGen.ulid)).to eq(:ulid)
    end

    it 'detects a UUID v7' do
      expect(Philiprehberger::IdGen.detect_format(Philiprehberger::IdGen.uuid_v7)).to eq(:uuid_v7)
    end

    it 'detects a Snowflake integer' do
      expect(Philiprehberger::IdGen.detect_format(Philiprehberger::IdGen.snowflake)).to eq(:snowflake)
    end

    it 'detects a numeric Snowflake string' do
      expect(Philiprehberger::IdGen.detect_format(Philiprehberger::IdGen.snowflake.to_s)).to eq(:snowflake)
    end

    it 'detects a CUID2' do
      expect(Philiprehberger::IdGen.detect_format(Philiprehberger::IdGen.cuid2)).to eq(:cuid2)
    end

    it 'detects a Nanoid as the fallback' do
      expect(Philiprehberger::IdGen.detect_format(Philiprehberger::IdGen.nanoid)).to eq(:nanoid)
    end

    it 'returns nil for an unrecognizable string' do
      expect(Philiprehberger::IdGen.detect_format('!@#$%')).to be_nil
    end

    it 'returns nil for nil' do
      expect(Philiprehberger::IdGen.detect_format(nil)).to be_nil
    end
  end
end
