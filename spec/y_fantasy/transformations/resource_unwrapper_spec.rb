# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::ResourceUnwrapper do
  describe "#call" do
    context "when given a nested hash with keys that are {plural: {singular: []}}" do
      it "unwraps the nested hash and pluralizes the singular key" do
        data = {games: {game: ["hey"]}}
        unwrapper = described_class.new(:game)
        expect(unwrapper.call(data)).to eq({games: ["hey"]})
      end

      it "handles hashes with multiple plural/singular nestings" do
        data = {games: {game: ["hey"]}, leagues: {league: ["bye"]}}
        unwrapper = described_class.new([:game, :league])
        expect(unwrapper.call(data)).to eq({games: ["hey"], leagues: ["bye"]})
      end

      it "works when args are strings" do
        data = {games: {game: ["hey"]}, leagues: {league: ["bye"]}}
        unwrapper = described_class.new(%w[game league])
        expect(unwrapper.call(data)).to eq({games: ["hey"], leagues: ["bye"]})
      end

      it "works when args are plural" do
        data = {games: {game: ["hey"]}, leagues: {league: ["bye"]}}
        unwrapper = described_class.new(%w[games leagues])
        expect(unwrapper.call(data)).to eq({games: ["hey"], leagues: ["bye"]})
      end

      xit "when not passed args" do
        data = {games: {game: ["hey"]}, leagues: {league: ["bye"]}}
        unwrapper = described_class.new([])
        expect(unwrapper.call(data)).to eq({games: ["hey"], leagues: ["bye"]})
      end
    end
  end
end
