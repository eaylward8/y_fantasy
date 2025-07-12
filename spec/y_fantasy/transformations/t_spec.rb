# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::T do
  describe ".singularize" do
    it "returns a string with the ending 's' removed" do
      expect(described_class.singularize("jawns")).to eq("jawn")
    end

    it "returns original string if not ending in 's'" do
      expect(described_class.singularize("jawn")).to eq("jawn")
    end
  end

  describe ".pluralize" do
    it "returns a string with an 's' added to the end" do
      expect(described_class.pluralize("jawn")).to eq("jawns")
    end

    it "returns original string if ending in 's'" do
      expect(described_class.pluralize("jawns")).to eq("jawns")
    end
  end

  describe ".floatize" do
    it "returns a float when given an integer" do
      expect(described_class.floatize(13)).to eq(13.0)
    end

    it "returns a float when given a float" do
      expect(described_class.floatize(13.5)).to eq(13.5)
    end

    it "returns a float when given a string" do
      expect(described_class.floatize("11")).to eq(11.0)
    end

    it "returns 0.0 when given '-'" do
      expect(described_class.floatize("-")).to eq(0.0)
    end
  end

  describe ".dig_value" do
    it "returns the value of the given key" do
      data = {foo: [1, 2]}
      expect(described_class.dig_value(data, :foo)).to eq(data[:foo])
    end

    it "returns the value of the last given key" do
      data = {foo: {bar: [1, 2]}}
      expect(described_class.dig_value(data, :foo, :bar)).to eq(data[:foo][:bar])
    end
  end

  describe ".wrap_in_array" do
    it "wraps the value in an array" do
      expect(described_class.wrap_in_array(13)).to eq([13])
    end

    it "returns given value if already an array" do
      expect(described_class.wrap_in_array(["yo"])).to eq(["yo"])
    end

    it "returns empty array if value is nil" do
      expect(described_class.wrap_in_array(nil)).to eq([])
    end
  end

  describe ".no_op" do
    it "returns the given value with no modifications" do
      expect(described_class.no_op("Randy Butternubs")).to eq("Randy Butternubs")
    end
  end
end
