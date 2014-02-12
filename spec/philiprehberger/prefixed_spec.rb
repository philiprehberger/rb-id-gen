# frozen_string_literal: true

require "spec_helper"

RSpec.describe Philiprehberger::IdGen::Prefixed do
  describe ".generate" do
    it "returns a string with prefix followed by underscore and lowercase ULID" do
      result = described_class.generate("usr")
      expect(result).to match(/\Ausr_[0-9a-hjkmnp-tv-z]{26}\z/)
    end

    it "uses the given prefix" do
      result = described_class.generate("cust")
      expect(result).to start_with("cust_")
    end

    it "produces different IDs for different prefixes" do
      id1 = described_class.generate("usr")
      id2 = described_class.generate("org")
      expect(id1[0..3]).not_to eq(id2[0..3])
    end

    it "raises an error for empty prefix" do
      expect { described_class.generate("") }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it "raises an error for nil prefix" do
      expect { described_class.generate(nil) }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it "raises an error for non-lowercase prefix" do
      expect { described_class.generate("Usr") }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it "raises an error for prefix with numbers" do
      expect { described_class.generate("usr1") }.to raise_error(Philiprehberger::IdGen::Error)
    end

    it "raises an error for prefix with special characters" do
      expect { described_class.generate("usr-id") }.to raise_error(Philiprehberger::IdGen::Error)
    end
  end
end
