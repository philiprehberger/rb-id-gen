# frozen_string_literal: true

require "spec_helper"

RSpec.describe Philiprehberger::IdGen do
  describe "VERSION" do
    it "has a version number" do
      expect(Philiprehberger::IdGen::VERSION).not_to be_nil
    end

    it "follows semantic versioning format" do
      expect(Philiprehberger::IdGen::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end
  end

  describe ".ulid" do
    it "returns a 26-character string" do
      expect(described_class.ulid).to be_a(String)
      expect(described_class.ulid.length).to eq(26)
    end
  end

  describe ".ulid_monotonic" do
    it "returns a 26-character string" do
      expect(described_class.ulid_monotonic).to be_a(String)
      expect(described_class.ulid_monotonic.length).to eq(26)
    end
  end

  describe ".ulid_timestamp" do
    it "extracts a Time from a ULID" do
      ulid = described_class.ulid
      result = described_class.ulid_timestamp(ulid)
      expect(result).to be_a(Time)
      expect(result).to be_within(1).of(Time.now)
    end
  end

  describe ".nanoid" do
    it "returns a 21-character string by default" do
      expect(described_class.nanoid).to be_a(String)
      expect(described_class.nanoid.length).to eq(21)
    end

    it "accepts custom size" do
      expect(described_class.nanoid(10).length).to eq(10)
    end
  end

  describe ".prefixed" do
    it "returns a prefixed ID string" do
      result = described_class.prefixed("usr")
      expect(result).to start_with("usr_")
    end
  end

  describe ".snowflake" do
    it "returns an Integer" do
      expect(described_class.snowflake).to be_a(Integer)
    end

    it "accepts worker_id keyword" do
      expect(described_class.snowflake(worker_id: 1)).to be_a(Integer)
    end
  end

  describe ".snowflake_timestamp" do
    it "extracts a Time from a snowflake ID" do
      id = described_class.snowflake
      result = described_class.snowflake_timestamp(id)
      expect(result).to be_a(Time)
      expect(result).to be_within(1).of(Time.now)
    end
  end
end
