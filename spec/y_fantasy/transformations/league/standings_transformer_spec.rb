# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::League::StandingsTransformer do
  describe "#call" do
    let(:data) do
      {
        league_key: "123.l.456789",
        standings: {
          teams: {
            team: [
              {team_id: 1},
              {team_id: 2}
            ]
          }
        }
      }
    end

    let(:expected) do
      {
        league_key: "123.l.456789",
        standings: {
          teams: [
            {team_id: 1, managers: [], stats: {}},
            {team_id: 2, managers: [], stats: {}}
          ]
        }
      }
    end

    it "transforms the scoreboard value, using MatchupsTransformer" do
      expect(YFantasy::Transformations).to receive(:team_transformer).with(nested: true).and_call_original
      expect(described_class.new.call(data)).to eq(expected)
    end
  end
end
