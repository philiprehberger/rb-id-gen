# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::IdGen::Ulid do
  describe '.generate' do
    it 'returns a 26-character string' do
      ulid = described_class.generate
      expect(ulid).to be_a(String)
      expect(ulid.length).to eq(26)
    end

    it 'only contains Crockford base32 characters' do
      ulid = described_class.generate
      expect(ulid).to match(/\A[0-9A-HJKMNP-TV-Z]+\z/)
    end

    it 'is time-sorted (later ULID is lexicographically greater)' do
      ulid1 = described_class.generate
      sleep 0.01
      ulid2 = described_class.generate
      expect(ulid2).to be > ulid1
    end

    it 'generates 1000 unique ULIDs' do
      ulids = Array.new(1000) { described_class.generate }
      expect(ulids.uniq.length).to eq(1000)
    end
  end

  describe '.monotonic' do
    it 'returns a 26-character string' do
      ulid = described_class.monotonic
      expect(ulid).to be_a(String)
      expect(ulid.length).to eq(26)
    end

    it 'generates monotonically ordered ULIDs within the same millisecond' do
      ulids = Array.new(100) { described_class.monotonic }
      expect(ulids).to eq(ulids.sort)
    end

    it 'generates 1000 unique monotonic ULIDs' do
      ulids = Array.new(1000) { described_class.monotonic }
      expect(ulids.uniq.length).to eq(1000)
    end
  end

  describe '.timestamp' do
    it 'extracts the correct Time from a ULID' do
      before = Time.now
      ulid = described_class.generate

      extracted = described_class.timestamp(ulid)
      expect(extracted).to be_a(Time)
      expect(extracted).to be_within(1).of(before)
    end

    it 'raises an error for invalid ULID length' do
      expect { described_class.timestamp('short') }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end
end
