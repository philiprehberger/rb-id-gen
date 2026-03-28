# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::IdGen::Uuid do
  describe '.generate_v7' do
    it 'returns a lowercase hyphenated UUID string' do
      uuid = described_class.generate_v7
      expect(uuid).to be_a(String)
      expect(uuid).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end

    it 'has version 7 in the correct position' do
      uuid = described_class.generate_v7
      expect(uuid[14]).to eq('7')
    end

    it 'has variant bits set correctly (10xx)' do
      uuid = described_class.generate_v7
      variant_char = uuid[19]
      expect(%w[8 9 a b]).to include(variant_char)
    end

    it 'generates unique UUIDs' do
      uuids = Array.new(1000) { described_class.generate_v7 }
      expect(uuids.uniq.length).to eq(1000)
    end

    it 'is time-ordered (later UUID sorts greater)' do
      uuid1 = described_class.generate_v7
      sleep 0.01
      uuid2 = described_class.generate_v7
      expect(uuid2).to be > uuid1
    end

    it 'has correct length of 36 characters' do
      uuid = described_class.generate_v7
      expect(uuid.length).to eq(36)
    end
  end

  describe '.timestamp_v7' do
    it 'extracts a Time from a UUID v7' do
      uuid = described_class.generate_v7
      extracted = described_class.timestamp_v7(uuid)
      expect(extracted).to be_a(Time)
      expect(extracted).to be_within(1).of(Time.now)
    end

    it 'raises an error for invalid UUID v7 format' do
      expect { described_class.timestamp_v7('not-a-uuid') }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for UUID v4 format' do
      uuid_v4 = 'a1b2c3d4-e5f6-4a7b-8c9d-e0f1a2b3c4d5'
      expect { described_class.timestamp_v7(uuid_v4) }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end

  describe '.valid_v7?' do
    it 'returns true for valid UUID v7' do
      uuid = described_class.generate_v7
      expect(described_class.valid_v7?(uuid)).to be true
    end

    it 'returns false for non-string input' do
      expect(described_class.valid_v7?(123)).to be false
    end

    it 'returns false for wrong version' do
      expect(described_class.valid_v7?('a1b2c3d4-e5f6-4a7b-8c9d-e0f1a2b3c4d5')).to be false
    end

    it 'returns false for wrong variant' do
      expect(described_class.valid_v7?('a1b2c3d4-e5f6-7a7b-0c9d-e0f1a2b3c4d5')).to be false
    end

    it 'returns false for uppercase' do
      expect(described_class.valid_v7?('A1B2C3D4-E5F6-7A7B-8C9D-E0F1A2B3C4D5')).to be false
    end
  end
end
