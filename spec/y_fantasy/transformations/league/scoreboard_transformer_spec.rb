# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::League::ScoreboardTransformer do
  describe "#call" do
    let(:data) do
      {
        league_key: "123.l.456789",
        scoreboard: {
          week: 1,
          matchups: {
            matchup: [
              {week: 1},
              {week: 1}
            ]
          }
        }
      }
    end

    let(:expected) do
      {
        league_key: "123.l.456789",
        scoreboard: {
          week: 1,
          matchups: [
            {week: 1, teams: []},
            {week: 1, teams: []}
          ]
        }
      }
    end

    it "transforms the scoreboard value, using MatchupsTransformer" do
      expect(YFantasy::Transformations::MatchupsTransformer).to receive(:new).and_call_original
      expect(described_class.new.call(data)).to eq(expected)
    end
  end
end
