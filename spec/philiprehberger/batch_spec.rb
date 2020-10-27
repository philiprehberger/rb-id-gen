# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Batch generation' do
  describe 'IdGen.ulid_batch' do
    it 'returns an array of the specified count' do
      result = Philiprehberger::IdGen.ulid_batch(5)
      expect(result).to be_an(Array)
      expect(result.length).to eq(5)
    end

    it 'returns unique ULIDs' do
      result = Philiprehberger::IdGen.ulid_batch(100)
      expect(result.uniq.length).to eq(100)
    end

    it 'returns valid ULIDs' do
      result = Philiprehberger::IdGen.ulid_batch(3)
      result.each do |ulid|
        expect(ulid.length).to eq(26)
        expect(ulid).to match(/\A[0-9A-HJKMNP-TV-Z]+\z/)
      end
    end

    it 'raises an error for non-positive count' do
      expect { Philiprehberger::IdGen.ulid_batch(0) }.to raise_error(Philiprehberger::IdGen::Error)
      expect { Philiprehberger::IdGen.ulid_batch(-1) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for non-integer count' do
      expect { Philiprehberger::IdGen.ulid_batch('5') }.to raise_error(Philiprehberger::IdGen::Error)
      expect { Philiprehberger::IdGen.ulid_batch(1.5) }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end

  describe 'IdGen.nanoid_batch' do
    it 'returns an array of the specified count' do
      result = Philiprehberger::IdGen.nanoid_batch(5)
      expect(result).to be_an(Array)
      expect(result.length).to eq(5)
    end

    it 'returns unique nanoids' do
      result = Philiprehberger::IdGen.nanoid_batch(100)
      expect(result.uniq.length).to eq(100)
    end

    it 'accepts custom size and alphabet' do
      result = Philiprehberger::IdGen.nanoid_batch(3, size: 10, alphabet: 'abc')
      result.each do |nanoid|
        expect(nanoid.length).to eq(10)
        expect(nanoid).to match(/\A[abc]+\z/)
      end
    end

    it 'raises an error for non-positive count' do
      expect { Philiprehberger::IdGen.nanoid_batch(0) }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end

  describe 'IdGen.uuid_v7_batch' do
    it 'returns an array of the specified count' do
      result = Philiprehberger::IdGen.uuid_v7_batch(5)
      expect(result).to be_an(Array)
      expect(result.length).to eq(5)
    end

    it 'returns unique UUID v7s' do
      result = Philiprehberger::IdGen.uuid_v7_batch(100)
      expect(result.uniq.length).to eq(100)
    end

    it 'returns valid UUID v7s' do
      result = Philiprehberger::IdGen.uuid_v7_batch(3)
      result.each do |uuid|
        expect(Philiprehberger::IdGen.valid_uuid_v7?(uuid)).to be true
      end
    end

    it 'raises an error for non-positive count' do
      expect { Philiprehberger::IdGen.uuid_v7_batch(0) }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end

  describe 'IdGen.prefixed_batch' do
    it 'returns an array of the specified count' do
      result = Philiprehberger::IdGen.prefixed_batch('usr', 5)
      expect(result).to be_an(Array)
      expect(result.length).to eq(5)
    end

    it 'returns unique prefixed IDs' do
      result = Philiprehberger::IdGen.prefixed_batch('usr', 100)
      expect(result.uniq.length).to eq(100)
    end

    it 'returns IDs with the correct prefix' do
      result = Philiprehberger::IdGen.prefixed_batch('org', 3)
      result.each do |id|
        expect(id).to start_with('org_')
      end
    end

    it 'raises an error for non-positive count' do
      expect { Philiprehberger::IdGen.prefixed_batch('usr', 0) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'raises an error for invalid prefix' do
      expect { Philiprehberger::IdGen.prefixed_batch('', 5) }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end
end
