# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::IdGen::Encoder do
  describe '.encode' do
    it 'encodes zero' do
      expect(described_class.encode(0)).to eq('0')
    end

    it 'encodes small integers' do
      result = described_class.encode(42)
      expect(result).to be_a(String)
      expect(result.length).to be >= 1
    end

    it 'encodes large integers' do
      result = described_class.encode(999_999_999)
      expect(result).to be_a(String)
      expect(result.length).to be >= 1
    end

    it 'encodes with a custom alphabet' do
      result = described_class.encode(255, alphabet: '0123456789abcdef')
      expect(result).to eq('ff')
    end

    it 'raises an error for negative integers' do
      expect { described_class.encode(-1) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for non-integer input' do
      expect { described_class.encode('abc') }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end

  describe '.decode' do
    it 'decodes an encoded value back to the original' do
      [0, 1, 42, 1000, 999_999_999].each do |n|
        encoded = described_class.encode(n)
        expect(described_class.decode(encoded)).to eq(n)
      end
    end

    it 'decodes with a custom alphabet' do
      encoded = described_class.encode(255, alphabet: '0123456789abcdef')
      expect(described_class.decode(encoded, alphabet: '0123456789abcdef')).to eq(255)
    end

    it 'raises an error for empty string' do
      expect { described_class.decode('') }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for nil' do
      expect { described_class.decode(nil) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for characters not in alphabet' do
      expect { described_class.decode('!!!') }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end

  describe 'round-trip' do
    it 'encodes and decodes consistently' do
      100.times do
        value = rand(0..10_000_000)
        expect(described_class.decode(described_class.encode(value))).to eq(value)
      end
    end
  end
end

RSpec.describe Philiprehberger::IdGen do
  describe '.encode' do
    it 'delegates to Encoder.encode' do
      expect(described_class.encode(42)).to eq(Philiprehberger::IdGen::Encoder.encode(42))
    end
  end

  describe '.decode' do
    it 'delegates to Encoder.decode' do
      encoded = described_class.encode(42)
      expect(described_class.decode(encoded)).to eq(42)
    end
  end
end
