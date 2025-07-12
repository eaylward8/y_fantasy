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
  end

  describe ".numeric_values_to_ints" do
    it "coerces values that are string integers to integers" do
      data = {a: "1", b: "two"}
      expect(described_class.numeric_values_to_ints(data)).to eq({a: 1, b: "two"})
    end
  end
end
