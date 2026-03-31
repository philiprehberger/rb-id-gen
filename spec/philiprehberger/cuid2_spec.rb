# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::IdGen::Cuid2 do
  describe '.generate' do
    it 'generates a string of default length 24' do
      result = described_class.generate
      expect(result).to be_a(String)
      expect(result.length).to eq(24)
    end

    it 'starts with a lowercase letter' do
      20.times do
        result = described_class.generate
        expect(result[0]).to match(/[a-z]/)
      end
    end

    it 'contains only lowercase alphanumeric characters' do
      result = described_class.generate
      expect(result).to match(/\A[a-z0-9]+\z/)
    end

    it 'generates unique IDs' do
      ids = Array.new(100) { described_class.generate }
      expect(ids.uniq.length).to eq(100)
    end

    it 'accepts a custom length' do
      result = described_class.generate(10)
      expect(result.length).to eq(10)
    end

    it 'accepts minimum length of 2' do
      result = described_class.generate(2)
      expect(result.length).to eq(2)
    end

    it 'accepts maximum length of 32' do
      result = described_class.generate(32)
      expect(result.length).to eq(32)
    end

    it 'raises an error for length below 2' do
      expect { described_class.generate(1) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for length above 32' do
      expect { described_class.generate(33) }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end
end

RSpec.describe Philiprehberger::IdGen do
  describe '.cuid2' do
    it 'generates a CUID2 with default length' do
      result = described_class.cuid2
      expect(result.length).to eq(24)
    end

    it 'generates a CUID2 with custom length' do
      result = described_class.cuid2(length: 16)
      expect(result.length).to eq(16)
    end
  end

  describe '.cuid2_batch' do
    it 'generates the requested number of CUID2s' do
      results = described_class.cuid2_batch(5)
      expect(results.length).to eq(5)
      expect(results.uniq.length).to eq(5)
    end

    it 'raises an error for non-positive count' do
      expect { described_class.cuid2_batch(0) }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end

  describe '.valid_cuid2?' do
    it 'returns true for a valid CUID2' do
      cuid2 = described_class.cuid2
      expect(described_class.valid_cuid2?(cuid2)).to be true
    end

    it 'returns false for wrong length' do
      expect(described_class.valid_cuid2?('abc')).to be false
    end

    it 'returns false for uppercase characters' do
      expect(described_class.valid_cuid2?("A#{'a' * 23}")).to be false
    end

    it 'returns false for non-string input' do
      expect(described_class.valid_cuid2?(12_345)).to be false
    end

    it 'validates against custom length' do
      cuid2 = described_class.cuid2(length: 16)
      expect(described_class.valid_cuid2?(cuid2, length: 16)).to be true
    end
  end
end
