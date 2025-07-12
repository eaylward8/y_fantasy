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

  describe ".fetch_value" do
    it "returns the value of the given key" do
      data = {foo: [1, 2]}
      expect(described_class.fetch_value(data, :foo)).to eq(data[:foo])
    end
  end
end
