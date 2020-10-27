# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'ULID parsing' do
  describe 'IdGen.parse_ulid' do
    it 'returns a hash with timestamp and random keys' do
      ulid = Philiprehberger::IdGen.ulid
      result = Philiprehberger::IdGen.parse_ulid(ulid)
      expect(result).to be_a(Hash)
      expect(result).to have_key(:timestamp)
      expect(result).to have_key(:random)
    end

    it 'extracts the correct timestamp' do
      before = Time.now
      ulid = Philiprehberger::IdGen.ulid
      result = Philiprehberger::IdGen.parse_ulid(ulid)
      expect(result[:timestamp]).to be_a(Time)
      expect(result[:timestamp]).to be_within(1).of(before)
    end

    it 'returns the random component as a hex string' do
      ulid = Philiprehberger::IdGen.ulid
      result = Philiprehberger::IdGen.parse_ulid(ulid)
      expect(result[:random]).to be_a(String)
      expect(result[:random]).to match(/\A[0-9a-f]+\z/)
    end

    it 'returns consistent results for the same ULID' do
      ulid = Philiprehberger::IdGen.ulid
      result1 = Philiprehberger::IdGen.parse_ulid(ulid)
      result2 = Philiprehberger::IdGen.parse_ulid(ulid)
      expect(result1[:random]).to eq(result2[:random])
      expect(result1[:timestamp].to_f).to eq(result2[:timestamp].to_f)
    end

    it 'raises an error for invalid ULID format' do
      expect { Philiprehberger::IdGen.parse_ulid('invalid') }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for non-string input' do
      expect { Philiprehberger::IdGen.parse_ulid(123) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'round-trips with ulid_timestamp' do
      ulid = Philiprehberger::IdGen.ulid
      parsed_time = Philiprehberger::IdGen.parse_ulid(ulid)[:timestamp]
      extracted_time = Philiprehberger::IdGen.ulid_timestamp(ulid)
      expect(parsed_time.to_f).to eq(extracted_time.to_f)
    end
  end
end
