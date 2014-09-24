# frozen_string_literal: true

require "spec_helper"

RSpec.describe Philiprehberger::IdGen::Snowflake do
  let(:generator) { Philiprehberger::IdGen::Snowflake::Generator.new(worker_id: 0) }

  describe Philiprehberger::IdGen::Snowflake::Generator do
    describe "#generate" do
      it "returns an Integer" do
        expect(generator.generate).to be_a(Integer)
      end

      it "returns a positive value" do
        expect(generator.generate).to be > 0
      end

      it "fits in 64 bits" do
        id = generator.generate
        expect(id).to be < (1 << 63)
      end

      it "produces sequentially increasing IDs" do
        id1 = generator.generate
        id2 = generator.generate
        expect(id2).to be > id1
      end

      it "generates 1000 unique IDs" do
        ids = Array.new(1000) { generator.generate }
        expect(ids.uniq.length).to eq(1000)
      end
    end

    it "raises an error for invalid worker_id" do
      expect { described_class.new(worker_id: -1) }.to raise_error(Philiprehberger::IdGen::Error)
      expect { described_class.new(worker_id: 1024) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it "produces different sequences for different worker IDs" do
      gen1 = described_class.new(worker_id: 1)
      gen2 = described_class.new(worker_id: 2)
      id1 = gen1.generate
      id2 = gen2.generate
      expect(id1).not_to eq(id2)
    end
  end

  describe ".timestamp" do
    it "extracts the correct Time from a snowflake ID" do
      before = Time.now
      id = generator.generate
      after = Time.now

      extracted = described_class.timestamp(id)
      expect(extracted).to be_a(Time)
      expect(extracted).to be_within(1).of(before)
    end
  end
end
