# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::IdGen::Nanoid do
  describe '.generate' do
    it 'returns a 21-character string by default' do
      nanoid = described_class.generate
      expect(nanoid).to be_a(String)
      expect(nanoid.length).to eq(21)
    end

    it 'respects custom length' do
      nanoid = described_class.generate(10)
      expect(nanoid.length).to eq(10)
    end

    it 'respects custom alphabet' do
      nanoid = described_class.generate(50, alphabet: 'abc')
      expect(nanoid.length).to eq(50)
      expect(nanoid).to match(/\A[abc]+\z/)
    end

    it 'only contains characters from the default alphabet' do
      nanoid = described_class.generate
      expect(nanoid).to match(/\A[A-Za-z0-9_-]+\z/)
    end

    it 'generates 1000 unique nanoids' do
      nanoids = Array.new(1000) { described_class.generate }
      expect(nanoids.uniq.length).to eq(1000)
    end

    it 'raises an error for non-positive size' do
      expect { described_class.generate(0) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for empty alphabet' do
      expect { described_class.generate(10, alphabet: '') }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end
end
