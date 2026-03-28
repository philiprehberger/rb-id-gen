# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::IdGen::Snowflake do
  let(:generator) { Philiprehberger::IdGen::Snowflake::Generator.new(worker_id: 0) }

  describe Philiprehberger::IdGen::Snowflake::Generator do
    describe '#generate' do
      it 'returns an Integer' do
        expect(generator.generate).to be_a(Integer)
      end

      it 'returns a positive value' do
        expect(generator.generate).to be > 0
      end

      it 'fits in 64 bits' do
        id = generator.generate
        expect(id).to be < (1 << 63)
      end

      it 'produces sequentially increasing IDs' do
        id1 = generator.generate
        id2 = generator.generate
        expect(id2).to be > id1
      end

      it 'generates 1000 unique IDs' do
        ids = Array.new(1000) { generator.generate }
        expect(ids.uniq.length).to eq(1000)
      end
    end

    it 'raises an error for invalid worker_id' do
      expect { described_class.new(worker_id: -1) }.to raise_error(Philiprehberger::IdGen::Error)
      expect { described_class.new(worker_id: 1024) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it 'produces different sequences for different worker IDs' do
      gen1 = described_class.new(worker_id: 1)
      gen2 = described_class.new(worker_id: 2)
      id1 = gen1.generate
      id2 = gen2.generate
      expect(id1).not_to eq(id2)
    end

    context 'with custom epoch' do
      let(:custom_epoch) { Time.utc(2015, 1, 1) }
      let(:custom_generator) { described_class.new(worker_id: 0, epoch: custom_epoch) }

      it 'generates a positive ID' do
        id = custom_generator.generate
        expect(id).to be_a(Integer)
        expect(id).to be > 0
      end

      it 'generates different IDs than default epoch' do
        default_id = generator.generate
        custom_id = custom_generator.generate
        expect(default_id).not_to eq(custom_id)
      end

      it 'generates unique IDs' do
        ids = Array.new(100) { custom_generator.generate }
        expect(ids.uniq.length).to eq(100)
      end
    end
  end

  describe '.timestamp' do
    it 'extracts the correct Time from a snowflake ID' do
      before_time = Time.now
      id = generator.generate

      extracted = described_class.timestamp(id)
      expect(extracted).to be_a(Time)
      expect(extracted).to be_within(1).of(before_time)
    end

    it 'extracts the correct Time with a custom epoch' do
      custom_epoch = Time.utc(2015, 1, 1)
      custom_epoch_ms = (custom_epoch.to_f * 1000).to_i
      custom_gen = Philiprehberger::IdGen::Snowflake::Generator.new(worker_id: 0, epoch: custom_epoch)
      id = custom_gen.generate

      extracted = described_class.timestamp(id, epoch_ms: custom_epoch_ms)
      expect(extracted).to be_a(Time)
      expect(extracted).to be_within(1).of(Time.now)
    end
  end
end
