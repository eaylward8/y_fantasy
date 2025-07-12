# frozen_string_literal: true

RSpec.describe YFantasy::ResourceFinder do
  describe ".find_primary" do
    it "returns corresponding primary resource class" do
      described_class::PRIMARY.each do |sym, klass|
        expect(described_class.find_primary(sym)).to eq(klass)
      end
    end
  end

  describe ".find_dependent" do
    it "returns corresponding dependent resource class" do
      described_class::DEPENDENT.each do |sym, klass|
        expect(described_class.find_dependent(sym)).to eq(klass)
      end
    end
  end
end
