# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::DefaultTransformer do
  describe "#call" do
    let(:data) { {games: {game: ["nfl"]}} }
    let(:expected) { {games: ["nfl"]} }

    context "when given a nested hash with keys that are {plural: {singular: []}}" do
      it "sets the plural key to the value of the singular key" do
        expect(described_class.new(:game).call(data)).to eq(expected)
      end

      it "works when arg is a string" do
        expect(described_class.new("game").call(data)).to eq(expected)
      end

      it "works when arg is plural" do
        expect(described_class.new("games").call(data)).to eq(expected)
      end

      it "returns original data when args are nil/empty" do
        expect(described_class.new(nil).call(data)).to eq(data)
      end
    end
  end
end
