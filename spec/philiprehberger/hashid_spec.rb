# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::IdGen::Hashid do
  describe '.encode' do
    it 'encodes zero' do
      result = described_class.encode(0)
      expect(result).to be_a(String)
      expect(result.length).to be >= 8
    end

    it 'encodes positive integers' do
      result = described_class.encode(42)
      expect(result).to be_a(String)
      expect(result.length).to be >= 8
    end

    it 'produces different results with different salts' do
      result1 = described_class.encode(42, salt: 'salt1')
      result2 = described_class.encode(42, salt: 'salt2')
      expect(result1).not_to eq(result2)
    end

    it 'respects min_length' do
      result = described_class.encode(1, min_length: 12)
      expect(result.length).to be >= 12
    end

    it 'produces consistent output for same input and salt' do
      result1 = described_class.encode(42, salt: 'mysalt')
      result2 = described_class.encode(42, salt: 'mysalt')
      expect(result1).to eq(result2)
    end

    it 'raises an error for negative integers' do
      expect { described_class.encode(-1) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for non-integer input' do
      expect { described_class.encode('abc') }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end

  describe '.decode' do
    it 'raises an error for empty string' do
      expect { described_class.decode('') }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for nil' do
      expect { described_class.decode(nil) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for invalid characters' do
      expect { described_class.decode('!!!', salt: 'test') }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'decodes an encoded value with matching salt' do
      salt = 'my-secret-salt'
      encoded = described_class.encode(42, salt: salt)
      decoded = described_class.decode(encoded, salt: salt)
      expect(decoded).to be_a(Integer)
    end
  end
end

RSpec.describe Philiprehberger::IdGen do
  describe '.hashid' do
    it 'encodes an integer into a hashid string' do
      result = described_class.hashid(42)
      expect(result).to be_a(String)
      expect(result.length).to be >= 8
    end

    it 'accepts salt and min_length options' do
      result = described_class.hashid(42, salt: 'test', min_length: 12)
      expect(result.length).to be >= 12
    end
  end
end
